# T25 — Implantar observabilidade e alertas

**Fase:** F6  | **Referências:** INF-012, INF-013

## Objetivo

Detectar, localizar e diagnosticar falhas de jornadas P0.

## Implementação

- Padronizar logs
- correlacionar request e operação técnica, sem criar auditoria de negócio
- criar métricas
- configurar dashboard e alertas.

## Dependências

T05, T10 e staging.

## Testes e validações

- Provocar 5xx
- rastrear correlation ID
- disparar alerta de p95
- verificar ausência de dados sensíveis.

## Agentes necessários

Executor: .agents/infrastructure-agent.md. Apoio: .agents/backend-agent.md e .agents/database-agent.md. Revisores: .agents/quality-security-agent.md.

## Métrica e evidência de aceite

Incidente sintético identificado e correlacionado em até 5 minutos.

## Critério de Done

Dashboard, alertas e runbook operacionais.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
