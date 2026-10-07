# Plataforma Digital

Plataforma integrada para Projetos Integradores, Extensão Universitária, identidade institucional e portal público. Patrimônio, Carreira, Iniciação Científica e CPA/Ouvidoria permanecem no horizonte 2027.1.

## Organização

- Lead Product Owner / PO Coach: Luciano Menezes Júnior.
- Product Owner: Fellipe Raszejas.
- Squads funcionais: Backend, Frontend, Banco de Dados, Cloud & DevOps e Qualidade/Testes/Segurança.
- Composição oficial: [`new_teams.md`](new_teams.md).

## Arquitetura vigente

- arquitetura multi-repositório;
- backend Java 21 + Spring Boot 3;
- frontend Next.js/TypeScript com runtime SSR;
- PostgreSQL 16;
- AWS e Terraform;
- OpenAPI 3.1 contract-first;
- GitHub Flow e baseline de governança fixada por tag + SHA.

As decisões completas estão nos ADRs da [`_KB`](_KB/README.md).

## Documentação e execução

- Fonte normativa: [`_KB/README.md`](_KB/README.md)
- Configuração GitHub: [`GITHUB_CONFIGURATION.md`](GITHUB_CONFIGURATION.md)
- Backlogs por equipe: [`BACKLOG_BY_TEAM.md`](BACKLOG_BY_TEAM.md)
- Relatório de migração: [`_KB_MIGRATION_REPORT.md`](_KB_MIGRATION_REPORT.md)
- Baseline histórica: [`_KB/archive/legacy-2026-09-09/`](_KB/archive/legacy-2026-09-09/)
- Automação administrativa do GitHub: [`github_admin/README.md`](github_admin/README.md)
- Material de apoio de Cloud & DevOps (não normativo): [`_KB/operations/guides/cloud-devops/README.md`](_KB/operations/guides/cloud-devops/README.md)

Depois da importação, Issues representam unidades de trabalho e o GitHub Project representa prioridade e estado. Markdown não duplica o estado operacional.
