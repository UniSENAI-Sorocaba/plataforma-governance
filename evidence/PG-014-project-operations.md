---
id: PG-014-EVIDENCE
status: Implemented; operational review pending
work_id: PG-014
owner: Luciano Menezes Júnior
reviewer: Fellipe Raszejas
reviewed_at: 2026-11-04
---

# PG-014 — GitHub Project operacional

## Auditoria anterior

O Project organizacional **Plataforma Digital — 2026.2** já existia no GitHub como Project #12. A auditoria confirmou campos de Status, Sprint, Squad, Priority, Size, Work ID, Review owner, Dependencies e Responsável planejado, além de views gerais, por sprint e por squad.

## Correções aplicadas

- Milestones reais criados no repositório `plataforma-governance`: Sprint 0 a Sprint 6 e Release v1.0.0.
- O Project #12 permanece como portfólio único da organização.
- O estado operacional continua pertencendo ao Project, não a arquivos Markdown.

## Checklist

- [x] Project organizacional existente.
- [x] Campos de status, sprint, squad, prioridade, tamanho, dependências e release disponíveis.
- [x] Views de backlog, sprint e squad existentes.
- [x] Milestones Sprint 0–6 criados no repositório de governança.
- [x] Milestone Release v1.0.0 criado.
- [ ] Validar automações de transição com uma Issue e um PR de teste.
- [ ] Revisão formal do PO registrada no PR.

## Limitação

As automações de Project V2 são controladas pela configuração do GitHub e não são totalmente representadas por arquivos do repositório. A existência dos campos/views foi verificada via API; a transição automática ainda requer teste operacional no Project.

## Rastreabilidade

- [Configuração declarativa do GitHub Project](../GITHUB_CONFIGURATION.md#6-github-project-organizacional)
- [Fonte de verdade](../_KB/governance/source-of-truth.md)
- [Processo de entrega](../_KB/governance/delivery-process.md)
- [Issue PG-014](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/14)
