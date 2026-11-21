# Evidências de execução — F6

**Data:** 2026-11-21  
**Escopo:** hardening local, E2E e infraestrutura declarativa.

## Validações executadas

- `make check` em `plataforma-infrastructure`: fmt e validate de roots e módulos aprovados;
- `make up && make test-all`: 19 testes Terraform do MiniStack aprovados nos módulos database, ecs-cluster, ecs-service, load-balancer, network, registry, secrets e storage;
- `npm test` em `plataforma-quality`: testes estruturais aprovados;
- cenário k6 versionado em `tests/performance/public-catalog.js` com meta de 200 RPS e p95 <= 500 ms;
- runbook de release em `plataforma-infrastructure/docs/05-operacao-release.md` cobrindo observabilidade, backup/restore e rollback;
- runbook de scans em `tests/security/scan-runbook.md` com gates SAST, SCA, IaC, imagem e DAST;
- teste de carga local contra backend e PostgreSQL do stack: 2.000 requisições em 10 s (200 RPS), 0 falhas, p95 302,4 ms e máximo 375,8 ms;
- `npm audit --audit-level=high` do frontend passou com 0 vulnerabilidades após atualização para Next.js 16.4.6;
- E2E real T15 com Playwright contra frontend, backend e PostgreSQL do stack: login, submissão de atividade e total visível aprovados;
- E2E real T16 com Playwright contra as versões atuais de frontend/backend e PostgreSQL: login de coordenação, atribuição de avaliação e rota visível aprovados;
- IDs sintéticos utilizados: projeto `f0000000-0000-4000-8000-000000000201`, período `f0000000-0000-4000-8000-000000000202`.

Para T16 também foram usados o projeto `f0000000-0000-4000-8000-000000000203`, o período `f0000000-0000-4000-8000-000000000204`, o aluno `b0000000-0000-4000-8000-000000000001` e o avaliador `b0000000-0000-4000-8000-000000000002`.

## Integração

- Quality PR #65 mergeado após correção de prontidão do navegador (`domcontentloaded` + espera explícita do formulário).
- Quality PR #66 mergeado após a mesma estabilização de prontidão aplicada ao cenário T16.
- Dados de E2E são sintéticos e não incluem credenciais reais.

## Limitações de release

Não foram executados contra AWS real: k6 propriamente dito, DAST/containers em registry de produção, backup/restore de RDS, smoke de deploy e rollback. O cenário k6 está versionado e a meta foi exercitada localmente por harness HTTP equivalente; isso não substitui o aceite AWS. Os runbooks estão preparados, mas a conta AWS, staging e domínio não estão disponíveis neste ambiente. O go/no-go de V1 permanece bloqueado por essas evidências externas e pela medição Lighthouse/staging.
