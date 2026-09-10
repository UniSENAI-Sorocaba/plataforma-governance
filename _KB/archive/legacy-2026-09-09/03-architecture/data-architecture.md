---
title: "Arquitetura de Dados e Persistência PostgreSQL"
domain: "architecture"
status: "accepted"
owner: "Luciano Jr / Isabelly"
last_updated: "2026-08-27"
---

# 🗄️ Arquitetura de Dados & Persistência PostgreSQL

A persistência de dados da plataforma é unificada em uma única instância do **Amazon RDS PostgreSQL 16**, particionada semanticamente em **PostgreSQL Schemas isolados**.

---

## 1. Estratégia de Schemas do PostgreSQL

```
+--------------------------------------------------------------------------------------------------------------------+
|                                    ESTRUTURA DE SCHEMAS POSTGRESQL                                                 |
+-------------------+-------------------------------------------------------------------------+----------------------+
| SCHEMA            | DOMÍNIO & RESPONSABILIDADE                                              | FASE / STATUS        |
+-------------------+-------------------------------------------------------------------------+----------------------+
| `auth`            | Usuários, perfis (roles), credenciais, sessões ativas e auditoria.      | **ESCOPO DEZEMBRO**  |
| `academic_pi`     | Propostas (inc. híbridos), equipes, bancas, rubricas de avaliação/notas.| **ESCOPO DEZEMBRO**  |
| `extension`       | Editais de extensão, inscrições, relatórios de atividades, certificados.| **ESCOPO DEZEMBRO**  |
| `assets`          | Notebooks, etiquetas QR Code, agendamento de salas e ocorrências.       | *Fase 2 (Próx. Sem.)*|
| `institutional`   | Formulários de autoavaliação da CPA e manifestações da ouvidoria.       | *Fase 2 (Próx. Sem.)*|
| `careers`         | Perfis profissionais, banco de currículos e mural de vagas de estágio.  | *Fase 2 (Próx. Sem.)*|
+-------------------+-------------------------------------------------------------------------+----------------------+
```

---

## 2. Script DDL do Escopo Obrigatório — Dezembro (SQL)

```sql
-- Criação dos Schemas Isolados do MVP
CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS academic_pi;
CREATE SCHEMA IF NOT EXISTS extension;

-- SCHEMA: auth
CREATE TYPE auth.user_role AS ENUM ('STUDENT', 'PROFESSOR', 'COORDINATOR', 'CPA', 'ADMIN');

CREATE TABLE auth.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role auth.user_role NOT NULL DEFAULT 'STUDENT',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE auth.sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    refresh_token_hash VARCHAR(255) NOT NULL,
    user_agent VARCHAR(512),
    ip_address VARCHAR(45),
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE auth.audit_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    schema_name VARCHAR(50) NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id UUID,
    ip_address VARCHAR(45),
    payload JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- SCHEMA: academic_pi
CREATE TYPE academic_pi.project_status AS ENUM ('PROPOSED', 'APPROVED', 'IN_PROGRESS', 'EVALUATED', 'ARCHIVED');
CREATE TYPE academic_pi.project_type AS ENUM ('ACADEMIC_PI', 'EXTENSION', 'HYBRID');

CREATE TABLE academic_pi.projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    project_type academic_pi.project_type NOT NULL DEFAULT 'ACADEMIC_PI',
    status academic_pi.project_status NOT NULL DEFAULT 'PROPOSED',
    semester VARCHAR(10) NOT NULL, -- Ex: '2026.2'
    leader_id UUID NOT NULL REFERENCES auth.users(id),
    community_impact_summary TEXT, -- Módulo de prestação de contas e impacto
    social_beneficiaries_count INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE academic_pi.project_members (
    project_id UUID NOT NULL REFERENCES academic_pi.projects(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (project_id, user_id)
);

CREATE TABLE academic_pi.examination_boards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID UNIQUE NOT NULL REFERENCES academic_pi.projects(id) ON DELETE CASCADE,
    scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL,
    room_or_link VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE academic_pi.board_evaluators (
    board_id UUID NOT NULL REFERENCES academic_pi.examination_boards(id) ON DELETE CASCADE,
    evaluator_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    PRIMARY KEY (board_id, evaluator_id)
);

CREATE TABLE academic_pi.evaluations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    board_id UUID NOT NULL REFERENCES academic_pi.examination_boards(id) ON DELETE CASCADE,
    evaluator_id UUID NOT NULL REFERENCES auth.users(id),
    technical_grade NUMERIC(4,2) CHECK (technical_grade >= 0 AND technical_grade <= 10),
    presentation_grade NUMERIC(4,2) CHECK (presentation_grade >= 0 AND presentation_grade <= 10),
    artifact_grade NUMERIC(4,2) CHECK (artifact_grade >= 0 AND artifact_grade <= 10),
    final_grade NUMERIC(4,2) NOT NULL,
    feedback TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(board_id, evaluator_id)
);

-- SCHEMA: extension
CREATE TABLE extension.edicts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_hours_granted INT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE extension.activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    edict_id UUID NOT NULL REFERENCES extension.edicts(id),
    student_id UUID NOT NULL REFERENCES auth.users(id),
    title VARCHAR(255) NOT NULL,
    hours_requested INT NOT NULL CHECK (hours_requested > 0),
    hours_approved INT DEFAULT 0,
    evidence_s3_key VARCHAR(512) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING', -- 'PENDING', 'APPROVED', 'REJECTED'
    reviewer_id UUID REFERENCES auth.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE extension.certificates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES auth.users(id),
    activity_id UUID UNIQUE NOT NULL REFERENCES extension.activities(id),
    validation_hash VARCHAR(64) UNIQUE NOT NULL, -- SHA-256
    pdf_s3_key VARCHAR(512) NOT NULL,
    issued_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices Estratégicos de Alta Performance
CREATE INDEX idx_users_email ON auth.users(email);
CREATE INDEX idx_projects_semester ON academic_pi.projects(semester);
CREATE INDEX idx_projects_type ON academic_pi.projects(project_type);
CREATE INDEX idx_evaluations_board ON academic_pi.evaluations(board_id);
CREATE INDEX idx_activities_student ON extension.activities(student_id);
CREATE INDEX idx_certificates_hash ON extension.certificates(validation_hash);
```

---

## 3. Política de Migrations e Backups
* **Migrations:** Gerenciadas via Prisma Migrate (`apps/api-server/prisma/migrations`). Nenhuma migration pode conter operações destrutivas diretas sem migração em duas fases (*Expand and Contract*).
* **Backups RDS:** Snapshots automáticos diários retidos por 7 dias com Point-in-Time Recovery (PITR) ativado na AWS.

---

## 4. Documentos Relacionados
* [ADR-002 — Isolamento por Schemas no PostgreSQL](adr/ADR-002-postgresql-schema-isolation.md)
* [Diretrizes de Banco para Desenvolvedores](../04-development/database-guidelines.md)
* [Runbook de Restauração](../10-runbooks/rollback.md)
