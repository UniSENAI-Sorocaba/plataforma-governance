---
id: PG-004-EVIDENCE
status: Ready for technical review
work_id: PG-004
owner: Luciano Menezes Júnior
reviewers: [Technical Leads]
reviewed_at: 2026-11-04
---

# PG-004 — Revisão dos ADR-006 a ADR-011

## Resultado da auditoria

Os seis ADRs já existem na KB ativa e estão marcados como `Accepted`. A implementação desta task consolida a revisão, explicita a evidência e registra os pontos que os consumidores devem respeitar.

| ADR | Decisão verificada | Owners declarados | Evidência relacionada |
| --- | --- | --- | --- |
| ADR-006 | Separação em governance, backend, frontend, database, infrastructure e quality | Technical Leads, Product Governance | `architecture/repository-map.md`, seis repositórios Git |
| ADR-007 | Java 21/Spring Boot 3, Next.js/TypeScript SSR e PostgreSQL 16 | Backend, Frontend | READMEs dos repositórios e backlogs técnicos |
| ADR-008 | Baseline fixada por tag e SHA imutável | Product Governance, Cloud & DevOps | `.governance-baseline`, workflow de compliance e `GITHUB_CONFIGURATION.md` |
| ADR-009 | OpenAPI 3.1/JSON Schema como contrato frontend/backend | Technical Leads | `contracts/`, backlogs BE-003 e QA-010 |
| ADR-010 | Frontend exige runtime SSR; S3/CloudFront não substitui o runtime | Frontend, Cloud & DevOps | `architecture/deployment.md`, FE-001 e INF-011 |
| ADR-011 | Production isolada; development/validação executam fora da AWS | Cloud & DevOps, Database | `architecture/deployment.md`, ADR-012 e INF-005 |

## Verificações realizadas

- [x] Cada ADR possui ID, status, data e owner(s).
- [x] ADR-006 substitui a decisão de monorepo do ADR-005.
- [x] ADR-007 substitui referências normativas a NestJS/Prisma.
- [x] ADR-008 define tag + SHA como baseline, evitando cópia local como autoridade.
- [x] ADR-009 exige versionamento e migração para mudanças incompatíveis.
- [x] ADR-010 está alinhado ao requisito de SSR do frontend.
- [x] ADR-011 está alinhado à decisão posterior de produção única do ADR-012.
- [ ] Aprovação formal dos líderes técnicos registrada no GitHub.

## Critério de aceite pendente

Esta evidência comprova a revisão documental e a coerência encontrada. A task só deve ser marcada como concluída após os líderes técnicos registrarem revisão/aprovação no PR.

## Rastreabilidade

- [ADR-006](../_KB/architecture/adrs/ADR-006-multi-repository.md)
- [ADR-007](../_KB/architecture/adrs/ADR-007-application-stack.md)
- [ADR-008](../_KB/architecture/adrs/ADR-008-governance-baseline.md)
- [ADR-009](../_KB/architecture/adrs/ADR-009-contract-first.md)
- [ADR-010](../_KB/architecture/adrs/ADR-010-nextjs-ssr.md)
- [ADR-011](../_KB/architecture/adrs/ADR-011-environment-isolation.md)
- [Issue PG-004](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/4)
