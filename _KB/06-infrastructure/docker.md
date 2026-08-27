---
title: "Conteinerização e Padrões Docker"
domain: "infrastructure"
status: "accepted"
owner: "Luciano Jr / Felipe Nunes / Fazano"
last_updated: "2026-08-27"
---

# 🐳 Conteinerização & Padrões Docker

Padrões de construção de imagens Docker otimizadas multi-stage e ambiente local com Docker Compose.

---

## 1. Dockerfile Multi-Stage Otimizado da API (`infra/docker/Dockerfile.api`)

```dockerfile
# Estágio 1: Build & Dependencies
FROM node:20-alpine AS builder
WORKDIR /app
RUN npm install -g pnpm turbo
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./
COPY apps/api-server/package.json ./apps/api-server/
COPY packages/ ./packages/
RUN pnpm install --frozen-lockfile

COPY apps/api-server/ ./apps/api-server/
RUN pnpm --filter api-server build
RUN pnpm --filter api-server --prod deploy /app/pruned

# Estágio 2: Runtime Minimalista
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup --system --gid 1001 nodejs && adduser --system --uid 1001 nestjs

COPY --from=builder --chown=nestjs:nodejs /app/pruned/node_modules ./node_modules
COPY --from=builder --chown=nestjs:nodejs /app/pruned/dist ./dist
COPY --from=builder --chown=nestjs:nodejs /app/apps/api-server/package.json ./package.json

USER nestjs
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/v1/healthz || exit 1

CMD ["node", "dist/main.js"]
```

---

## 2. Boas Práticas de Segurança em Contêineres
* **Usuário Não-Root (`USER nestjs`):** Processos nunca rodam como `root` dentro do contêiner.
* **Imagem Base Alpine Minimalista:** Redução da superfície de ataque e tamanho final da imagem ($< 150\text{MB}$).
* **Healthcheck Nativo:** Permite ao ECS e ao Docker detectar falhas de processo e reiniciar contêineres doentes automaticamente.

---

## 3. Documentos Relacionados
* [Guia de Setup](../04-development/setup.md)
* [Infraestrutura AWS](aws.md)
* [CI/CD Pipelines](../07-devops/ci-cd.md)
