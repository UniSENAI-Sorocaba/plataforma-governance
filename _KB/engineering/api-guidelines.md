---
status: Approved
owner: Backend
approved_at: 2026-09-10
---

# Diretrizes de API

APIs seguem OpenAPI 3.1 contract-first, HTTPS, JSON, URI por recurso, paginação consistente, idempotência quando aplicável e erros RFC 9457. Controllers Spring Boot não expõem entidades de persistência. Mudanças incompatíveis exigem nova versão e migração; autorização é server-side.
