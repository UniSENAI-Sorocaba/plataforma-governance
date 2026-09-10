# Backlog — Banco de Dados

| ID | P/S | SP | Responsável | Revisor | Entrega / aceite | Dep. |
| --- | --- | ---: | --- | --- | --- | --- |
| DB-001 | P0/S0 | 5 | Isabelly Caroline Martins Pardim | Henrique Marchetti Coutinho | Convenções de schema, IDs, auditoria e migrations aprovadas | ADR-011 |
| DB-002 | P0/S0 | 5 | Henrique Marchetti | Isabelly | CI sobe banco limpo, aplica migrations e valida compatibilidade | DB-001 |
| DB-003 | P0/S0 | 3 | Diogo Lopes Antunes | Henrique | Seeds sintéticos são determinísticos e sem dados pessoais | DB-002 |
| DB-004 | P0/S1 | 8 | Henrique Marchetti | Isabelly | Identidade/usuário/vínculo têm constraints e migration testada | DB-001 |
| DB-005 | P0/S1 | 5 | Enzo Gabriel Tomas de Souza | Henrique | Sessões/tokens têm hash, expiração, revogação e índices | DB-004 |
| DB-006 | P0/S1 | 5 | Nicolas Pureza da Silva | Henrique | Papéis/permissões evitam duplicidade e suportam escopo | DB-004 |
| DB-007 | P1/S2 | 8 | Vinícius Côrte da Silva | Isabelly | Auditoria é append-only e aplica retenção | DB-004 |
| DB-008 | P0/S1 | 8 | Diogo Lopes | Henrique | Propostas, equipes e convites preservam integridade | DB-004 |
| DB-009 | P0/S2 | 5 | Enzo Gabriel | Henrique | Bancas/avaliadores impedem conflitos e órfãos | DB-008 |
| DB-010 | P0/S2 | 8 | Nicolas Pureza | Isabelly | Rubricas/notas usam precisão e constraints aprovadas | DB-009 |
| DB-011 | P0/S2 | 5 | Vinícius Côrte | Henrique | Artefatos registram hash, owner e lifecycle | DB-008 |
| DB-012 | P0/S1 | 8 | Diogo Lopes | Isabelly | Editais/inscrições possuem janela, status e unicidade | DB-004 |
| DB-013 | P0/S2 | 8 | Enzo Gabriel | Isabelly | Atividades/horas guardam decisão, motivo e trilha | DB-012 |
| DB-014 | P0/S3 | 5 | Nicolas Pureza | Henrique | Índices do catálogo comprovados por EXPLAIN | DB-008, DB-012 |
| DB-015 | P1/S4 | 5 | Vinícius Côrte | Isabelly | Impacto social versiona publicação e origem | DB-008 |
| DB-016 | P0/S1–4 | 3 | Henrique | Isabelly | Fixtures acompanham schemas e CI detecta drift | DB-004–015 |
| DB-017 | P0/S5 | 5 | Diogo Lopes | Henrique | Slow queries têm evidência e correção | QA-024 |
| DB-018 | P0/S5 | 8 | Isabelly | Felipe Marques | Backup restaurado em staging com RPO/RTO medidos | INF-016 |
| DB-019 | P0/S5 | 5 | Enzo Gabriel | Henrique | Pool suporta k6 sem exaurir conexões | QA-024 |
| DB-020 | P1/S6 | 3 | Nicolas Pureza | Isabelly | Dicionário e runbook de migration atualizados | DB-018–019 |
| DB-021 | P2/Future | 13 | Vinícius Côrte | Isabelly | Modelo Draft dos domínios US14–18 | PG-019 |
