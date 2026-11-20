# T10 — Implementar logs técnicos sanitizados

**Fase:** F2  | **Referências:** BE-016, DB-007, QA-022

## Objetivo

Disponibilizar logs operacionais mínimos, correlacionáveis e sanitizados,
sem criar auditoria persistente de negócio.

## Implementação

- padronizar correlation ID, resultado e contexto operacional mínimo;
- aplicar retenção técnica;
- remover senhas, tokens, CPF completo e payloads sensíveis;
- impedir que os logs sejam usados como histórico funcional.

## Dependências

T05, T06 e T09.

## Testes e validações

- Testar login, logout, reset, autorização, proposta, avaliação e certificado;
- validar retenção, correlação e sanitização;
- confirmar que não existe persistência de eventos de auditoria de negócio.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/database-agent.md. Revisor: .agents/architecture-agent.md. Validação: .agents/quality-security-agent.md. Aceite: .agents/governance-agent.md.

## Métrica e evidência de aceite

100% das jornadas P0 instrumentadas possuem correlation ID e nenhum segredo nos logs.

## Critério de Done

Logs técnicos disponíveis para operação, sanitizados e sem consulta funcional de auditoria.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
