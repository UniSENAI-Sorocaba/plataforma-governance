---
status: Approved
owner: Database
approved_at: 2026-09-10
---

# Fluxo de dados

Cliente → frontend SSR → API → PostgreSQL/S3. Identidade usa OIDC/JWKS; uploads usam URL pré-assinada. Operações críticas geram auditoria. Schema executável e migrations residem no repositório database; esta página não é DDL.
