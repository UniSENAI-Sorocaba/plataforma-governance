# T13 — Implementar entregáveis e upload seguro

**Fase:** F3  | **Referências:** BE-012, BE-013, DB-011, FE-011, QA-014

## Objetivo

Permitir envio e acesso controlado a arquivos de projeto.

## Implementação

- Emitir URL temporária
- validar MIME/extensão/tamanho
- persistir hash, owner, versão e lifecycle
- restringir acesso
- exibir progresso/cancelamento.

## Dependências

T11, T12 e storage.

## Testes e validações

- Testar tipo/tamanho inválido, URL expirada, adulteração, acesso cruzado, cancelamento e hash/metadados.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/frontend-agent.md + .agents/database-agent.md. Revisor: .agents/infrastructure-agent.md. Validação: .agents/quality-security-agent.md.

## Métrica e evidência de aceite

100% dos abusos previstos são rejeitados; arquivos válidos são recuperáveis por papel autorizado.

## Critério de Done

Upload autorizado funciona sem exposição de arquivo privado.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
