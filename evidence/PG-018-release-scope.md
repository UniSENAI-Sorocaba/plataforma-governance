---
id: PG-018-EVIDENCE
status: Draft; blocked by PG-017
work_id: PG-018
owner: Luciano Menezes Júnior
reviewer: Fellipe Raszejas
reviewed_at: 2026-11-04
---

# PG-018 — Escopo da release e exceções

## Escopo proposto para v1.0.0

Entram na release os três domínios definidos no MVP: autenticação/identidade, Projetos Integradores e Extensão, e Portal Público. A release também exige os gates transversais de qualidade, segurança, infraestrutura e operação definidos no S6.

Ficam fora da v1.0.0 e permanecem em Future/2027.1: gestão patrimonial, carreira/oportunidades, iniciação científica e CPA/ouvidoria.

## Critérios para aprovação

- Cada Must Have/P0 incluído deve apontar SPEC, Issue, PR integrado e evidência de aceite.
- Falha P0, finding crítico sem aceite formal ou artefato essencial ausente impede o go.
- Exceções precisam de justificativa, risco, owner, prazo, mitigação e aprovação.
- Go/no-go deve reunir parecer de Quality, prontidão de Cloud & DevOps e aceite funcional do PO.
- Smoke e rollback precisam ser executados ou ter limitação explicitamente registrada.

## Exceções atualmente registradas

Nenhuma exceção de release foi aprovada por esta task. O documento é preparatório e não autoriza deploy.

## Bloqueio

PG-017 (homologação v1.0) ainda é dependência. Portanto, este artefato pode ser revisado e refinado, mas PG-018 não deve ser marcada como concluída nem usada como autorização de produção antes de a homologação e as evidências S6 existirem.

## Rastreabilidade

- [MVP baseline](../_KB/product/mvp-baseline.md)
- [Pacote S6](../_KB/specs/sprints/S6-release-homologacao-go-no-go.md)
- [Definition of Done](../_KB/governance/definition-of-done.md)
- [Issue PG-018](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/18)
