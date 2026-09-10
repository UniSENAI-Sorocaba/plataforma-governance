---
title: "Procedimentos de Rollback Automático e Manual"
domain: "devops"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# ⏪ Procedimentos de Rollback Automático & Manual

Mecanismos de reversão imediata de versão em caso de falha de deploy, erros 5xx elevados ou quebra de funcionalidade crítica.

---

## 1. Rollback Automático de Task ECS Fargate

O ECS e o CloudWatch estão configurados para disparar reversão automática se o healthcheck falhar nos primeiros 3 minutos pós-deploy:

```mermaid
stateDiagram-v2
    [*] --> DeployNovaVersao
    DeployNovaVersao --> VerificacaoHealthcheck: ALB dispara /healthz
    
    state VerificacaoHealthcheck {
        [*] --> Analisando
        Analisando --> Sucesso: HTTP 200 em 3 checks consecutivos
        Analisando --> Falha: HTTP 5xx ou Timeout (> 5s)
    }
    
    Sucesso --> ConcluirDeploy: Desvia 100% do tráfego e desliga tasks antigas
    ConcluirDeploy --> [*]
    
    Falha --> RollbackAutomatico: Dispara Alarme CloudWatch
    RollbackAutomatico --> RestauraTaskAnterior: Mantém tasks antigas saudáveis
    RestauraTaskAnterior --> NotificaEquipe: Envia alerta no Discord/Slack
    RestauraTaskAnterior --> [*]
```

---

## 2. Rollback Manual de Versão da API (Via AWS CLI)
Se uma falha funcional for descoberta após a conclusão do deploy:
```bash
# Reverter para a Task Definition anterior estável (ex: revisão 14)
aws ecs update-service \
  --cluster plataforma-cluster-prod \
  --service plataforma-api-prod \
  --task-definition plataforma-api-prod:14 \
  --force-new-deployment
```

---

## 3. Rollback de Migrations do PostgreSQL
* Caso uma migration precise ser revertida:
```bash
# Executa a migration de down versionada
pnpm --filter api-server db:migrate:down
```
* **Atenção:** Em casos de perda ou corrupção de dados, utilize o Point-in-Time Recovery (PITR) do RDS restaurando o banco para o minuto anterior ao deploy.

---

## 4. Documentos Relacionados
* [Runbook de Rollback](../10-runbooks/rollback.md)
* [Disaster Recovery](../06-infrastructure/disaster-recovery.md)
* [Observabilidade](observability.md)
