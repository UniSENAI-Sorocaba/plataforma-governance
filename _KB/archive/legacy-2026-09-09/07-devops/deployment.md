---
title: "Estratégia de Implantação e Deploy de Aplicações"
domain: "devops"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# 🚀 Estratégia de Implantação & Deploy

Procedimentos e mecanismos técnicos adotados para garantir deploys com zero tempo de inatividade (*Zero Downtime Deployment*) na nuvem AWS.

---

## 1. Estratégia Rolling Update no AWS ECS Fargate

Para evitar indisponibilidade durante atualizações da API:
* **Parâmetros do ECS Service:**
  * `minimum_healthy_percent = 100` (Garante que a versão antiga permaneça com 100% de capacidade enquanto a nova inicializa).
  * `maximum_percent = 200` (Permite dobrar temporariamente a quantidade de tasks durante a transição).
* **Mecanismo de Draining do ALB:** O Application Load Balancer realiza *deregistration delay* de 30 segundos nas tasks antigas, permitindo que requisições em andamento terminem de ser processadas antes do desligamento do contêiner anterior.

---

## 2. Deploy dos Frontends (Next.js) no Amazon S3 + CloudFront
1. Build estático / SSR gerado no GitHub Actions.
2. Sincronização dos assets estáticos para o bucket S3 de assets públicos (`aws s3 sync`).
3. Invalidação automática de cache na distribuição CloudFront (`aws cloudfront create-invalidation --paths "/*"`), garantindo que os usuários recebam a versão atualizada instantaneamente.

---

## 3. Documentos Relacionados
* [Rollback](rollback.md)
* [Workflows do GitHub Actions](github-actions.md)
* [Runbook de Deploy](../10-runbooks/deployment.md)
