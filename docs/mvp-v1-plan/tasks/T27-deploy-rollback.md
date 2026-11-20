# T27 — Ensaiar deploy, smoke e rollback

**Fase:** F6  | **Referências:** INF-018, INF-019, INF-020, INF-021

## Objetivo

Implantar staging e demonstrar recuperação segura da versão anterior.

## Implementação

- Publicar artefato imutável
- executar deploy
- definir gatilhos
- recuperar versão anterior
- executar smoke
- atualizar runbooks.

## Dependências

T22, T23, T25 e T26.

## Testes e validações

- Testar deploy limpo, falha induzida/rollback, smoke, migrations compatíveis e runbook independente.

## Agentes necessários

Executor: .agents/infrastructure-agent.md + .agents/orchestrator.md. Revisores: .agents/quality-security-agent.md, .agents/backend-agent.md, .agents/frontend-agent.md e .agents/database-agent.md.

## Métrica e evidência de aceite

Rollback restaura versão anterior e smoke passa 100%.

## Critério de Done

Versão implantada, rollback comprovado e evidências anexadas.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
