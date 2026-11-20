# T02 — Congelar contratos de API e erros

**Fase:** F0  | **Referências:** BE-003, QA-010

## Objetivo

Estabelecer contratos OpenAPI/JSON Schema estáveis para backend, frontend e quality.

## Implementação

- Consolidar OpenAPI 3.1
- definir envelope de erro, códigos, correlation ID e paginação
- versionar schemas e fixtures
- configurar breaking-change check.

## Dependências

T01.

## Testes e validações

- Executar lint OpenAPI, gerar mock, rodar contract tests e validar respostas 400/401/403/404/409
- introduzir breaking change sintético e confirmar bloqueio.

## Agentes necessários

Executor: .agents/architecture-agent.md + .agents/backend-agent.md. Revisores: .agents/quality-security-agent.md e .agents/frontend-agent.md. Aceite: PO.

## Métrica e evidência de aceite

100% dos endpoints P0 documentados e validados. Evidência: contrato, mock e relatório.

## Critério de Done

Contrato aprovado e consumido por backend, frontend e quality sem divergência.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
