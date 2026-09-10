---
id: ADR-006
status: Accepted
date: 2026-09-10
owners: [Technical Leads, Product Governance]
supersedes: ADR-005
---

# Arquitetura multi-repositório

## Decisão

Separar governança, backend, frontend, database, infrastructure e quality. Contratos globais e baselines normativas residem no governance repository; cada consumidor fixa tag e SHA.

## Consequências

Ownership e pipelines independentes ficam claros, mas contratos, releases coordenadas e rastreabilidade passam a ser obrigatórios. ADR-005 fica superseded.
