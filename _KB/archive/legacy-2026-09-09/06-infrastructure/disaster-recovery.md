---
title: "Plano de Continuidade e Disaster Recovery"
domain: "infrastructure"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# 🚨 Plano de Continuidade & Disaster Recovery (DR)

Políticas de backup, redundância, metas de recuperação (RPO/RTO) e procedimentos de restauração em caso de falha catastrófica.

---

## 1. Metas Operacionais de Recuperação (SLAs de DR)
* **RPO (Recovery Point Objective):** $\le 5\text{ minutos}$ (Máxima perda tolerável de dados transacionais via WAL archiving e PITR no RDS).
* **RTO (Recovery Time Objective):** $\le 30\text{ minutos}$ (Tempo máximo para restabelecer a operação completa da API).

---

## 2. Política de Backups de Dados e Infraestrutura
* **Banco de Dados (RDS PostgreSQL):**
  * Snapshots automatizados diários retidos por 7 dias.
  * Habilitação contínua de Point-in-Time Recovery (PITR) para restauração em qualquer minuto dos últimos 7 dias.
  * Snapshot manual disparado antes de qualquer release produtiva.
* **Storage de Arquivos (Amazon S3):**
  * S3 Bucket Versioning ativado no bucket de produção para proteção contra deleções acidentais.
* **Infraestrutura como Código (Terraform):**
  * Todo o ambiente pode ser recriado do zero em outra região AWS através do comando `terraform apply` em $< 15$ minutos.

---

## 3. Documentos Relacionados
* [Runbook de Resposta a Incidentes](../10-runbooks/incident-response.md)
* [Runbook de Rollback](../10-runbooks/rollback.md)
* [Arquitetura de Dados](../03-architecture/data-architecture.md)
