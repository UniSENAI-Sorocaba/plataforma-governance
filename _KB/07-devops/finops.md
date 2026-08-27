---
title: "Gestão Orçamentária e FinOps na AWS"
domain: "devops"
status: "accepted"
owner: "Luciano Jr / Gabriel Camargo / Fazano"
last_updated: "2026-08-27"
---

# 💰 Gestão Orçamentária & FinOps na AWS

Estratégias de governança financeira, otimização de custos e contenção proativa para manter a infraestrutura abaixo do teto de **$120.00/mês**.

---

## 1. Composição e Previsão Detalhada de Custos Mensais

```
+---------------------------------------------------------------------------------------------------------+
|                                    ESTIMATIVA MENSAL DE INFRAESTRUTURA                                  |
+------------------------------------+-----------------------------+--------------------------------------+
| RECURSO AWS                        | DIMENSIONAMENTO             | CUSTO ESTIMADO MENSAL                |
+------------------------------------+-----------------------------+--------------------------------------+
| **ECS Fargate (Staging + Prod)**   | 2 Tasks (0.5 vCPU / 1GB RAM)| $32.00                               |
| **RDS PostgreSQL (Staging + Prod)**| `db.t4g.micro` (Graviton2)  | $35.00                               |
| **Application Load Balancer (ALB)**| 1 ALB compartilhado c/ host | $18.00                               |
| **Amazon S3 & Data Transfer**      | 50 GB Storage + Transfer    | $4.00                                |
| **AWS Secrets Manager & KMS**      | 5 Segredos / Chaves RSA     | $2.50                                |
| **Amazon CloudWatch (Logs/Metrics)**| 10 GB Ingestão / 14d retenção| $5.00                                |
| **AWS WAF**                        | 1 WebACL com regras básicas | $6.00                                |
| **TOTAL MENSAL ESTIMADO**          | -                           | **~$102.50 / mês** (Margem: $17.50)  |
+------------------------------------+-----------------------------+--------------------------------------+
```

---

## 2. Mecanismos Ativos de Contenção de Custos (FinOps)
1. **AWS Budgets Rígido:** Alarme configurado com teto de **$120.00/mês**, disparando notificações escalonadas para Luciano Jr e Fazano ao atingir 50%, 80% e 100% da previsão de gastos.
2. **Auto-Stop de Ambientes de Staging:** Uma função AWS Lambda disparada pelo Amazon EventBridge escala as tasks de Staging para 0 contêineres e pausa instâncias entre 22h e 07h e durante fins de semana, gerando uma economia de **~35% no custo de homologação**.
3. **Política de Retenção de Logs:** Retenção máxima de **14 dias** no CloudWatch Logs para evitar cobranças de gigabytes acumulados.
4. **Lifecycle de Arquivos Temporários no S3:** Exclusão automática de uploads não confirmados no banco após 7 dias.

---

## 3. Documentos Relacionados
* [Serviços AWS](../06-infrastructure/aws.md)
* [Terraform](../06-infrastructure/terraform.md)
* [Observabilidade](observability.md)
