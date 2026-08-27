---
title: "Diretrizes de Pull Requests e Code Review"
domain: "development"
status: "accepted"
owner: "Luciano Jr / Nicolle / Marco"
last_updated: "2026-08-27"
---

# 🔍 Diretrizes de Pull Requests & Code Review

Todo código que entra nas branches `develop` ou `main` deve passar por um processo formal de revisão e validação automatizada.

---

## 1. Requisitos para Abertura de Pull Request (PR)

Antes de solicitar revisão, o autor do PR deve verificar:
* [ ] O título do PR segue o formato `[US<numero>] Tipo: Descrição clara` (ex: `[US01] feat: implementação do login com JWT RS256`).
* [ ] O template de Pull Request (`.github/pull_request_template.md`) foi preenchido integralmente.
* [ ] Testes unitários e de integração foram incluídos e cobrem os novos caminhos de código.
* [ ] Não há arquivos desnecessários ou variáveis de ambiente commitadas.
* [ ] A branch foi rebaseada ou sincronizada com a última versão de `develop`.

---

## 2. Regras de Aprovação e Quality Gates

Para que o botão de merge seja habilitado no GitHub:
1. **Pipeline de CI com Sucesso:** Todos os jobs (Lint, Typecheck, Testes Unitários, Testcontainers e SAST Trivy) devem estar verdes.
2. **Aprovações Humanas Obrigatórias:** No mínimo **2 aprovações formais** (sendo pelo menos 1 do Tech Lead da respectiva área técnica ou de Luciano Jr).
3. **Sem Threads Pendentes:** Todas as discussões e comentários do code review devem estar marcados como resolvidos (*Resolved*).

---

## 3. Checklist do Revisor (Code Reviewer)

* O código é legível, segue os padrões do projeto e não possui complexidade ciclomática excessiva?
* As regras de autorização (RBAC/Guards) foram aplicadas corretamente nos novos endpoints?
* Há tratamento de erros apropriado e logs estruturados em formato JSON?
* As consultas ao banco utilizam índices adequados e evitam o problema de $N+1$ queries?

---

## 4. Documentos Relacionados
* [Definition of Done](../09-governance/definition-of-done.md)
* [Padrões de Código](coding-standards.md)
* [Estratégia de Branching](branching-strategy.md)
