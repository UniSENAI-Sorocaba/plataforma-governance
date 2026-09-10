---
id: ADR-009
status: Accepted
date: 2026-09-10
owners: [Technical Leads]
---

# Contratos contract-first

OpenAPI 3.1 e JSON Schema são a autoridade frontend/backend; AsyncAPI e JSON Schema para eventos. SDKs e documentação podem ser gerados, mas não redefinem o contrato. Mudanças incompatíveis exigem versionamento e plano de migração.
