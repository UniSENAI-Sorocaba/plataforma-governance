---
title: "Runbook: Desenvolvimento e Execução Local"
domain: "runbooks"
status: "accepted"
owner: "Luciano Jr / Marco"
last_updated: "2026-08-27"
---

# 📖 Runbook: Desenvolvimento & Execução Local

Procedimento operacional passo a passo para inicializar, testar e debugar o ambiente de desenvolvimento local.

---

## 1. Inicialização do Ambiente Local

### Passo 1: Limpar e Instalar Dependências
```bash
pnpm install
```

### Passo 2: Inicializar o Banco de Dados PostgreSQL no Docker
```bash
docker compose -f infra/docker/docker-compose.yml up -d
```
*Verifique se o container está rodando:*
```bash
docker ps
```

### Passo 3: Executar Migrations e Popular Dados Iniciais (Seed)
```bash
pnpm --filter api-server db:migrate
pnpm --filter api-server db:seed
```

### Passo 4: Executar as Aplicações em Modo Watch
```bash
pnpm turbo run dev
```

---

## 2. Comandos Operacionais Frequentes

* **Rodar apenas a API:** `pnpm --filter api-server dev`
* **Rodar apenas o Painel Admin:** `pnpm --filter web-admin dev`
* **Rodar apenas o Portal Público:** `pnpm --filter web-portal dev`
* **Executar linter em todo o monorepo:** `pnpm turbo run lint`
* **Executar testes unitários:** `pnpm turbo run test`
* **Resetar banco de dados local:** `pnpm --filter api-server db:reset`

---

## 3. Documentos Relacionados
* [Guia de Setup](../04-development/setup.md)
* [Estrutura do Monorepo](../04-development/repository-structure.md)
* [Troubleshooting](troubleshooting.md)
