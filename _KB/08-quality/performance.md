---
title: "Testes de Performance e Carga com k6"
domain: "quality"
status: "accepted"
owner: "Luciano Jr / Nicolle / Fazano"
last_updated: "2026-08-27"
---

# 🚀 Testes de Performance & Carga com k6

Metodologia e critérios de aceitação para testes de carga, stress e validação de latência pré-release na AWS.

---

## 1. Critérios de Aceitação de Performance (SLOs)
* **Carga Alvo:** **200 requisições simultâneas por segundo (RPS)** mantidas por 10 minutos.
* **Latência:** Percentil 95 (p95) $< 500\text{ms}$ e Percentil 99 (p99) $< 1500\text{ms}$.
* **Taxa de Erro HTTP 5xx:** $< 0.1\%$ durante o pico de carga.

---

## 2. Cenário de Teste de Carga k6 (`infra/tests/load-test.js`)
O script k6 simula o comportamento proporcional do dia de entrega de projetos:
* 50% de tráfego de leitura no Portal Público (vitrine e busca de projetos).
* 30% de tráfego de login e consulta de notas no Painel Admin.
* 20% de tráfego de escrita concorrente (submissão de avaliações e relatórios).

---

## 3. Documentos Relacionados
* [Estratégia Global](strategy.md)
* [Observabilidade](../07-devops/observability.md)
* [Checklist de Go-Live](../02-planning/release-plan.md)
