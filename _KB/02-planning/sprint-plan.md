---
title: "Planejamento Detalhado de Sprints (Sprint 0 a 6 — MVP Dezembro)"
domain: "planning"
status: "accepted"
owner: "Fellipe Raszejas / Luciano Jr"
last_updated: "2026-08-27"
---

# 🏃 Planejamento Detalhado de Sprints (Sprint 0 a 6 — MVP Dezembro)

Detalhamento operacional das 7 Sprints do semestre atual, dedicadas integralmente à construção, consolidação, testes e implantação do **Escopo Obrigatório do MVP com Go-Live no Início de Dezembro**.

---

## 🛠️ SPRINT 0 — Setup, Infraestrutura Base & Monorepo (Semanas 1 e 2)
* **Sprint Goal:** Estabelecer a fundação técnica, pipeline de CI/CD operando, monorepo estruturado e PoC de autenticação funcional.
* **Entregáveis Técnicos:**
  * Monorepo Turborepo + pnpm configurado com ESLint, Prettier e TypeScript.
  * Módulos base do Terraform aplicados (VPC, Subnets, ECS Cluster, ECR, RDS PostgreSQL 16).
  * Pipeline de CI no GitHub Actions validando Lint, Typecheck e Testes.
  * Dockerfiles multi-stage da API e Webapps testados localmente via docker-compose.
  * Schema inicial de banco (`auth`) criado via migrations.
* **Entregáveis Funcionais:**
  * Design System inicial no Storybook com componentes base (Button, Input, Card, Modal, Table).

---

## 🧱 SPRINT 1 — Fundação de Identidade & Captação de Projetos (Semanas 3 e 4)
* **Sprint Goal:** Entregar o sistema central de login institucional com emissão de tokens JWT e fluxo de captação de propostas de PI e editais de extensão.
* **Entregáveis Técnicos:**
  * Módulo `auth` completo: endpoints `/login`, `/refresh`, `/logout` com hashing Argon2id.
  * Middlewares de autenticação e guards de rotas integrados no backend.
  * Schemas `academic_pi` e `extension` criados no PostgreSQL.
  * Ambiente de Staging rodando no ECS com deploy contínuo ativo.
* **Entregáveis Funcionais:**
  * Tela de Login unificada com redirecionamento baseado no perfil (RBAC).
  * Captação de propostas de Projetos Integradores e extensão (modelos híbridos) (US05).
  * Cadastro e publicação de Editais de Extensão (US09).

---

## ⚙️ SPRINT 2 — Gestão de Equipes, Bancas PI & Validação de Horas (Semanas 5 e 6)
* **Sprint Goal:** Operacionalizar a gestão de equipes/alunos, agendamento de bancas examinadoras de PI e o fluxo de submissão e validação de horas de extensão.
* **Entregáveis Técnicos:**
  * Integração do backend com AWS S3 para upload seguro de relatórios e evidências via URLs pré-assinadas.
  * Testes de integração cobrindo 100% das rotas de equipes e horas com Testcontainers.
* **Entregáveis Funcionais:**
  * Alocação e gestão de equipes de estudantes com convites e status de integrantes.
  * Gestão e agendamento de Bancas Examinadoras com vínculo de professores avaliadores (US06).
  * Submissão de relatórios de atividades de extensão pelo discente (US10).
  * Painel do docente orientador para deferimento/indeferimento de horas extensionistas com cômputo automatizado.

---

## 📊 SPRINT 3 — Avaliação Docente, Notas, Certificados & Vitrine Pública (Semanas 7 e 8)
* **Sprint Goal:** Concluir a avaliação docente por rubricas, cálculo automatizado de notas de PI, emissão de certificados digitais e vitrine pública.
* **Entregáveis Técnicos:**
  * Serviço de geração de certificados em PDF assinados com hash SHA-256 e QR Code.
  * Otimização de consultas SQL com índices e cache CDN no CloudFront para o Portal.
  * Configuração de alarmes e dashboards de observabilidade no CloudWatch.
* **Entregáveis Funcionais:**
  * Avaliação docente por rubricas estruturadas e cálculo consolidado de médias de PI (US07).
  * Emissão de certificados de extensão validados publicamente por código hash (US11).
  * Catálogo público responsivo contendo projetos integradores e de extensão (US12).

---

## 🌐 SPRINT 4 — Prestação de Contas Social, SEO & Integração Ponta a Ponta (Semanas 9 e 10)
* **Sprint Goal:** Implementar o módulo de divulgação de impacto social e prestação de contas, otimizar SEO e consolidar os fluxos integrados do MVP.
* **Entregáveis Técnicos:**
  * Implementação de Server-Side Rendering (SSR) e Static Site Generation (SSG) no portal público.
  * Suíte de testes automatizados E2E (Playwright) cobrindo todos os fluxos do Core MVP.
* **Entregáveis Funcionais:**
  * Módulo de prestação de contas social e divulgação de impactos comunitários dos projetos (US13).
  * Busca facetada por curso, semestre e Objetivos de Desenvolvimento Sustentável (ODS).
  * Validador público de certificados acessível por qualquer cidadão.

---

## 🛡️ SPRINT 5 — Hardening de Engenharia, Testes de Carga & Segurança (Semanas 11 e 12)
* **Sprint Goal:** Executar testes de carga sob estresse, auditoria completa de segurança e estabilização de qualidade em Staging.
* **Entregáveis Técnicos:**
  * Testes de carga com k6 simulando 200 RPS concorrentes (p95 $< 500\text{ms}$).
  * Scan de vulnerabilidades estáticas (Trivy/SonarQube) e dinâmicas (OWASP ZAP).
  * Ajuste fino de auto-scaling no ECS Fargate e limites de conexões do PostgreSQL RDS.
* **Entregáveis Funcionais:**
  * Resolução de bugs de usabilidade e responsividade identificados nos testes de aceitação.

---

## 🚀 SPRINT 6 — Homologação Final, Deploy em Produção & Go-Live Dezembro (Semanas 13 e 14)
* **Sprint Goal:** Homologar formalmente o MVP com os stakeholders, realizar o deploy da Release v1.0 em Produção no início de dezembro e concluir a documentação.
* **Entregáveis Técnicos & Funcionais:**
  * Homologação formal assinada pelos Product Owners e Docentes Orientadores.
  * **DEPLOY EM PRODUÇÃO DA RELEASE v1.0 (INÍCIO DE DEZEMBRO)**.
  * Checklist de encerramento do semestre e plano de transição para a Fase 2 (Próximo Semestre).
  * Apresentação pública da plataforma em funcionamento para a banca avaliadora.

---

## ⏳ FASE 2: PLANEJAMENTO DO PRÓXIMO SEMESTRE (2027.1)
* **Módulos Postergados para Desenvolvimento Futuro:**
  * **Gestão Patrimonial:** Notebooks com QR Code, check-in/out, salas e avarias.
  * **Carreira & Oportunidades:** Banco de currículos e mural de vagas de estágio.
  * **Iniciação Científica & Tecnológica:** Editais de IC/IT, bolsas e planos de trabalho.
  * **CPA & Ouvidoria:** Autoavaliação periódica, avaliação de serviços e relatos confidenciais.

---

## 2. Documentos Relacionados
* [Roadmap do Projeto](roadmap.md)
* [Plano de Releases](release-plan.md)
* [Definition of Done](../09-governance/definition-of-done.md)
