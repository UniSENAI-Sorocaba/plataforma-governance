# T09 — Implementar RBAC e autorização por rota

**Fase:** F2  | **Referências:** DB-006, BE-010, QA-009

## Objetivo

Aplicar autorização server-side por papel, permissão e escopo.

## Implementação

- Definir catálogo
- aplicar deny-by-default
- proteger cada rota
- separar autenticação/autorização
- auditar decisão sem dados sensíveis.

## Dependências

T07.

## Testes e validações

- Executar matriz 401/403, allow/deny por perfil, acesso horizontal indevido e escopo institucional
- revisar rotas sem política.

## Agentes necessários

Executor: .agents/backend-agent.md. Revisor: .agents/architecture-agent.md. Validação: .agents/quality-security-agent.md. Aceite: PO.

## Métrica e evidência de aceite

100% das rotas protegidas listadas e cobertas por allow/deny.

## Critério de Done

Nenhuma rota protegida depende apenas do frontend.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
