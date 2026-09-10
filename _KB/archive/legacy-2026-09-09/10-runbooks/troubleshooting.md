---
title: "Runbook: Guia de Resolução de Problemas Frequentes"
domain: "runbooks"
status: "accepted"
owner: "Luciano Jr / Marco / Nicolas Leão"
last_updated: "2026-08-27"
---

# 📖 Runbook: Resolução de Problemas Frequentes (Troubleshooting)

Soluções rápidas para problemas comuns enfrentados por desenvolvedores durante o desenvolvimento local e integração.

---

## 1. Problema: Erro de Porta em Uso (`EADDRINUSE: 3000` ou `5432`)
* **Causa:** Outro processo local ou container antigo está ocupando a porta da API ou do banco.
* **Solução:**
  ```bash
  # No Linux/macOS:
  lsof -ti :3000 | xargs kill -9
  # No Windows (PowerShell):
  Get-Process -Id (Get-NetTCPConnection -LocalPort 3000).OwningProcess | Stop-Process -Force
  ```

---

## 2. Problema: Falha de Conexão com o Banco (`ECONNREFUSED 127.0.0.1:5432`)
* **Causa:** O contêiner Docker do PostgreSQL não foi inicializado ou crashou.
* **Solução:**
  ```bash
  docker compose -f infra/docker/docker-compose.yml restart postgres
  docker logs plataforma-postgres-1
  ```

---

## 3. Problema: Conflito de Tipos no Monorepo (`Cannot find module '@plataforma/shared-types'`)
* **Causa:** O pacote compartilhado não foi compilado ou os links simbólicos do `pnpm` foram desincronizados.
* **Solução:**
  ```bash
  pnpm install --force
  pnpm turbo run build --filter=@plataforma/shared-types
  ```

---

## 4. Problema: Token JWT Inválido no Frontend (`401 Unauthorized`)
* **Causa:** O token expirou (15 minutos) e o cookie de Refresh Token não foi enviado devido a configuração de CORS/SameSite local.
* **Solução:** Certifique-se de que a requisição no frontend inclui `credentials: 'include'` no `fetch` / `axios` e limpe os cookies do navegador em `Application > Storage > Clear site data`.

---

## 5. Documentos Relacionados
* [Setup Local](../04-development/setup.md)
* [Runbook de Desenvolvimento](local-development.md)
* [Autenticação](../05-security/authentication.md)
