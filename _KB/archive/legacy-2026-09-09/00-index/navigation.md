---
title: "Mapa de Navegação da Knowledge Base"
domain: "index"
status: "accepted"
owner: "Luciano Jr"
last_updated: "2026-08-27"
---

# 🗺️ Mapa de Navegação da Knowledge Base

Índice hierárquico com links relativos para todos os documentos da base de conhecimento.

---

## [00-index/](README.md)
* [README.md](README.md) — Visão geral da Knowledge Base e estrutura.
* [navigation.md](navigation.md) — Mapa de navegação completo (este documento).
* [glossary.md](glossary.md) — Glossário unificado de termos técnicos e de negócio.
* [open-issues.md](open-issues.md) — Registro de conflitos, dúvidas e decisões abertas.

---

## [01-product/](../01-product/vision.md)
* [vision.md](../01-product/vision.md) — Declaração de visão e proposta de valor por persona.
* [scope.md](../01-product/scope.md) — Escopo geral e fronteiras dos domínios.
* [stakeholders.md](../01-product/stakeholders.md) — Mapeamento de stakeholders e expectativas institucionais.
* [personas.md](../01-product/personas.md) — Perfis de usuários e jornadas de uso.
* [modules.md](../01-product/modules.md) — Detalhamento funcional de todos os módulos.
* [mvp.md](../01-product/mvp.md) — Delimitação estrita do MVP (Sprints 0 a 4) vs Pós-MVP.

---

## [02-planning/](../02-planning/roadmap.md)
* [roadmap.md](../02-planning/roadmap.md) — Cronograma de 14 semanas e fases do semestre.
* [release-plan.md](../02-planning/release-plan.md) — Plano de releases v1.0 (MVP) e v2.0 (Expansão).
* [backlog.md](../02-planning/backlog.md) — Product Backlog estruturado com épicos e priorização P0 a P3.
* [user-stories.md](../02-planning/user-stories.md) — User Stories detalhadas com critérios de aceite BDD/Gherkin.
* [sprint-plan.md](../02-planning/sprint-plan.md) — Detalhamento Sprint a Sprint (Sprint 0 a 6) com metas e entregáveis.
* [dependencies.md](../02-planning/dependencies.md) — Matriz de dependências técnicas e funcionais.
* [risks.md](../02-planning/risks.md) — Risk register, severidade e planos de contingência.
* [metrics.md](../02-planning/metrics.md) — Métricas DORA, KPIs de qualidade, produto e cloud.

---

## [03-architecture/](../03-architecture/overview.md)
* [overview.md](../03-architecture/overview.md) — Visão geral da arquitetura de software e decisão pelo Monólito Modular.
* [system-context.md](../03-architecture/system-context.md) — Contexto do sistema e fronteiras externas.
* [application-architecture.md](../03-architecture/application-architecture.md) — Estrutura interna do backend modular, frontends e pacotes.
* [data-architecture.md](../03-architecture/data-architecture.md) — Persistência, schemas isolados no PostgreSQL e DDL inicial.
* [security-architecture.md](../03-architecture/security-architecture.md) — Arquitetura de segurança, fluxos OAuth2/OIDC e JWT.
* [integration-architecture.md](../03-architecture/integration-architecture.md) — Comunicação intermodular síncrona/assíncrona e APIs.
* [diagrams.md](../03-architecture/diagrams.md) — Catálogo central de todos os diagramas Mermaid do sistema.
* **ADRs (Architecture Decision Records):**
  * [ADR-001 — Padrão Arquitetural Monólito Modular](../03-architecture/adr/ADR-001-modular-monolith-architecture.md)
  * [ADR-002 — Isolamento por Schemas no PostgreSQL Único](../03-architecture/adr/ADR-002-postgresql-schema-isolation.md)
  * [ADR-003 — Autenticação Centralizada com JWT RS256 e OAuth2](../03-architecture/adr/ADR-003-sso-iam-jwt-rs256.md)
  * [ADR-004 — Plataforma de Computação AWS ECS Fargate](../03-architecture/adr/ADR-004-aws-ecs-fargate-platform.md)
  * [ADR-005 — Monorepo com Turborepo e pnpm](../03-architecture/adr/ADR-005-monorepo-tooling.md)

---

## [04-development/](../04-development/setup.md)
* [setup.md](../04-development/setup.md) — Guia de configuração do ambiente de desenvolvimento.
* [repository-structure.md](../04-development/repository-structure.md) — Estrutura de pastas do monorepo Turborepo.
* [coding-standards.md](../04-development/coding-standards.md) — Convenções de código, TypeScript, ESLint e commits.
* [git.md](../04-development/git.md) — Políticas de versionamento e regras gerais de Git.
* [branching-strategy.md](../04-development/branching-strategy.md) — Modelo de branches (GitHub Flow modificado com develop).
* [pull-requests.md](../04-development/pull-requests.md) — Diretrizes de abertura, revisão e merge de PRs.
* [api-guidelines.md](../04-development/api-guidelines.md) — Padrões para criação de rotas REST, DTOs e Swagger.
* [database-guidelines.md](../04-development/database-guidelines.md) — Padrões de migrations, integridade e boas práticas SQL.
* [testing-guidelines.md](../04-development/testing-guidelines.md) — Guia de escrita de testes unitários e de integração para devs.

---

## [05-security/](../05-security/overview.md)
* [overview.md](../05-security/overview.md) — Diretrizes e princípios de segurança da informação e LGPD.
* [authentication.md](../05-security/authentication.md) — Mecanismo de tokens JWT (RS256) e Refresh Tokens seguros.
* [authorization.md](../05-security/authorization.md) — Controle de acesso RBAC e validação de propriedade de recursos.
* [sso.md](../05-security/sso.md) — Arquitetura do SSO institucional e integração de aplicações.
* [iam-rbac.md](../05-security/iam-rbac.md) — Matriz detalhada de permissões por perfil de usuário.
* [secrets.md](../05-security/secrets.md) — Gerenciamento de credenciais via AWS Secrets Manager e Gitleaks.
* [threat-model.md](../05-security/threat-model.md) — Modelagem de ameaças e mitigações do OWASP Top 10.
* [security-checklist.md](../05-security/security-checklist.md) — Checklist de segurança para código e deploys.

---

## [06-infrastructure/](../06-infrastructure/overview.md)
* [overview.md](../06-infrastructure/overview.md) — Visão geral da infraestrutura e stack de nuvem.
* [aws.md](../06-infrastructure/aws.md) — Catálogo de serviços AWS, justificativas e configurações.
* [terraform.md](../06-infrastructure/terraform.md) — Estrutura de módulos, state remoto S3 e tags do Terraform.
* [docker.md](../06-infrastructure/docker.md) — Dockerfiles multi-stage e docker-compose local.
* [environments.md](../06-infrastructure/environments.md) — Ambientes de desenvolvimento, staging e produção.
* [networking.md](../06-infrastructure/networking.md) — Topologia de rede VPC, subnets públicas/privadas e Security Groups.
* [disaster-recovery.md](../06-infrastructure/disaster-recovery.md) — Rotinas de backup, snapshots RDS e procedimentos de restauração.

---

## [07-devops/](../07-devops/ci-cd.md)
* [ci-cd.md](../07-devops/ci-cd.md) — Estratégia global de integração e entrega contínua.
* [github-actions.md](../07-devops/github-actions.md) — Especificação detalhada dos workflows do GitHub Actions.
* [deployment.md](../07-devops/deployment.md) — Estratégia de implantação contínua e atualização de ECS Tasks.
* [rollback.md](../07-devops/rollback.md) — Procedimentos automáticos e manuais de rollback.
* [observability.md](../07-devops/observability.md) — Padrão de logs estruturados (Pino), métricas CloudWatch e alarmes.
* [finops.md](../07-devops/finops.md) — Gestão orçamentária, AWS Budgets e rotinas de auto-stop.

---

## [08-quality/](../08-quality/strategy.md)
* [strategy.md](../08-quality/strategy.md) — Estratégia de qualidade em camadas e pirâmide de testes.
* [unit-tests.md](../08-quality/unit-tests.md) — Padrões e metas para testes unitários.
* [integration-tests.md](../08-quality/integration-tests.md) — Testes de integração de API com Testcontainers e Supertest.
* [contract-tests.md](../08-quality/contract-tests.md) — Validação de contratos TypeScript/Zod entre frontend e backend.
* [e2e.md](../08-quality/e2e.md) — Automação de testes de ponta a ponta com Playwright.
* [performance.md](../08-quality/performance.md) — Testes de carga e stress com k6.
* [security-testing.md](../08-quality/security-testing.md) — Análise estática (SAST Trivy/SonarQube) e dinâmica (DAST ZAP).

---

## [09-governance/](../09-governance/team-structure.md)
* [team-structure.md](../09-governance/team-structure.md) — Composição da equipe de 25 membros e alocação por squads.
* [responsibilities.md](../09-governance/responsibilities.md) — Papéis e atribuições de liderança transversal de líderes.
* [raci.md](../09-governance/raci.md) — Matriz RACI detalhada por processo e decisão técnica.
* [scrum.md](../09-governance/scrum.md) — Framework Scrum aplicado ao projeto semestral.
* [ceremonies.md](../09-governance/ceremonies.md) — Ritos ágeis (Planning, Dailies, Review, Retrospective, Refinement).
* [definition-of-ready.md](../09-governance/definition-of-ready.md) — Critérios obrigatórios de Definition of Ready (DoR).
* [definition-of-done.md](../09-governance/definition-of-done.md) — Critérios obrigatórios de Definition of Done (DoD).

---

## [10-runbooks/](../10-runbooks/local-development.md)
* [local-development.md](../10-runbooks/local-development.md) — Passo a passo para inicializar e rodar o projeto localmente.
* [deployment.md](../10-runbooks/deployment.md) — Passo a passo operacional para execução de deploys.
* [incident-response.md](../10-runbooks/incident-response.md) — Guia de resposta a incidentes e indisponibilidades.
* [rollback.md](../10-runbooks/rollback.md) — Procedimento de reversão emergencial de versão ou migration.
* [troubleshooting.md](../10-runbooks/troubleshooting.md) — Resolução de problemas frequentes de desenvolvimento e infraestrutura.
