# T04 — Preparar pipeline mínimo de CI

**Fase:** F0  | **Referências:** INF-003, QA-003, QA-007

## Objetivo

Criar gates automatizados para backend, frontend, database, quality e infrastructure.

## Implementação

- Criar jobs isolados
- publicar testes, cobertura e scans
- bloquear merge em falha
- configurar cache seguro
- documentar comandos oficiais.

## Dependências

T02 e T03.

## Testes e validações

- Executar PR válido
- inserir falha sintética
- conferir artefatos
- verificar que secrets não aparecem nos logs.

## Agentes necessários

Executor: .agents/infrastructure-agent.md. Revisores: .agents/quality-security-agent.md. Aceite: .agents/governance-agent.md.

## Métrica e evidência de aceite

100% dos repositórios P0 têm pipeline executável e resultado publicado.

## Critério de Done

Pipeline verde em PR válido e vermelho em falha controlada.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.

