# T14 — Implementar editais e inscrições

**Fase:** F4  | **Referências:** BE-009, DB-012, FE-008, QA-012

## Objetivo

Controlar janela, elegibilidade e unicidade de inscrições.

## Implementação

- Modelar janela/status
- validar data no servidor com relógio injetável
- aplicar unicidade
- exibir status e resultado.

## Dependências

T03, T09 e T11.

## Testes e validações

- Testar antes/durante/depois da janela, duplicidade, inelegibilidade, timezone e E2E.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md. Revisor: .agents/architecture-agent.md. Validação: .agents/quality-security-agent.md. Aceite: PO.

## Métrica e evidência de aceite

Zero inscrição fora da regra ou duplicada.

## Critério de Done

Inscrição válida confirmada; inválida recebe motivo seguro.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
