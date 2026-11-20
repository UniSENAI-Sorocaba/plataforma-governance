# T24 — Executar teste de carga e corrigir gargalos

**Fase:** F6  | **Referências:** QA-024, DB-017, DB-019, INF-017

## Objetivo

Comprovar capacidade operacional mínima do MVP.

## Implementação

- Definir cenários
- preparar dataset
- ajustar pool/índices/cache/autoscaling
- registrar baseline e pós-correção.

## Dependências

T19, T21 e staging.

## Testes e validações

- Executar 200 RPS
- p95 <= 500 ms
- erro < 1%
- verificar pool e slow queries.

## Agentes necessários

Executor: .agents/quality-security-agent.md + .agents/infrastructure-agent.md + .agents/database-agent.md. Revisor: .agents/backend-agent.md. Aceite: .agents/orchestrator.md.

## Métrica e evidência de aceite

Todos os limites aprovados em relatório k6/APM.

## Critério de Done

Gargalos corrigidos ou aceitos formalmente com mitigação.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.

