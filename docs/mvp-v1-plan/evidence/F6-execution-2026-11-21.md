# Evidências de execução — F6

**Data:** 2026-11-21  
**Escopo:** hardening local, E2E e infraestrutura declarativa.

## Validações executadas

- `make check` em `plataforma-infrastructure`: fmt e validate de roots e módulos aprovados;
- `make up && make test-all`: 19 testes Terraform do MiniStack aprovados nos módulos database, ecs-cluster, ecs-service, load-balancer, network, registry, secrets e storage;
- `npm test` em `plataforma-quality`: testes estruturais aprovados;
- E2E real T15 com Playwright contra frontend, backend e PostgreSQL do stack: login, submissão de atividade e total visível aprovados;
- IDs sintéticos utilizados: projeto `f0000000-0000-4000-8000-000000000201`, período `f0000000-0000-4000-8000-000000000202`.

## Integração

- Quality PR #65 mergeado após correção de prontidão do navegador (`domcontentloaded` + espera explícita do formulário).
- Dados de E2E são sintéticos e não incluem credenciais reais.

## Limitações de release

Não foram executados contra AWS real: k6 a 200 RPS, DAST/containers em registry de produção, backup/restore de RDS, smoke de deploy e rollback. O repositório contém os contratos Terraform e módulos de secrets/KMS, mas a conta AWS, staging e domínio não estão disponíveis neste ambiente. O go/no-go de V1 permanece bloqueado por essas evidências externas e pela medição Lighthouse/staging.
