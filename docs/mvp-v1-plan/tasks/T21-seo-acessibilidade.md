# T21 — Implementar SEO, acessibilidade e Web Vitals

**Fase:** F5  | **Referências:** FE-017, FE-018, FE-019, QA-020, QA-021

## Objetivo

Garantir portal indexável, acessível e com desempenho mensurável.

## Implementação

- Implementar metadata, sitemap, robots, canonical, teclado, foco, labels, contraste, coleta de LCP/INP/CLS, SSR e cache.

## Dependências

T19 e T20.

## Testes e validações

- Executar axe/Lighthouse
- navegar por teclado
- validar sitemap/robots e HTML SSR
- medir Lighthouse.

## Agentes necessários

Executor: .agents/frontend-agent.md. Revisores: .agents/quality-security-agent.md e .agents/infrastructure-agent.md.

## Métrica e evidência de aceite

Zero bloqueador crítico; Lighthouse >= 90 em performance, acessibilidade e SEO.

## Critério de Done

Portal atende metas em staging.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
