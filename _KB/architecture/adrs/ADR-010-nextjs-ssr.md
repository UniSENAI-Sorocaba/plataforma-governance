---
id: ADR-010
status: Accepted
date: 2026-09-10
owners: [Frontend, Cloud & DevOps]
---

# Runtime Next.js SSR

O portal exige runtime compatível com SSR. S3/CloudFront pode servir assets e cache, mas não substitui o runtime das rotas SSR. O serviço AWS específico será detalhado na implementação.
