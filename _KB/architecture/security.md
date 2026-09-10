---
status: Approved
owner: Quality, Tests & Security
approved_at: 2026-09-10
---

# Arquitetura de segurança

Trust boundaries existem entre internet, runtime, AWS services e administração. Autenticação usa OIDC/JWT RS256 e sessão revogável; autorização é server-side; secrets ficam no Secrets Manager; logs e auditoria seguem minimização.
