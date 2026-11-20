# T03 — Tornar migrations e seeds reproduzíveis

**Fase:** F0  | **Referências:** DB-001, DB-002, DB-003, DB-016

## Objetivo

Garantir instalação limpa, upgrade incremental, seeds determinísticos e detecção de drift.

## Implementação

- Ordenar migrations
- separar schema, seed e fixture
- criar comandos de banco limpo/upgrade/validate
- versionar PostgreSQL
- remover dados pessoais.

## Dependências

T01.

## Testes e validações

- Aplicar banco vazio
- executar upgrade
- rodar seed duas vezes e comparar
- executar drift detection
- validar schemas, constraints e índices.

## Agentes necessários

Executor: .agents/database-agent.md. Revisores: .agents/backend-agent.md e .agents/quality-security-agent.md. Apoio: .agents/infrastructure-agent.md.

## Métrica e evidência de aceite

100% das migrations passam em instalação limpa e upgrade. Evidência: logs e relatório de drift.

## Critério de Done

CI executa banco limpo, upgrade e validação sem intervenção manual.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.

