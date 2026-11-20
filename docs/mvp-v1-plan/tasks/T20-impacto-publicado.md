# T20 — Implementar workflow de impacto publicado

**Fase:** F5  | **Referências:** BE-019, DB-015, FE-016

## Objetivo

Publicar impacto social somente após aprovação e preservar versão/origem.

## Implementação

- Criar estados
- permitir revisão/aprovação/retirada
- versionar conteúdo
- renderizar apenas aprovado.

## Dependências

T11 e T10.

## Testes e validações

- Testar transições, rascunho não público, retirada e estabilidade da versão, sem criar auditoria persistente de negócio.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md. Validação: .agents/quality-security-agent.md. Aceite: PO.

## Métrica e evidência de aceite

Zero conteúdo não aprovado renderizado publicamente.

## Critério de Done

Impacto publicado é aprovado, versionado conforme contrato e retirável; a evidência não depende de auditoria de negócio.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
