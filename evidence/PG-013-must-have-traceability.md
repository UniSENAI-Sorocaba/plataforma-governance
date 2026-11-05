---
id: PG-013-EVIDENCE
status: Ready for review
work_id: PG-013
owner: Luciano Menezes Júnior
reviewers: [Gustavo Henrique Gouveia Gomes, Technical Leads]
reviewed_at: 2026-11-04
---

# PG-013 — Rastreabilidade dos Must Haves

## Regra

Todo Must Have aprovado precisa possuir owner, origem normativa e método de validação. Os documentos `business.md` e `data.md` permanecem candidatos (`Draft`) e não são promovidos por esta task.

## Matriz de rastreabilidade

| ID | Owner | Origem | Validação |
| --- | --- | --- | --- |
| MH-ARCH-001 | Technical Leads | `must-haves/architecture.md` / ADR-006 | revisão de arquitetura e teste de fronteira frontend/API |
| MH-ARCH-002 | Technical Leads | `must-haves/architecture.md` / ADR-006 | revisão de PR: mudança relevante exige ADR |
| MH-ARCH-003 | Technical Leads | `must-haves/architecture.md` / ADR-009 | validação de contrato e compatibilidade CI |
| MH-ARCH-004 | Technical Leads | `must-haves/architecture.md` / ADR-010 | build/SSR smoke do frontend |
| MH-GOV-001 | Product Governance | `must-haves/governance.md` / POL-GOV-007 | PR de governança e CODEOWNERS |
| MH-GOV-002 | Product Governance | `must-haves/governance.md` / ADR-008 | CI confere tag e SHA da baseline |
| MH-GOV-003 | Product Governance | `must-haves/governance.md` / POL-GOV-002 | auditoria rejeita arquivo gerado como autoridade |
| MH-GOV-004 | Product Governance | `must-haves/governance.md` / POL-GOV-002 | consulta ao GitHub Project para estado operacional |
| MH-INFRA-001 | Cloud & DevOps | `must-haves/infrastructure.md` / ADR-012 | secret scan, state scan e revisão de outputs |
| MH-INFRA-002 | Cloud & DevOps | `must-haves/infrastructure.md` / ADR-011 | terraform fmt/validate/scan |
| MH-INFRA-003 | Cloud & DevOps | `must-haves/infrastructure.md` / ADR-011 | inspeção de contas, redes e smoke de isolamento |
| MH-QA-001 | Quality, Tests & Security | `must-haves/quality.md` / POL-INFRA-001 | PR com required check falhando não pode fazer merge |
| MH-QA-002 | Quality, Tests & Security | `must-haves/quality.md` / POL-GOV-006 | matriz de evidência vinculada ao critério |
| MH-QA-003 | Quality, Tests & Security | `must-haves/quality.md` / spec-compliance | teste de compliance com FAIL/WARN |
| MH-SEC-001 | Quality, Tests & Security | `must-haves/security.md` / POL-SEC-001 | scan de armazenamento e testes de autenticação |
| MH-SEC-002 | Quality, Tests & Security | `must-haves/security.md` / SPEC-AUTH-003 | API allow/deny por papel e rota |
| MH-SEC-003 | Quality, Tests & Security | `must-haves/security.md` / POL-SEC-001 | secret scan e revisão Git |
| MH-SEC-004 | Quality, Tests & Security | `must-haves/security.md` / POL-SEC-001 | testes de logs sem credenciais |

## Verificações

- [x] Must Haves aprovados possuem owner documental.
- [x] Cada item possui origem identificável.
- [x] Cada item possui método de validação verificável.
- [x] Must Haves candidatos de Business/Data continuam explicitamente fora da promoção.
- [ ] Revisão formal de Gustavo e líderes técnicos registrada no PR.

## Rastreabilidade

- [Must Haves de arquitetura](../_KB/must-haves/architecture.md)
- [Must Haves de governança](../_KB/must-haves/governance.md)
- [Must Haves de infraestrutura](../_KB/must-haves/infrastructure.md)
- [Must Haves de qualidade](../_KB/must-haves/quality.md)
- [Must Haves de segurança](../_KB/must-haves/security.md)
- [Issue PG-013](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/13)
