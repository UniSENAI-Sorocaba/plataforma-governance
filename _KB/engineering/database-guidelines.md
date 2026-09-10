---
status: Approved
owner: Database
approved_at: 2026-09-10
---

# Diretrizes de banco

PostgreSQL 16 usa schemas por domínio, constraints para integridade e migrations versionadas no repositório database. Mudança destrutiva usa Expand and Contract. Migrations são testadas do zero e por upgrade; produção exige backup/rollback compatível. Dados pessoais seguem minimização e retenção.
