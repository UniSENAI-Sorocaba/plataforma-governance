---
title: "Testes de Contrato e Tipagem Estrita"
domain: "quality"
status: "accepted"
owner: "Luciano Jr / Marco / Nicolas Leão"
last_updated: "2026-08-27"
---

# 📜 Testes de Contrato & Tipagem Estrita

Como o projeto é estruturado em um monorepo TypeScript, os testes de contrato garantem a sincronia perfeita entre os payloads enviados pelo backend e as interfaces consumidas pelo frontend.

---

## 1. Compartilhamento de Contratos via `packages/shared-types`
* Todos os DTOs de requisição e resposta são declarados como tipos TypeScript e schemas Zod dentro do pacote compartilhado `packages/shared-types`.
* **Validação em Tempo de Compilação:** O pipeline de CI executa `pnpm turbo run typecheck`. Se o backend alterar um campo sem atualizar a interface do frontend, o build é imediatamente bloqueado com erro de tipo.

---

## 2. Geração Automatizada de SDK Cliente
* A documentação OpenAPI gerada pelo NestJS (`/api/docs-json`) é utilizada pelo gerador **Orval** para produzir hooks React (`useQuery` / `useMutation`) 100% tipados no frontend.

---

## 3. Documentos Relacionados
* [Estrutura do Monorepo](../04-development/repository-structure.md)
* [Diretrizes de API](../04-development/api-guidelines.md)
* [Testes de Integração](integration-tests.md)
