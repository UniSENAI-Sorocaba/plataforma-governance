---
title: "Runbook: Procedimento Operacional de Deploy"
domain: "runbooks"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# 📖 Runbook: Procedimento Operacional de Deploy

Guia de execução para implantação contínua em Staging e deploys formais de Release em Produção na AWS.

---

## 1. Deploy Contínuo em Staging (Automático)

1. Garanta que seu PR foi aprovado por 2 revisores e passou no pipeline `ci-pr.yml`.
2. Realize o **Squash and Merge** na branch `develop`.
3. O workflow `.github/workflows/cd-staging.yml` será disparado automaticamente.
4. Acompanhe a execução na aba **Actions** do GitHub.
5. Valide a versão implantada acessando o healthcheck:
   `curl https://staging-api.universidade.edu.br/api/v1/healthz`

---

## 2. Deploy Formal de Release em Produção (Gate de Aprovação)

### Pré-Deploy (T-24h):
- [ ] Aplicar *Code Freeze* na branch `develop`.
- [ ] Disparar snapshot manual do RDS PostgreSQL de produção:
  ```bash
  aws rds create-db-snapshot \
    --db-instance-identifier plataforma-db-prod \
    --db-snapshot-identifier pre-release-$(date +%Y%m%d%H%M)
  ```
- [ ] Criar a branch de release: `git checkout -b release/v1.0.0 develop`.

### Execução do Deploy (Go-Live):
1. Crie a tag Git na branch `main`:
   ```bash
   git checkout main
   git merge release/v1.0.0
   git tag -a v1.0.0 -m "Release Oficial v1.0.0 MVP"
   git push origin main --tags
   ```
2. Acesse o GitHub Actions e aprove o gate de aprovação do ambiente `production`.
3. O workflow executará o build Docker, aplicará migrations no RDS e atualizará o ECS Fargate com *Rolling Update*.

### Pós-Deploy (T+1h):
- [ ] Executar Smoke Tests nas rotas de login, submissão de PI e emissão de certificados.
- [ ] Monitorar o dashboard do CloudWatch Logs por 30 minutos em busca de erros 5xx.

---

## 3. Documentos Relacionados
* [Estratégia de Deploy](../07-devops/deployment.md)
* [Procedimento de Rollback](rollback.md)
* [Plano de Releases](../02-planning/release-plan.md)
