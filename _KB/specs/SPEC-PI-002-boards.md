---
id: SPEC-PI-002
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-PI-001]
requirements: [REQ-PI-002]
affected_systems: [backend, frontend, database]
legacy_aliases: [US06]
---
# Bancas e avaliadores

## Objetivo
Vincular avaliadores e, conforme a regra aprovada, organizar avaliação de PI. A fonte legada prevê banca/agendamento, enquanto o caderno propõe avaliação sem banca ou agenda. Esta SPEC permanece Draft e não decide esse conflito.

## Alinhamento pendente
PO/coordenação acadêmica e docentes representantes precisam decidir:
- Se haverá banca, agendamento de sala/link ou somente avaliações individuais.
- Quem pode ser avaliador, quantos avaliadores são exigidos e como são atribuídos.
- Estados da avaliação, prazos, ausência/recusa de avaliador, conflito de interesse e reabertura.
- Se a regra muda entre PI e Extensão e como se integra à SPEC-PI-003 (notas).

## Trabalho dependente da decisão
Após aprovação, Backend/DB implementam atribuições, estados e restrições; Frontend apresenta agenda ou fluxo de avaliação escolhido; QA testa conflitos, permissões, estados e falhas. Não criar tabelas/endpoints de banca antes da decisão.

## Rastreabilidade
PG-008; REQ-PI-002; EPIC-PI-001. Mapa cruzado: [KB de reconciliação](../product/functional-rules-reconciliation.md).