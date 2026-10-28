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

## Regras oficiais
- Docente responsável define quantidade de horas atribuída ao projeto e somente ele valida as horas.
- Aluno pode enviar ou corrigir informações durante o período do projeto; após o encerramento dos prazos, não pode enviar nem alterar.
- Etapas têm prazos definidos e não prorrogáveis; envios atrasados não são aceitos.
- Docente responsável pode alterar nota ou horas e ajustar prazo, conforme necessário.
- Não guardar histórico de valores anteriores de horas.

## Conflito interno no caderno
Q61 declara que os prazos de cada etapa não são prorrogáveis; Q62 autoriza o docente a ajustar o prazo. Ambas as respostas são oficiais, mas não indicam precedência ou condições. Manter este detalhe pendente de esclarecimento do PO; não escolher uma interpretação por inferência.

## Detalhes ainda não definidos
Unidade/limites de horas, evidências aceitas, motivo de recusa, reenvio após recusa antes do prazo, totalização, horário-limite e condições para ajuste excepcional.

## Trabalho das equipes
Backend/DB implementam submissão, validação, cálculo e estados sem histórico anterior; Frontend apresenta status e prazo; QA testa período, recusa/correção, valores e ausência de alteração após fechamento, respeitando resolução do conflito de prazo.

## Rastreabilidade
EPIC-EXT-001; REQ-EXT-002; PG-009/PG-010; SPEC-AUTH-004; [regras oficiais](../product/official-validation-decisions.md).
