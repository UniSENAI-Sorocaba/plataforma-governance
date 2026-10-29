---
status: Draft
owner: Product Owner
---

# Specifications do produto

| SPEC | Alias | Assunto | Documento | Issue de refinamento | Status |
| --- | --- | --- | --- | --- | --- |
| SPEC-AUTH-001 | US01 | Login e cadastro | [SPEC-AUTH-001-login.md](SPEC-AUTH-001-login.md) | [PG-006](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/6) | Draft |
| SPEC-AUTH-002 | US02 | Sessão, renovação e logout | [SPEC-AUTH-002-session.md](SPEC-AUTH-002-session.md) | [PG-006](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/6) | Draft |
| SPEC-AUTH-003 | US03 | Autorização RBAC | [SPEC-AUTH-003-rbac.md](SPEC-AUTH-003-rbac.md) | [PG-006](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/6) | Draft |
| SPEC-AUTH-004 | US04 | Auditoria | [SPEC-AUTH-004-audit.md](SPEC-AUTH-004-audit.md) | [PG-006](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/6) | Draft |
| SPEC-PI-001 | US05 | Propostas e equipes | [SPEC-PI-001-proposals-teams.md](SPEC-PI-001-proposals-teams.md) | [PG-008](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/8) | Draft |
| SPEC-PI-002 | US06 | Avaliações (sem bancas) | [SPEC-PI-002-boards.md](SPEC-PI-002-boards.md) | [PG-008](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/8) | Draft |
| SPEC-PI-003 | US07 | Rubricas e notas | [SPEC-PI-003-grades.md](SPEC-PI-003-grades.md) | [PG-008](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/8) | Draft |
| SPEC-PI-004 | US08 | Entregáveis | [SPEC-PI-004-deliverables.md](SPEC-PI-004-deliverables.md) | [PG-008](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/8) | Draft |
| SPEC-EXT-001 | US09 | Avisos, editais e inscrições | [SPEC-EXT-001-notices.md](SPEC-EXT-001-notices.md) | [PG-010](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/10) | Draft |
| SPEC-EXT-002 | US10 | Atividades e horas | [SPEC-EXT-002-hours.md](SPEC-EXT-002-hours.md) | [PG-010](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/10) | Draft |
| SPEC-EXT-003 | US11 | Certificados | [SPEC-EXT-003-certificates.md](SPEC-EXT-003-certificates.md) | [PG-010](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/10) | Draft |
| SPEC-PORTAL-001 | US12 | Catálogo público | [SPEC-PORTAL-001-catalog.md](SPEC-PORTAL-001-catalog.md) | [PG-012](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/12) | Draft |
| SPEC-PORTAL-002 | US13 | Impacto comunitário | [SPEC-PORTAL-002-impact.md](SPEC-PORTAL-002-impact.md) | [PG-012](https://github.com/UniSENAI-Sorocaba/plataforma-governance/issues/12) | Draft |

As respostas cobertas pelo [Caderno de Validações](../product/official-validation-decisions.md) são regras oficiais de produto, não propostas. As Specs permanecem em Draft quando ainda faltam critérios verificáveis, estados completos, limites, exceções, revisão técnica ou reconciliação de contratos. Draft não rebaixa a autoridade das respostas registradas.

A [KB de reconciliação](../product/functional-rules-reconciliation.md) liga cada decisão a questões ainda abertas e às entregas das equipes. Cada SPEC deve referenciar as regras oficiais aplicáveis e separar claramente regra decidida de detalhe não respondido.


## Pacotes de especificação por sprint — Draft para validação do PO

Os pacotes abaixo organizam comportamento, critérios e decisões por sprint para revisão de Produto. São documentos transversais de planejamento/aceite: **não substituem** as SPECs canônicas por domínio, não criam regra para lacuna não respondida e não são normativos enquanto estiverem em Draft.

| Sprint | Pacote de revisão | SPECs de domínio relacionadas | Estado |
| --- | --- | --- | --- |
| S3 | [Avaliações, certificados e catálogo](sprints/S3-avaliacoes-certificados-catalogo.md) | PI-002/003, EXT-003, PORTAL-001 | Draft |
| S4 | [Extensão, horas e impacto publicado](sprints/S4-extensao-impacto-publicacao.md) | EXT-001/002, PORTAL-001/002 | Draft |
| S5 | [Confiabilidade, segurança e desempenho](sprints/S5-confiabilidade-seguranca-desempenho.md) | Critérios transversais às SPECs no release | Draft |
| S6 | [Homologação, escopo e go/no-go](sprints/S6-release-homologacao-go-no-go.md) | Critérios de release para SPECs aprovadas | Draft |

Os pacotes S5/S6 são de qualidade operacional e aceite do release, não novos EPICs funcionais. Campos, escalas, prazos, métricas e outras decisões ainda abertas devem ser aprovadas pelo PO antes de entrarem em contratos ou implementação.
