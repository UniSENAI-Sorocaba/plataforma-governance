---
id: POL-INFRA-001
status: Approved
owner: Cloud & DevOps
approved_at: 2026-09-10
---

# CI/CD

Pipelines executam lint, build, testes, contratos, análise de dependências, secrets, análise estática (CodeQL quando disponível no plano; caso contrário, ferramenta equivalente, como Semgrep CE, e gitleaks para secrets) e spec-compliance. Deploy AWS usa OIDC e environments protegidos ou controle equivalente (repositório de release com escrita restrita) quando environments não estiverem disponíveis no plano. Produção exige artefato imutável, aprovação, smoke test e rollback ensaiado. Actions externas são fixadas por commit SHA.
