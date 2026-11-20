# T16 — Implementar avaliações e vínculos

**Fase:** F4  | **Referências:** BE-011, DB-009, FE-010, QA-013

## Objetivo

Permitir avaliações com vínculo e autorização válidos, sem bancas, agenda, salas ou links.

## Implementação

- Modelar avaliação/avaliador/vínculo
- validar autorização e vínculo
- proteger concorrência.

## Dependências

T11 e T09.

## Testes e validações

- Testar avaliador inválido/duplicado, vínculo ausente e atribuição não autorizada.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md. Revisor: .agents/architecture-agent.md. Validação: .agents/quality-security-agent.md. Aceite: PO.

## Métrica e evidência de aceite

100% dos vínculos e autorizações inválidos previstos são bloqueados.

## Critério de Done

Avaliação válida criada; vínculo ou autorização inválidos retornam motivo claro.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
