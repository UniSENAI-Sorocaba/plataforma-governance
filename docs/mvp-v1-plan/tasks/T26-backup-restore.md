# T26 — Implementar backup, restore e retenção

**Fase:** F6  | **Referências:** INF-015, INF-016, DB-018

## Objetivo

Garantir recuperação de dados e medir RPO/RTO.

## Implementação

- Configurar backup diário/retenção
- proteger armazenamento
- restaurar instância temporária
- validar schema/dados
- documentar RPO/RTO.

## Dependências

T03 e staging.

## Testes e validações

- Executar backup, restore, consultas restauradas, simulação de perda e revisão de acesso.

## Agentes necessários

Executor: .agents/infrastructure-agent.md + .agents/database-agent.md. Revisor: .agents/quality-security-agent.md. Validação: .agents/orchestrator.md. Aceite: PO/LPO.

## Métrica e evidência de aceite

Restore repetível com RPO/RTO dentro da meta aprovada.

## Critério de Done

Procedimento executado por pessoa diferente do autor e registrado.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
