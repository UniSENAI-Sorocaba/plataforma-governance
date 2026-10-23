---
id: SPEC-EXT-002
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-EXT-001]
requirements: [REQ-EXT-002]
affected_systems: [backend, frontend, database]
legacy_aliases: [US10]
---
# Atividades e horas

## Objetivo
Submeter evidências, deferir/indeferir com motivo e consolidar horas. Esta SPEC permanece Draft até aprovação das regras de prazo e validação.

## Alinhamento pendente
PO/coordenação de Extensão e docentes responsáveis devem decidir:
- Unidade, limites mínimos/máximos e cálculo do total.
- Evidências aceitas, tamanho/formato de arquivo, prazo de envio e processo de correção/reenvio.
- Quem valida, corrige, recusa, finaliza ou reabre horas; o caderno cita o docente responsável como validador, mas não fecha todas as permissões.
- Se qualquer docente pode avaliar atividades de Extensão.
- Contradição de prazo: fases não prorrogáveis versus docente poder alterar prazo; aprovar autoridade, fuso, registro da alteração e submissão no limite.
- Histórico de horas/notas, em conflito com a sugestão do caderno de não manter histórico e com controles de auditoria vigentes.

## Trabalho dependente da decisão
Após aprovação, Backend/DB implementam registros, cálculo, transições e trilha necessária; Frontend implementa submissão e acompanhamento; Cloud aplica política aprovada a evidências; QA testa limites, cálculo, prazo, recusa, correção e autorização.

## Rastreabilidade
PG-010; REQ-EXT-002; EPIC-EXT-001; SPEC-AUTH-004; INF-005/010/011. Mapa cruzado: [KB de reconciliação](../product/functional-rules-reconciliation.md).