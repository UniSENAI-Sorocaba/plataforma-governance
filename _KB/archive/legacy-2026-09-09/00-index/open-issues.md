---
title: "Registro de Questões em Aberto e Conflitos Identificados"
domain: "index"
status: "accepted"
owner: "Luciano Jr"
last_updated: "2026-08-27"
---

# ⚠️ Registro de Questões em Aberto e Conflitos Identificados

Este documento registra oficialmente todas as divergências, inconsistências conceituais e decisões do projeto. Cada item possui uma análise de impacto e a recomendação técnica adotada na Knowledge Base.

---

## 1. Conflito: Estrutura Organizacional — 5 Silos Funcionais vs. Squads Multifuncionais
* **Contexto:** O documento `equipes.md` definia uma divisão técnica por silos, enquanto `proposta.md` propunha squads multifuncionais.
* **Decisão Adotada na KB:** Estruturação em **4 Squads Multifuncionais** orientadas a valor para o MVP de Dezembro (Squad Core/SSO, Squad Acadêmico PI, Squad Extensão & Horas, Squad Portal & QA), combinadas com lideranças técnicas de especialidade transversais.
* **Status:** `Accepted` (Consolidado em [Estrutura de Equipe](../09-governance/team-structure.md)).

---

## 2. Conflito: Quantidade Total de Integrantes (24 vs. 25 Alunos)
* **Contexto:** Divergência numérica entre documentos preliminares.
* **Decisão Adotada na KB:** Número oficial consolidado em **25 integrantes discentes** (2 POs + 23 engenheiros/especialistas), conforme a listagem nominal oficial.
* **Status:** `Accepted`.

---

## 3. Conflito: Estratégia de Branches Git — GitFlow Clássico vs. GitHub Flow com Develop
* **Contexto:** O GitFlow clássico foi considerado burocrático e lento para 25 pessoas em monorepo com entregas quinzenais de CI/CD.
* **Decisão Adotada na KB:** Adoção do **GitHub Flow Modificado** (branch `develop` para Staging contínuo e `main` para releases de Produção via tags SemVer com *Squash and Merge*).
* **Status:** `Accepted` (Consolidado em [Estratégia de Branching](../04-development/branching-strategy.md)).

---

## 4. Conflito: Escolha de Plataforma de Computação AWS — ECS Fargate vs. App Runner
* **Contexto:** Definição da plataforma de contêineres gerenciada na AWS.
* **Decisão Adotada na KB:** Adoção definitiva do **AWS ECS Fargate**, que oferece controle total de VPC privada Multi-AZ, execução de migrations efêmeras e custos reduzidos.
* **Status:** `Accepted` (Registrado no [ADR-004](../03-architecture/adr/ADR-004-aws-ecs-fargate-platform.md)).

---

## 5. Decisão de Priorização: Escopo Obrigatório (Dezembro) vs. Fase 2 (Próximo Semestre)
* **Contexto:** Necessidade de garantir a entrega de um produto de software robusto, auditável e 100% testado até o início de dezembro por 25 pessoas.
* **Decisão Adotada na KB:**
  * **Escopo Obrigatório — Dezembro (MVP):** 1. SSO/IAM Central, 2. Projetos Integradores & Extensão (inc. modelos híbridos, captação, equipes, bancas, avaliação, horas, notas e certificados) e 3. Portal Público (Vitrine de Ações, impacto social e prestação de contas).
  * **Backlog / Fase 2 (Próximo Semestre):** Gestão Patrimonial, Carreiras, Iniciação Científica e CPA/Ouvidoria postergados integralmente para 2027.1.
* **Status:** `Accepted` (Consolidado em [Delimitação do MVP](../01-product/mvp.md) e [Roadmap](../02-planning/roadmap.md)).

---

## 6. Decisão Pendente: Framework Backend — NestJS vs. Fastify Puro com TypeScript
* **Contexto:** A arquitetura do Monólito Modular exige injeção de dependências e documentação OpenAPI automática.
* **Proposta Atual:** **NestJS** com runtime Node.js 20.
* **Ponto de Validação:** Homologação final com Marco (Tech Lead Backend) e Luciano Jr na Sprint 0.
* **Status:** `Proposed` (Consolidado em [ADR-001](../03-architecture/adr/ADR-001-modular-monolith-architecture.md)).

---

## 7. Decisão Pendente: Provedor de E-mails Transacionais para Notificações e Senhas
* **Contexto:** Envio de e-mails para confirmação de conta, reset de senha e alertas de bancas.
* **Alternativas:** Amazon SES vs. Resend / SendGrid.
* **Responsável:** Fazano (Cloud Lead) e Luciano Jr.
* **Status:** `Open` (Previsão de definição na Sprint 1).
