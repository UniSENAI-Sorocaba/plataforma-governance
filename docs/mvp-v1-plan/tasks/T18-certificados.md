# T18 — Emitir e validar certificado

**Fase:** F4  | **Referências:** BE-017, FE-014, QA-017

## Objetivo

Emitir certificado verificável publicamente e detectar adulteração/revogação.

## Implementação

- Criar payload canônico/identificador
- calcular SHA-256
- gerar QR
- controlar emissão/revogação
- limitar dados públicos.

## Dependências

T15, T17 e T10.

## Testes e validações

- Testar certificado legítimo, hash alterado, QR inválido, revogação, papel não autorizado e idempotência.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/frontend-agent.md. Revisor: .agents/architecture-agent.md. Validação: .agents/quality-security-agent.md. Aceite: PO.

## Métrica e evidência de aceite

100% dos certificados adulterados ou revogados são identificados.

## Critério de Done

Certificado emitido, baixado e validado sem login.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
