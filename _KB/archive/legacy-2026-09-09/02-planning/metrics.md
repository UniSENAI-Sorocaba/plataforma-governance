---
title: "Métricas e Indicadores de Sucesso (KPIs & DORA)"
domain: "planning"
status: "accepted"
owner: "Luciano Jr / Fellipe Raszejas"
last_updated: "2026-08-27"
---

# 📊 Métricas e Indicadores de Sucesso

Painel consolidado de métricas de engenharia, qualidade, produto e infraestrutura monitoradas quinzenalmente durante as Retrospectivas.

---

## 1. Quadro Geral de Indicadores

```
+---------------------------------------------------------------------------------------------------------+
|                                    PAINEL CONSOLIDADO DE KPIS                                           |
+--------------------+------------------------------------+------------------+----------------------------+
| CATEGORIA          | INDICADOR / MÉTRICA                | META DO SEMESTRE | FONTE DE COLETA            |
+--------------------+------------------------------------+------------------+----------------------------+
| **Métricas DORA**  | Deployment Frequency (Staging)     | >= 3 deploys/dia | GitHub Actions Insights    |
|                    | Lead Time for Changes              | < 24 horas       | GitHub PRs Analytics       |
|                    | Change Failure Rate (CFR)          | < 5% de deploys  | CloudWatch Deploy Errors   |
|                    | Mean Time to Restore (MTTR)        | < 30 minutos     | Incident Logs              |
+--------------------+------------------------------------+------------------+----------------------------+
| **Qualidade & QA** | Cobertura de Testes Automatizados  | >= 75% global    | Jest Coverage / SonarQube  |
|                    | Bugs Críticos em Produção          | 0 bugs abertos   | GitHub Issues              |
|                    | Performance Google Lighthouse      | >= 90 em todos   | Lighthouse CI Report       |
+--------------------+------------------------------------+------------------+----------------------------+
| **Produto & Ágil** | Cumprimento do Sprint Goal         | >= 85% de taxa   | Jira / GitHub Projects     |
|                    | User Stories Concluídas (DoD)      | >= 90% do plano  | Sprint Velocity Report     |
+--------------------+------------------------------------+------------------+----------------------------+
| **Cloud & FinOps** | Custo Total Mensal AWS             | < $120.00 / mês  | AWS Cost Explorer / Budgets|
|                    | Uptime da API (Disponibilidade)    | >= 99.5%         | CloudWatch Synthetics      |
|                    | Latência Média p95 da API          | < 500ms          | ALB Access Logs            |
+--------------------+------------------------------------+------------------+----------------------------+
```

---

## 2. Documentos Relacionados
* [Plano de Sprints](sprint-plan.md)
* [Estratégia de QA](../08-quality/strategy.md)
* [Observabilidade](../07-devops/observability.md)
