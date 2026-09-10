---
title: "Workflows do GitHub Actions"
domain: "devops"
status: "accepted"
owner: "Luciano Jr / Fazano / Vinicius Pereira"
last_updated: "2026-08-27"
---

# 🤖 Workflows do GitHub Actions

Especificação dos três workflows principais de automação do repositório: validação de PRs, deploy em Staging e release em Produção.

---

## 1. Workflow de Validação de Pull Requests (`.github/workflows/ci-pr.yml`)

```yaml
name: CI Pull Request Quality Gate

on:
  pull_request:
    branches: [ develop, main ]

jobs:
  validate:
    name: Lint, Typecheck, Test & Security
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Código
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Node.js & pnpm
        uses: pnpm/action-setup@v3
        with:
          version: 9
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'

      - name: Instalar Dependências
        run: pnpm install --frozen-lockfile

      - name: Executar Lint & Formatação
        run: pnpm turbo run lint

      - name: Executar Typecheck TypeScript
        run: pnpm turbo run typecheck

      - name: Executar Testes Unitários com Cobertura
        run: pnpm turbo run test:coverage

      - name: Validar Cobertura Mínima (75%)
        run: |
          pnpm exec jest --coverage --coverageThreshold='{"global":{"lines":75}}'

      - name: Escaneamento de Segurança SAST (Trivy)
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          ignore-unfixed: true
          severity: 'CRITICAL,HIGH'
```

---

## 2. Workflow de Deploy Contínuo em Staging (`.github/workflows/cd-staging.yml`)
* **Disparo:** Push/Merge direto na branch `develop`.
* **Ações:**
  1. Build da imagem Docker da API (`apps/api-server`) e dos Frontends.
  2. Push das imagens para o Amazon ECR de Staging (`plataforma-api-staging`).
  3. Execução das migrations do PostgreSQL via task ECS efêmera.
  4. Atualização do serviço ECS Fargate de Staging.
  5. Verificação de healthcheck no endpoint `https://staging-api.universidade.edu.br/api/v1/healthz`.

---

## 3. Workflow de Release em Produção (`.github/workflows/cd-production.yml`)
* **Disparo:** Criação de Git Tag anotada (`v*.*.*`) na branch `main`.
* **Gate de Governança:** Requer aprovação manual de Luciano Jr ou Fellipe Raszejas no painel do GitHub Environments (`production`).

---

## 4. Documentos Relacionados
* [CI/CD](ci-cd.md)
* [Estratégia de Deploy](deployment.md)
* [Quality Gates](../08-quality/strategy.md)
