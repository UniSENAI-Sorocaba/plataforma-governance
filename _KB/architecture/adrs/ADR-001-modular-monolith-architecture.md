---
id: ADR-001
status: Superseded
owner: Technical Leads
superseded_by: ADR-007
normalized_at: 2026-09-10
---

# ADR-001 — Adoção do Padrão Arquitetural Monólito Modular (Modular Monolith)

## Status
Superseded

## Context
O projeto precisa entregar uma plataforma acadêmica e institucional completa em 14 semanas com uma equipe de 25 desenvolvedores. Uma arquitetura de microsserviços distribuídos puros traria complexidade excessiva de orquestração de rede, consistência eventual, overhead de deploys múltiplos e custos elevados de nuvem para o contexto acadêmico.

## Decision
Adotar o padrão **Modular Monolith (Monólito Modular)** orientado a Domain-Driven Design (DDD). Toda a lógica de negócio do backend roda em um processo único de runtime Node.js/TypeScript (NestJS), estruturado em módulos fortemente delimitados (`auth`, `academic-pi`, `extension`, `assets`, `institutional`) com contratos e interfaces TypeScript estritas.

## Alternatives Considered
1. **Microsserviços Distribuídos Puros:** Rejeitado devido ao risco alto de não entrega em 1 semestre, complexidade de rede, transações distribuídas (Saga) e custo financeiro na AWS.
2. **Monólito Tradicional Não Modular (Layered Architecture):** Rejeitado devido ao alto risco de acoplamento descontrolado (*código espaguete*) entre tabelas e regras de negócio com 25 pessoas commitando.

## Consequences
* **Positivas:**
  * Transações ACID nativas no PostgreSQL quando estritamente necessárias.
  * Comunicação em memória com latência zero entre módulos.
  * Pipeline de build e deploy simples (apenas 1 contêiner de backend).
  * Baixo custo de infraestrutura na AWS (execução em ECS Fargate).
  * Facilidade de extração futura de módulos para microsserviços caso necessário.
* **Negativas:**
  * Exige disciplina rigorosa do time e linter para impedir importações diretas não autorizadas entre módulos.

## Related Documents
- [Visão Geral da Arquitetura](../containers.md)
- [Arquitetura de Aplicação](../components.md)
