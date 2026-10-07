---
id: POL-INFRA-002
status: Approved
owner: Cloud & DevOps
approved_at: 2026-09-10
---

# Observabilidade

Logs estruturados não contêm secrets/PII desnecessária. Métricas, tracing, dashboards e alarmes usam correlação por request. Retenção: production 30 dias, security 90 e audit trail 180 dias, sujeita a minimização e finalidade. Development e a validação efêmera executam fora da AWS (ADR-012) e não mantêm logs na nuvem.
