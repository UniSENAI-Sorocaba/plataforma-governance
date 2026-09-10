# ADR-005 — Ferramentas de Monorepo com Turborepo e pnpm Workspaces

## Status
Accepted

## Context
O projeto possui múltiplos frontends (Portal Público e Painel Admin), uma API de backend, componentes compartilhados de UI (Design System), tipos TypeScript e código de infraestrutura. Gerenciar múltiplos repositórios separados (multirepo) para 25 pessoas causaria atrito extremo em sincronização de contratos e versionamento.

## Decision
Adotar uma estrutura de **Monorepo** gerenciada através de **pnpm workspaces** e orquestrada pelo **Turborepo**.

## Alternatives Considered
1. **Multirepo (Repositórios Separados no GitHub):** Rejeitado pela sobrecarga de sincronização de PRs, quebra de contratos de DTOs e dificuldade de rastreamento de issues.
2. **Monorepo com npm/yarn e Lerna:** Rejeitado pelo consumo excessivo de espaço em disco no `node_modules` e menor velocidade de pipeline.

## Consequences
* **Positivas:**
  * Compartilhamento imediato de interfaces TypeScript e DTOs entre front e back via `packages/shared-types`.
  * Instalação ultrarrápida de dependências com economia de disco via hard links do `pnpm`.
  * Cache inteligente de builds e testes no Turborepo, acelerando as esteiras de CI/CD.
  * Atomicidade de mudanças que afetam simultaneamente API e Frontend.
* **Negativas:**
  * Exige cuidado na configuração de imports no `tsconfig.json` e no pipeline do GitHub Actions.

## Related Documents
- [Estrutura do Monorepo](../../04-development/repository-structure.md)
- [Guia de Setup Local](../../04-development/setup.md)
- [CI/CD](../../07-devops/ci-cd.md)
