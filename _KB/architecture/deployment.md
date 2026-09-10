---
status: Approved
owner: Cloud & DevOps
approved_at: 2026-09-10
---

# Arquitetura de deployment

Artefatos imutáveis percorrem CI → staging → aprovação → production. Production é isolado. API executa em containers; Next.js possui runtime SSR; S3/CloudFront atende objetos/assets e cache. Passos executáveis ficam nos runbooks.
