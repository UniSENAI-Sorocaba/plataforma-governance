---
id: PG-003-EVIDENCE
status: Owner approved; reviewer pending
work_id: PG-003
owner: Luciano Menezes Júnior
reviewer: Fellipe Raszejas
approved_at: 2026-11-04
approved_by: Luciano Menezes Júnior
---

# PG-003 — Squads, RACI e arquivamento da baseline

## Objetivo

Confirmar a composição vigente das squads, atribuir responsabilidades por meio da RACI e preservar a estrutura anterior apenas como histórico.

## Estrutura vigente

| Squad | Fonte de verdade | Responsabilidade principal |
| --- | --- | --- |
| Product | `governance/squads.md` | visão, backlog, aceite e decisões de produto |
| Backend | `governance/squads.md` | API, regras de negócio e contratos de backend |
| Frontend | `governance/squads.md` | aplicações Next.js, SSR e experiência do usuário |
| Database | `governance/squads.md` | schemas, migrations, seeds e integridade |
| Cloud & DevOps | `governance/squads.md` | AWS, IaC, CI/CD, observabilidade e release |
| Quality, Tests & Security | `governance/squads.md` | evidências, testes, segurança e gates |

## RACI operacional

| Atividade | Accountable | Responsible | Consulted | Informed |
| --- | --- | --- | --- | --- |
| Visão e prioridade global | LPO | PO | Produto e líderes | Squads |
| Refinamento e ordenação do backlog | PO | PO | LPO e líderes | Squads |
| Arquitetura e contratos | Líder da squad | Referência técnica | PO, LPO e Quality/Security | Squads impactadas |
| Implementação | Líder da squad | Referência e membros | Quality/Security | PO |
| Evidência e quality gate | Quality/Security | Quality/Security e squad executora | PO e líderes | LPO |
| Aceite funcional | PO; LPO em impasse | PO | Líder e Quality/Security | Squads |
| Release | PO pelo produto | Quality/Security pelos gates | Cloud & DevOps e líderes | LPO |

## Baseline anterior

A estrutura anterior não é apagada. Ela permanece arquivada em `_KB/archive/legacy-2026-09-09/` e é tratada como evidência histórica. A composição normativa vigente é a definida em `_KB/governance/squads.md`; `new_teams.md` permanece como fonte organizacional de origem e deve permanecer alinhado à KB ativa.

## Rastreabilidade

- [Composição definitiva das squads](../new_teams.md)
- [Squads oficiais](../_KB/governance/squads.md)
- [RACI e responsabilidades](../_KB/governance/responsibilities.md)
- [Fontes de verdade](../_KB/governance/source-of-truth.md)
- [Baseline arquivada](../_KB/archive/legacy-2026-09-09/)
- [Issue PG-003](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/3)

## Critérios de aceite

- [x] Squads vigentes documentadas.
- [x] RACI operacional publicada.
- [x] Baseline anterior preservada no arquivo histórico.
- [x] Fonte de verdade vigente identificada.
- [x] Aprovação do owner registrada na Issue PG-003.
- [ ] Eventuais conflitos remanescentes entre documentos legados e vigentes revisados.

## Limitação

Este artefato implementa a estrutura documental e a rastreabilidade local. A aprovação final da Issue e qualquer alteração de Teams/permissões no GitHub exigem revisão e autoridade administrativa da organização.
