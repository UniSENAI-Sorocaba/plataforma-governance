# T08 — Implementar sessão, refresh, logout e recuperação

**Fase:** F2  | **Referências:** DB-005, BE-006, AUTH-10-BE, FE-005, QA-008

## Objetivo

Controlar ciclo completo da sessão e recuperação segura de acesso.

## Implementação

- Armazenar hash de refresh
- rotacionar
- invalidar família em reuse
- revogar logout
- criar token de recuperação de uso único
- resposta uniforme.

## Dependências

T06 e T07.

## Testes e validações

- Testar refresh/rotação, reuse, logout, expiração, recuperação de uso único e E2E de expiração de sessão.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md. Revisor: .agents/architecture-agent.md. Validação: .agents/quality-security-agent.md. Aceite: PO.

## Métrica e evidência de aceite

100% dos testes de sessão passam; nenhum token aparece em log.

## Critério de Done

Sessão e recuperação funcionam sem token reutilizável ou sessão órfã.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
