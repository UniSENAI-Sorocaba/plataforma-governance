---
id: SPEC-PI-003
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-PI-001]
requirements: [REQ-PI-003]
affected_systems: [backend, frontend, database]
legacy_aliases: [US07]
---
# Rubricas e notas

## Objetivo
Lançar avaliações por rubrica e calcular resultado consolidado de forma determinística e auditável. Esta SPEC permanece Draft até aprovação dos critérios acadêmicos.

## Alinhamento pendente
PO/coordenação acadêmica e docentes representantes devem aprovar:
- Escala, precisão, fórmula, pesos e regra de arredondamento.
- Avaliação ausente, rubrica aplicável, responsável por criar/finalizar/reabrir e processo de revisão/contestação.
- Visibilidade da nota para estudante, equipe, docente e público.
- Histórico de alterações: o caderno sugere não mantê-lo; reconciliar com Must Haves de auditoria e política de retenção.
- Se rubricas e critérios são definidos pelo responsável de PI e como são versionados após a avaliação começar.

## Trabalho dependente da decisão
Após aprovação, Backend implementa cálculo reproduzível e permissões; DB armazena critérios/resultados e histórico conforme política; Frontend apresenta lançamento e consulta; QA valida cálculos com exemplos aprovados, limites, arredondamento e histórico. Critérios devem incluir casos positivos e de erro.

## Rastreabilidade
PG-008; REQ-PI-003; EPIC-PI-001; SPEC-PI-002 e SPEC-AUTH-004. Mapa cruzado: [KB de reconciliação](../product/functional-rules-reconciliation.md).