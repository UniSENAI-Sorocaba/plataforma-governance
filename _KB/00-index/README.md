---
title: "Knowledge Base da Plataforma Digital Integrada"
domain: "index"
status: "accepted"
owner: "Luciano Jr"
last_updated: "2026-08-27"
---

# 📚 Knowledge Base da Plataforma Digital Integrada

Bem-vindo à **Knowledge Base (KB)** oficial da **Plataforma Digital Integrada de Extensão, Acadêmico & Gestão Institucional**.

Esta base de conhecimento centraliza todas as informações técnicas, arquiteturais, funcionais, operacionais e de governança do projeto. Ela serve simultaneamente como repositório de documentação viva, guia de onboarding, referência para tomada de decisão e contexto para agentes de Inteligência Artificial.

---

## 🧭 Como a Knowledge Base Está Organizada

A KB está segmentada em 11 diretórios temáticos estruturados por domínio de conhecimento:

| Área | Diretório | Conteúdo Principal | Tipo de Documento |
| :--- | :--- | :--- | :--- |
| **Índice & Navegação** | [`00-index/`](navigation.md) | Mapa de navegação, glossário geral e registro de questões em aberto. | Estrutural |
| **Produto** | [`01-product/`](../01-product/vision.md) | Visão de produto, escopo, personas, módulos e delimitação de MVP. | Normativo |
| **Planejamento** | [`02-planning/`](../02-planning/roadmap.md) | Roadmap semestral, backlog do produto, user stories, sprints, riscos e métricas. | Normativo / Operacional |
| **Arquitetura** | [`03-architecture/`](../03-architecture/overview.md) | Arquitetura monólito modular, diagramas C4/Mermaid, fluxos de dados e ADRs. | Normativo Técnico |
| **Desenvolvimento** | [`04-development/`](../04-development/setup.md) | Setup local, monorepo Turborepo, padrões de código, Git e diretrizes de API. | Operacional Técnico |
| **Segurança** | [`05-security/`](../05-security/overview.md) | SSO central, autenticação OIDC/JWT, autorização RBAC, segredos e OWASP. | Normativo de Segurança |
| **Infraestrutura** | [`06-infrastructure/`](../06-infrastructure/overview.md) | Topologia AWS VPC, ECS Fargate, RDS PostgreSQL, Docker e Terraform. | Operacional Infra |
| **DevOps & FinOps** | [`07-devops/`](../07-devops/ci-cd.md) | Pipelines GitHub Actions, automação de deploy, observabilidade e controle de custos. | Operacional |
| **Qualidade & QA** | [`08-quality/`](../08-quality/strategy.md) | Pirâmide de testes, automação E2E (Playwright), testes de carga e quality gates. | Normativo de Qualidade |
| **Governança** | [`09-governance/`](../09-governance/team-structure.md) | Estrutura de squads, matriz RACI, ritos Scrum, DoR e DoD oficiais. | Normativo Organizacional |
| **Runbooks** | [`10-runbooks/`](../10-runbooks/local-development.md) | Procedimentos operacionais passo a passo (Setup, Deploy, Rollback, Incidentes). | Procedimental |

---

## 🎯 Documentos Normativos vs. Referenciais

* **Documentos Normativos (Obrigatórios):** Devem ser rigorosamente seguidos por todos os desenvolvedores e líderes.
  * [`Definition of Ready (DoR)`](../09-governance/definition-of-ready.md)
  * [`Definition of Done (DoD)`](../09-governance/definition-of-done.md)
  * [`Estratégia de Branching e Git`](../04-development/branching-strategy.md)
  * [`Convenções de Código e Commits`](../04-development/coding-standards.md)
  * [`ADRs (Architecture Decision Records)`](../03-architecture/adr/ADR-001-modular-monolith-architecture.md)
* **Documentos Referenciais:** Fornecem contexto, visão histórica e especificações em evolução.
  * [`Visão e Escopo do Produto`](../01-product/vision.md)
  * [`Glossário`](glossary.md)
  * [`Questões Abertas & Conflitos`](open-issues.md)

---

## 🚀 Como Encontrar Informações Rapidamente

1. **Se você acabou de entrar no time:** Comece pelo [Guia de Onboarding e Setup Local](../04-development/setup.md) e pelo [Runbook de Desenvolvimento](../10-runbooks/local-development.md).
2. **Se você é Product Owner / Scrum Master:** Consulte o [Backlog do Produto](../02-planning/backlog.md), as [User Stories](../02-planning/user-stories.md) e o [Planejamento de Sprints](../02-planning/sprint-plan.md).
3. **Se você é Desenvolvedor Backend / DB:** Consulte [Arquitetura de Dados](../03-architecture/data-architecture.md), [Diretrizes de API](../04-development/api-guidelines.md) e [SSO/IAM](../05-security/sso.md).
4. **Se você é Desenvolvedor Frontend:** Consulte [Estrutura do Monorepo](../04-development/repository-structure.md) e [Autenticação & Tokens](../05-security/authentication.md).
5. **Se você é Engenheiro Cloud / DevOps / QA:** Consulte [Pipelines CI/CD](../07-devops/ci-cd.md), [Infraestrutura AWS](../06-infrastructure/aws.md) e [Estratégia de Testes](../08-quality/strategy.md).

Para uma lista detalhada com todos os links diretos da base, acesse o [Mapa de Navegação](navigation.md).
