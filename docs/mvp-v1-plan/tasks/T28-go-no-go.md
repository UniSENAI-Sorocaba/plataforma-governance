# T28 — Fechar pacote de homologação e go/no-go

**Fase:** F6  | **Referências:** PG-017, PG-018, QA-028, QA-029, QA-030

## Objetivo

Consolidar evidências, riscos e decisão formal de release.

## Implementação

- Preencher matriz
- relacionar Must Have a SPEC/Issue/PR/evidência
- registrar riscos e pareceres
- publicar go/no-go.

## Dependências

Todas as tasks anteriores, especialmente T22–T27.

## Testes e validações

- Conferir checklist 100%, ausência de P0 sem decisão, pacote navegável, smoke/rollback anexados e revisão independente.

## Agentes necessários

Executor: .agents/orchestrator.md + .agents/governance-agent.md. Revisores: .agents/quality-security-agent.md, .agents/infrastructure-agent.md e .agents/architecture-agent.md. Aceite: PO/LPO.

## Métrica e evidência de aceite

100% dos Must Haves com rastreabilidade completa; exceções formalmente aprovadas.

## Critério de Done

Go aprovado ou no-go registrado com bloqueios, owners e próximos passos.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
