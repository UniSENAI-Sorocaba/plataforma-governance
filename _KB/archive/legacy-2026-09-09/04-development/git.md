---
title: "Políticas Gerais de Versionamento Git"
domain: "development"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# 🌿 Políticas Gerais de Versionamento Git

Regras de ouro para operação e manutenção da integridade do repositório Git.

---

## 1. Regras Fundamentais de Git
1. **Push Direto Proibido:** Ninguém (incluindo Tech Leads e POs) realiza `git push` direto nas branches `main` ou `develop`.
2. **Force-Push Desabilitado:** O comando `git push --force` está permanentemente bloqueado nas branches protegidas.
3. **Commits Pequenos e Atômicos:** Evite commits gigantes com centenas de arquivos alterados. Cada commit deve representar uma unidade lógica de trabalho.
4. **Segredos Nunca no Git:** É expressamente proibido commitar chaves de API, senhas ou tokens. O pre-commit hook com **Gitleaks** bloqueia commits que contenham padrões de segredos.
5. **Histórico Linear:** Ao fazer merge de Pull Requests no `develop` ou `main`, utilize exclusivamente a opção **Squash and Merge**.

---

## 2. Configuração de Pre-Commit Hooks (Husky)
O monorepo utiliza **Husky + Lint-Staged** para executar automaticamente antes de cada commit:
* `pnpm lint-staged` (ESLint e Prettier nos arquivos modificados)
* `gitleaks protect --staged` (Varredura de credenciais)
* `commitlint` (Validação de conformidade com Conventional Commits)

---

## 3. Documentos Relacionados
* [Estratégia de Branching](branching-strategy.md)
* [Diretrizes de Pull Request](pull-requests.md)
* [Padrões de Código](coding-standards.md)
