---
status: Approved
owner: Cloud & DevOps
approved_at: 2026-09-10
---

# Arquitetura de deployment

Apenas production existe na AWS (ADR-012). Artefatos imutáveis percorrem CI → validação efêmera → publicação no ECR → aprovação (go/no-go) → production. A validação efêmera é criada dentro do job de CI, com a mesma imagem que será publicada, e destruída ao final. Production é isolado. API executa em containers; Next.js possui runtime SSR; S3/CloudFront atende objetos/assets e cache. Passos executáveis ficam nos runbooks.
