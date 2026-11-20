# T17 — Implementar rubricas e cálculo de notas

**Fase:** F4  | **Referências:** BE-015, DB-010, FE-013, QA-016

## Objetivo

Calcular notas determinísticas, versionadas e auditáveis.

## Implementação

- Criar rubrica/ pesos
- validar soma/limites
- persistir respostas e versão
- documentar precisão/rounding
- consolidar após completude.

## Dependências

T16, T10 e T11.

## Testes e validações

- Testar fixtures conhecidos, pesos inválidos, limites, rounding, idempotência e permissões de edição/fechamento.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md. Revisor: .agents/architecture-agent.md. Validação: .agents/quality-security-agent.md. Aceite: PO.

## Métrica e evidência de aceite

100% dos fixtures retornam nota esperada e reproduzível.

## Critério de Done

Nota recalculável a partir dos dados e versão da rubrica.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.

