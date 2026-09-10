---
title: "Runbook: Execução de Rollback Emergencial"
domain: "runbooks"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# 📖 Runbook: Execução de Rollback Emergencial

Procedimento operacional para reverter imediatamente versões da API, frontends ou banco de dados em caso de falhas pós-deploy.

---

## 1. Rollback de Versão da API no AWS ECS Fargate

Caso a nova versão da API apresente comportamento instável em Produção:

```bash
# 1. Listar as últimas revisões da Task Definition
aws ecs list-task-definitions --family-prefix plataforma-api-prod --sort DESC

# 2. Forçar a atualização do serviço para a revisão estável anterior (ex: revisão 12)
aws ecs update-service \
  --cluster plataforma-cluster-prod \
  --service plataforma-api-prod \
  --task-definition plataforma-api-prod:12 \
  --force-new-deployment

# 3. Acompanhar a estabilização das tasks saudáveis
aws ecs wait services-stable \
  --cluster plataforma-cluster-prod \
  --services plataforma-api-prod
```

---

## 2. Reversão de Migrations no PostgreSQL RDS

Caso uma migration com erro tenha sido executada:

```bash
# 1. Executar o script de down da migration no ambiente
pnpm --filter api-server db:migrate:down

# 2. Se houver corrupção grave de dados, restaurar o banco via Point-in-Time Recovery (PITR)
aws rds restore-db-instance-to-point-in-time \
  --source-db-instance-identifier plataforma-db-prod \
  --target-db-instance-identifier plataforma-db-prod-restored \
  --restore-time "2026-08-27T14:55:00Z"
```

---

## 3. Documentos Relacionados
* [Estratégia de Rollback](../07-devops/rollback.md)
* [Resposta a Incidentes](incident-response.md)
* [Disaster Recovery](../06-infrastructure/disaster-recovery.md)
