---
title: "Padrões e Diretrizes para Testes Unitários"
domain: "quality"
status: "accepted"
owner: "Luciano Jr / Nicolle"
last_updated: "2026-08-27"
---

# 🔬 Padrões & Diretrizes para Testes Unitários

Testes unitários são a base da pirâmide de qualidade, responsáveis por garantir o comportamento isolado de funções puras, serviços de domínio e validadores.

---

## 1. Escopo Obrigatório de Testes Unitários
* **Cálculos Matemáticos e Regras de Negócio:** Cálculo de médias ponderadas de Projetos Integradores (`EvaluationService`), cômputo de horas curriculares de extensão (`HoursCalculatorService`).
* **Validação de DTOs e Regras de Entrada:** Schemas Zod e decorators de validação.
* **Mapeamento de Entidades:** Conversão de modelos de banco para DTOs públicos de resposta.
* **Componentes Puros de UI:** Renderização de botões, inputs, tabelas e modais no Design System (`packages/ui`).

---

## 2. Meta de Cobertura e Quality Gate
* **Meta Global:** $\ge 75\%$ de cobertura de linhas no backend.
* **Meta em Serviços Core (`src/modules/*/services`):** $\ge 85\%$ de cobertura de linhas e branches.
* **Comando de Verificação:** `pnpm turbo run test:coverage`

---

## 3. Documentos Relacionados
* [Estratégia Global](strategy.md)
* [Testes de Integração](integration-tests.md)
* [Diretrizes de Teste](../04-development/testing-guidelines.md)
