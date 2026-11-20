# Evidências de execução — F4/T14

**Data:** 2026-11-20  
**Escopo:** T14 — editais e inscrições de Extensão (`BE-009`, `DB-012`, `FE-008`, `QA-012`)

## Decisões de produto aplicadas

- Edital é entidade própria e não é sinônimo de aviso.
- Coordenação cria, publica e encerra; aluno ativo com vínculo institucional ativo é elegível.
- Não há limite de vagas, fila ou aprovação manual no MVP.
- Janela inclusiva no início e exclusiva no fim: `starts_at <= now < ends_at`.
- Uma inscrição por aluno/edital; desistência só durante a janela e sem reenvio no mesmo edital.
- API e interface são a comunicação oficial; e-mail permanece fora do escopo.

## Implementação

- Database: migration `V0012__create_extension_opportunities_and_applications.sql`, com estados, constraints de janela, unicidade, FKs e índices.
- Backend: endpoints de criação, publicação, encerramento, consulta pública, inscrição, listagem própria, listagem autorizada e desistência; autorização server-side e `Clock` injetável.
- Frontend: rota `/extension`, cards públicos, janela formatada, inscrição e estados de carregamento/sucesso/erro.

## Validações executadas

- `make up && make migrate && make validate && make down` em `plataforma-database`: migration aplicada após V0011 e validações concluídas.
- `mvn --batch-mode verify -q` em `plataforma-backend`: 80 testes, gate Maven e coverage-gate aprovados.
- `npm run check` em `plataforma-frontend`: lint, typecheck, 21 testes e build aprovados.
- CI GitHub: backend Maven/coverage/authorization, database migration/validate e frontend check concluídos com sucesso.

## Aceite T14

Janela, elegibilidade, duplicidade, desistência e limite de fronteira foram cobertos por testes de serviço e constraints do banco. Nenhuma inscrição duplicada ou fora da janela é persistida pela implementação.

## Integração

- Governança e decisões: PR [#43](https://github.com/UniSENAI-Sorocaba/plataforma-governance/pull/43), merge `b1e73f8`.
- Database: PR [#47](https://github.com/UniSENAI-Sorocaba/plataforma-database/pull/47), merge `5ffa75c`.
- Backend: PR [#63](https://github.com/UniSENAI-Sorocaba/plataforma-backend/pull/63), merge `085e6af`.
- Frontend: PR [#65](https://github.com/UniSENAI-Sorocaba/plataforma-frontend/pull/65), merge `fdcb606`.

## Limitações

- O E2E browser específico de T14 ainda depende de dados sintéticos de edital publicado; o E2E de T13 foi executado anteriormente contra os serviços reais.
- T15 — atividades e horas — implementada e evidenciada em [F4-T15-execution-2026-11-20.md](./F4-T15-execution-2026-11-20.md).
