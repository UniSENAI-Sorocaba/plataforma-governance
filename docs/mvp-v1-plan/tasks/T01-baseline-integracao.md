# T01 — Consolidar baseline e plano de integração

**Fase:** F0  | **Referências:** PG-004, PG-013, PG-014, PG-018

## Objetivo

Definir uma base única de integração e eliminar ambiguidade entre main, origin/develop e branches de feature.

## Implementação

- Inventariar branches e commits
- selecionar PR canônico
- registrar ordem de merge
- criar matriz Backlog→SPEC→Issue→PR→commit→evidência
- usar origin/develop até a promoção para main.

## Dependências

Nenhuma; bloqueia as demais tasks.

## Testes e validações

- Simular merges
- verificar conflitos
- conferir owner/revisor de todo P0
- validar que status se refere a commit integrado.

## Agentes necessários

Executor: .agents/governance-agent.md. Revisores: LPO, .agents/architecture-agent.md e .agents/orchestrator.md. Aceite: PO.

## Métrica e evidência de aceite

100% dos P0 têm owner, revisor e caminho de integração. Evidência: matriz e decisão de baseline.

## Critério de Done

Baseline aprovada, duplicidades resolvidas e nenhum P0 sem caminho de integração.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
