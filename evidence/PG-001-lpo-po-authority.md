---
id: PG-001-EVIDENCE
status: Owner approved; reviewer pending
work_id: PG-001
owner: Luciano Menezes Júnior
reviewer: Fellipe Raszejas
approved_at: 2026-11-04
approved_by: Luciano Menezes Júnior
---

# PG-001 — Matriz de autoridade LPO/PO

## Objetivo

Formalizar quem decide sobre visão, prioridade, escopo, backlog, aceite funcional e impasses de produto.

## Matriz aprovada para revisão

| Decisão ou atividade | LPO — Luciano | PO — Fellipe | Líder técnico | Evidência esperada |
| --- | --- | --- | --- | --- |
| Visão e prioridade global | Accountable / desempate | Responsible | Consultado | decisão registrada no Project ou Issue |
| Refinamento e ordenação do backlog | Consultado | Accountable / Responsible | Consultado | backlog e critérios refinados |
| Mudança de requisito, escopo ou Must Have | Aprova em conflito ou impacto global | Propõe e conduz | Consultado | decisão vinculada a SPEC, Issue ou ADR |
| Aceite funcional | Accountable em impasse | Accountable / Responsible | Consultado | aceite funcional registrado |
| Arquitetura e contrato técnico | Informado ou consultado quando houver impacto de produto | Consultado | Accountable / Responsible | ADR, contrato, PR e validação |
| Release | Consultado; decide conflito de produto | Accountable pelo aceite de produto | Consultado | go/no-go e escopo de release |

## Regra de desempate

O PO conduz o trabalho cotidiano e o aceite funcional. O LPO não substitui o PO; ele atua quando há conflito de visão, escopo, prioridade global ou regra de governança. O desempate deve ser registrado na Issue/Project e referenciar o requisito, SPEC, Must Have ou ADR afetado.

## Rastreabilidade

- [Ownership](../_KB/governance/ownership.md)
- [Responsabilidades e RACI](../_KB/governance/responsibilities.md)
- [Squads oficiais](../_KB/governance/squads.md)
- [Composição de Produto](../new_teams.md)
- [Issue PG-001](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/1)

## Critérios de aceite

- [x] Matriz publicada com autoridade LPO/PO explícita.
- [x] Regra de desempate documentada.
- [x] Responsabilidades técnicas separadas da autoridade de produto.
- [x] Aprovação do owner registrada na Issue PG-001.
- [ ] Evidência de aprovação anexada ou vinculada pelo revisor.

## Limitação

Este artefato implementa a documentação e a rastreabilidade local. A aprovação final continua sendo uma decisão humana do revisor indicado e deve ocorrer no GitHub.
