# T12 — Implementar solicitações e gestão de equipe

**Fase:** F3  | **Referências:** BE-008, FE-007, FE-009, QA-011

## Objetivo

Permitir solicitação de participação pelo aluno, decisão docente e remoção justificada com integridade.

## Implementação

- Criar solicitação idempotente
- aprovar ou negar com autorização
- permitir retirada de solicitação pendente;
- permitir novo pedido somente em período posterior após negação, retirada ou remoção;
- guardar motivo
- aplicar limite
- bloquear duplicidade e corrida de aprovação, retornando `409 Conflict` sem alteração parcial.

## Dependências

T11.

## Testes e validações

- Testar aprovação/negação/retirada/remoção, elegibilidade, solicitação duplicada, reenvio no mesmo e em novo período, duas aprovações simultâneas, usuário sem permissão e E2E.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/frontend-agent.md. Revisor: .agents/database-agent.md. Validação: .agents/quality-security-agent.md. Aceite: PO.

## Métrica e evidência de aceite

Zero inconsistência de equipe nos testes concorrentes.

## Critério de Done

Equipe consistente no banco, API e interface.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
