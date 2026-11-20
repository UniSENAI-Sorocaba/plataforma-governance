# T05 — Padronizar backend, observabilidade base e healthcheck

**Fase:** F1  | **Referências:** BE-001, BE-002

## Objetivo

Criar base modular, previsível e observável para todas as APIs.

## Implementação

- Consolidar limites de módulos
- implementar handler de erros
- adicionar correlation ID
- expor healthcheck sem dados internos
- injetar relógio para testes.

## Dependências

T02 e T04.

## Testes e validações

- Testar contexto Spring, healthcheck, validação, recurso inexistente e propagação de correlation ID
- inspecionar logs em busca de tokens/senhas.

## Agentes necessários

Executor: .agents/backend-agent.md. Revisor: .agents/architecture-agent.md. Validação: .agents/quality-security-agent.md.

## Métrica e evidência de aceite

mvn verify verde; healthcheck responde em até 1 s local; 100% dos erros P0 seguem o envelope.

## Critério de Done

Backend base integrado e validado pelo CI.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.

