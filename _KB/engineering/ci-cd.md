---
id: POL-INFRA-001
status: Approved
owner: Cloud & DevOps
approved_at: 2026-09-10
---

# CI/CD

Pipelines executam lint, build, testes, contratos, análise de dependências, secrets, CodeQL e spec-compliance. Deploy AWS usa OIDC e environments protegidos. Produção exige artefato imutável, aprovação, smoke test e rollback ensaiado. Actions externas são fixadas por commit SHA.
