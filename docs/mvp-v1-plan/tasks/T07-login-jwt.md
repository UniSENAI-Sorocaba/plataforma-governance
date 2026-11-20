# T07 — Implementar login JWT RS256

**Fase:** F2  | **Referências:** BE-004, FE-004, QA-008

## Objetivo

Permitir login institucional seguro e integração com a experiência autenticada.

## Implementação

- Configurar chaves RSA via secret manager
- emitir claims obrigatórias
- validar assinatura, issuer, audience e expiração
- integrar formulário com loading/erro.

## Dependências

T06.

## Testes e validações

- Testar login válido/inválido, token expirado, chave incorreta e claims ausentes
- executar E2E de redirecionamento
- inspecionar bundle.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/frontend-agent.md. Revisor: .agents/architecture-agent.md. Validação: .agents/quality-security-agent.md. Aceite: PO.

## Métrica e evidência de aceite

100% dos testes de login aprovados; zero chave privada no código/frontend.

## Critério de Done

Login funciona ponta a ponta em ambiente de teste.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
