# Evidência de execução — Fase 2

**Data:** 2026-11-21  
**Status:** concluída no ambiente local integrado; o gate de recuperação/primeiro acesso e E2E contra backend + banco reais foi fechado em 2026-11-21. A configuração de credenciais SMTP de produção continua sendo operação de ambiente, não lacuna de implementação.

## Escopo concluído

| Item | Resultado | Branch/PR | Evidência |
|---|---|---|---|
| DB-003 — Seeds determinísticos | Concluído | `f2-identity`, PR [#41](https://github.com/UniSENAI-Sorocaba/plataforma-database/pull/41) | Merge `f1734468`; CI verde |
| DB-004 — Identidade e vínculo institucional | Concluído | `f2-identity`, PR [#41](https://github.com/UniSENAI-Sorocaba/plataforma-database/pull/41) | V0003, constraints, índices, anti-PII e upgrade validados |
| BE-005 — Hash de credenciais Argon2id | Concluído | `f2-credentials`, PR [#50](https://github.com/UniSENAI-Sorocaba/plataforma-backend/pull/50) | Merge `1d4ee653`; Maven e coverage-gate verdes |
| BE-006/T07 — Núcleo de login JWT RS256 | Em revisão | `f2-login-jwt`, PR [#51](https://github.com/UniSENAI-Sorocaba/plataforma-backend/pull/51) | Access token com claims, TTL de 15 min, proteção stateless condicional e erro genérico |
| DB-005 — Sessões, refresh e recuperação | Concluído | `f2-session-schema`, PR [#42](https://github.com/UniSENAI-Sorocaba/plataforma-database/pull/42) | Merge `ad727161`; CI de banco verde |
| BE-006/T08 — Núcleo de refresh e recuperação | Concluído | `f2-session-backend`, PR [#52](https://github.com/UniSENAI-Sorocaba/plataforma-backend/pull/52) | Merge `95ada467`; Maven verify e coverage-gate verdes |
| BE-006/T08 — Adapter JDBC DB-005 | Concluído | `f2-session-jdbc`, PR [#53](https://github.com/UniSENAI-Sorocaba/plataforma-backend/pull/53) | Merge `aa0dffd`; Maven verify e coverage-gate verdes |
| DB-006 — Papéis, permissões e escopos RBAC | Concluído | `f2-db006`, PR [#43](https://github.com/UniSENAI-Sorocaba/plataforma-database/pull/43) | Merge `9036eb6`; instalação, upgrade, idempotência, anti-PII e validações DB-005/DB-006/DB-007 verdes |
| BE-010/T09 — Autorização HTTP por rota | Concluído | `f2-rbac`, PR [#54](https://github.com/UniSENAI-Sorocaba/plataforma-backend/pull/54) | Merge `3435c386`; 60 testes, Maven verify, cobertura e autorização verdes |
| FE-004/T07 — Jornada de login | Concluído | `f2-frontend-auth`, PR [#57](https://github.com/UniSENAI-Sorocaba/plataforma-frontend/pull/57) | Merge `44e9963`; `npm run check` verde; sem fallback de sessão demo |
| BE-006/T08 — HTTP refresh/logout | Concluído | `f2-session-http`, PR [#55](https://github.com/UniSENAI-Sorocaba/plataforma-backend/pull/55) | Merge `58bd99a`; `mvn test` com 61 testes; rotação, reuse, expiração e revogação cobertos |
| FE-005/T08 — Renovação/logout no cliente | Concluído | `f2-frontend-auth`, PR [#58](https://github.com/UniSENAI-Sorocaba/plataforma-frontend/pull/58) | Merge `b02f32b`; `npm run check` verde; refresh atualiza tokens e 401 limpa sessão |
| BE-006/T08 — Entrega SMTP e composição JDBC | Concluído | `f6-be-018-impact-authorization`, PR [#72](https://github.com/UniSENAI-Sorocaba/plataforma-backend/pull/72) | Merge `b851398`; adapter SMTP configurável, lookup JDBC e composição real do serviço |
| QA/T08 — E2E identidade integrado | Concluído | `f6-quality-gates`, PR [#68](https://github.com/UniSENAI-Sorocaba/plataforma-quality/pull/68) | Merge `c8efcee`; backend + PostgreSQL + Mailpit reais, ativação, recuperação, reset e single-use |
| INF/T08 — SMTP local reproduzível | Concluído | `f6-infra-operations-runbook`, PR [#44](https://github.com/UniSENAI-Sorocaba/plataforma-infrastructure/pull/44) | Merge `3708dae`; Mailpit versionado no compose local |

## Implementação backend

- `PasswordEncoder` configurado com Argon2id.
- Serviço de credenciais sem persistência de senha em claro.
- Senha vazia rejeitada.
- Verificação de senha correta/incorreta coberta por teste.
- Mesmo segredo gera hashes diferentes por causa do salt.
- Dependência Bouncy Castle adicionada para suporte ao Argon2.

## Validações

### Database

```text
make up
make migrate
make seed
make test
make down
```

Resultado: sucesso. V0003 foi aplicada, seeds foram determinísticos, constraints/índices/anti-PII passaram e o upgrade incremental foi validado em banco isolado.

### Backend

```text
mvn verify
```

Resultado: sucesso; 10 testes aprovados e coverage-gate aprovado.

Após T07: `mvn test` aprovou 12 testes e `mvn verify` concluiu com coverage-gate aprovado.

Após o núcleo T08: `mvn test` aprovou 24 testes e `mvn verify` concluiu com coverage-gate aprovado.

PR #52 foi integrada por squash com o commit `95ada467ec929df3343263823460960a3b1e13b`.
PR #42 foi integrada por squash com o commit `ad7271611f8c398f94f0b9abcdb69a029a379024`.

PR #53 foi integrada por squash com o commit `aa0dffdffd3ca1aa530f4fe07a2e810bf4057689`; local e remotamente `mvn verify` aprovou 24 testes e coverage-gate.

PR #54 foi integrada por squash com o commit `3435c386f68b3507afe20db9422b548dade0c19f`; local e remotamente os três checks passaram.

PR #43 foi integrada por squash com o commit `9036eb6bde92a079fbd0ea99f2742ca61c5c60c7`; a validação de banco passou em instalação limpa, upgrade, idempotência, DB-005, DB-006 e DB-007.

PR #57 foi integrada por squash com o commit `44e99630df32cb27e1c37d8f23d328dd888920ca`; `npm run check` passou com lint, typecheck, testes e build.

PR #55 foi integrada por squash com o commit `58bd99a931c1c9c51484db239e85af7a299c916e`; `mvn test` passou com 61 testes, incluindo testes HTTP de refresh, logout e resposta 401 sem credencial.

PR #58 foi integrada por squash com o commit `b02f32bd863530d9fca258c0345dae24c91dfc54`; `npm run check` passou com lint, typecheck, testes e build.

PR #72 foi integrada por squash com o commit `b851398397c746e6e861b1eae7c9bf16a8d79510`; os checks `coverage-gate`, `Maven verify` e `Authorization tests and coverage` passaram.

PR #68 foi integrada por squash com o commit `c8efceed99c7b34d6dd622ce182a7019cfd7af7c`; o cenário `tests/e2e/t07-identity-recovery.mjs` passou contra backend fonte, PostgreSQL real e Mailpit.

PR #44 foi integrada por squash com o commit `3708dae0ad97d427a97d978d95c6952bcad0d703`; o compose local passou a fornecer SMTP sintético reproduzível.

### E2E real de primeiro acesso e recuperação

Execução em 2026-11-21 com `SECURITY_PASSWORD_RECOVERY_DELIVERY=smtp`, backend fonte na porta 18081, PostgreSQL do stack e Mailpit:

```text
{"health":"passed","firstAccess":"passed","recoveryRequest":"passed","smtpDelivery":"passed","passwordReset":"passed","recoveredLogin":"passed","tokenReuseRejected":"passed"}
```

O token foi extraído somente em memória da mensagem sintética; não foi gravado em evidência nem impresso no relatório.

### Database DB-005/DB-006

`make up && make migrate && make test && make down`: PASS. A instalação incremental, o upgrade desde V0001, a idempotência de migrations/seeds e o fluxo sintético de rotação, revogação e uso único foram aprovados.

O mesmo ciclo foi repetido após DB-006 com `make seed`; os objetos RBAC, constraints de escopo, vínculos determinísticos e regras anti-duplicidade foram aprovados. A migration V0007 também foi incluída porque já era exigida pelo validador do `main`, preservando `audit_event` sem snapshots.

## Agentes envolvidos

- Executor: `.agents/database-agent.md` e `.agents/backend-agent.md`.
- Revisão arquitetural: `.agents/architecture-agent.md`.
- Validação: `.agents/quality-security-agent.md`.
- Orquestração: `.agents/orchestrator.md`.

## Gate de saída

**PASS local:** identidade, credenciais Argon2id, JWT, refresh/logout, RBAC, primeiro acesso e recuperação com entrega SMTP foram validados por testes automatizados e E2E contra PostgreSQL real. O único passo operacional restante é fornecer as credenciais/host SMTP do ambiente de staging/produção antes do deploy, sem alteração de código.
