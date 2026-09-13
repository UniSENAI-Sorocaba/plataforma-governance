# Auditoria organizacional — 2026-09-12

> Tipo: relatório operacional, não normativo
> Escopo: estado local dos seis repositórios da Plataforma Digital

## Resultado

Governance era o único repositório com histórico e conteúdo. Backend, frontend, database, infrastructure e quality existiam com remote configurado, branch `main` vazia e nenhuma estrutura de trabalho. Foram preparados scaffolds mínimos alinhados à baseline e aos itens S0 dos backlogs.

| Repositório | Situação encontrada | Bootstrap criado | Próximo owner |
| --- | --- | --- | --- |
| backend | vazio | Java 21/Spring Boot 3, healthcheck, módulos e teste | Backend |
| frontend | vazio | Next.js/TypeScript SSR, página inicial e checks | Frontend |
| database | vazio | PostgreSQL 16, schemas, migration e validação | Database |
| infrastructure | vazio | roots por ambiente e contratos Terraform | Cloud & DevOps |
| quality | vazio | estratégia, matriz, templates e áreas de testes | Quality/Security |

## Pendências bloqueantes

1. **Baseline imutável não publicada:** `_KB/README.md` anuncia `governance-v0.1.0-candidate`, enquanto ADR-008 e a configuração do GitHub exigem `governance-v0.1.0`; nenhuma tag existe localmente. Product Governance deve revisar, aprovar e publicar a tag `governance-v0.1.0` no SHA pretendido. Os consumidores apontam provisoriamente para o SHA `379131e3fa7c0411d5055b14b6bb30dd0853a3b5`.
2. **Issues ainda são aliases Markdown:** a própria governança determina que GitHub Issues/Project sejam a fonte operacional. Importar `PG-*`, `BE-*`, `FE-*`, `DB-*`, `INF-*` e `QA-*`, preservando dependências, owners e revisores.
3. **Proteções ainda sem evidência:** criar Teams, CODEOWNERS, rulesets, required checks, environments e OIDC e executar um PR de teste por repositório, conforme `GITHUB_CONFIGURATION.md`.
4. **Contratos globais ausentes:** `_KB/contracts/README.md` ainda não contém OpenAPI 3.1/JSON Schemas consumíveis. `BE-003` e `QA-010` dependem desse trabalho contract-first.

## Pendências de decisão

- confirmar usernames ainda não identificados com segurança;
- aprovar topologia do Spring Boot sem ressuscitar decisões superseded;
- escolher e registrar o serviço AWS para o Next.js SSR;
- definir cache, mensageria, e-mail e observabilidade;
- aprovar RTO/RPO antes da política definitiva de backup/restore.

## Ordem recomendada

1. Aprovar/publicar a baseline e atualizar o front matter que ainda diz `candidate`.
2. Importar backlogs e criar Teams/ownership.
3. Integrar e revisar os cinco commits de bootstrap.
4. Implementar CI reutilizável e checks obrigatórios.
5. Executar as Issues S0 na ordem das dependências já registrada nos backlogs.

Este relatório não promove Drafts, não altera SPECs e não declara itens do backlog como Done.

## Validações locais do bootstrap

- Backend: `mvn verify` com JDK 21 — PASS.
- Frontend: `npm run check` (lint, tipos, teste e build SSR) — PASS; instalação auditada com 0 vulnerabilidades reportadas.
- Quality: `npm test` — PASS.
- Database: `docker compose config -q` e `sh -n scripts/*.sh` — PASS. Execução de migration em PostgreSQL 16 não confirmada porque o daemon Docker não estava acessível nesta sessão.
- Infrastructure: `terraform fmt/validate` não executados; CLI Terraform não instalada localmente e daemon Docker não acessível nesta sessão.
- Spec-compliance remoto: pendente da publicação da tag normativa e de uma Issue/contratos aplicáveis.
