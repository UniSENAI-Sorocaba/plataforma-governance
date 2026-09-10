---
title: "Testes de Integração de APIs com Testcontainers"
domain: "quality"
status: "accepted"
owner: "Luciano Jr / Nicolle / Ryan"
last_updated: "2026-08-27"
---

# 🔄 Testes de Integração de APIs com Testcontainers

Testes de integração validam o fluxo completo das rotas HTTP, middlewares, guards de autenticação, transações SQL no PostgreSQL e regras de concorrência.

---

## 1. Princípios de Teste de Integração
* **Banco Real (Zero Mocks de SQL):** O uso de mocks para o PostgreSQL é proibido em testes de integração de rota. Utilizamos instâncias temporárias em Docker via **Testcontainers**.
* **Isolamento e Limpeza:** Cada suíte de teste roda em seu próprio schema ou executa limpeza de tabelas (`TRUNCATE CASCADE`) no `afterEach`, garantindo idempotência e independência de ordem.
* **Validação de Códigos HTTP:** Os testes cobrem cenários felizes (`200 OK`, `201 Created`) e cenários de erro (`400 Bad Request`, `401 Unauthorized`, `403 Forbidden`, `404 Not Found`).

---

## 2. Cenários Críticos Obrigatórios em Integração
1. **Fluxo de Login e Refresh:** `POST /api/v1/auth/login` seguido de `POST /api/v1/auth/refresh` com cookie.
2. **Submissão e Avaliação de PI:** Criação de projeto, alocação de banca, submissão de 3 avaliações e verificação da média final persistida.
3. **Validação de Atividade de Extensão:** Submissão de relatório por aluno e aprovação atômica pelo orientador com incremento de horas.

---

## 3. Documentos Relacionados
* [Estratégia Global](strategy.md)
* [Testes de Contrato](contract-tests.md)
* [Diretrizes de Teste para Devs](../04-development/testing-guidelines.md)
