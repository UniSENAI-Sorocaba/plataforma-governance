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

## Regras oficiais
- Nota do PI é ponderada conforme critérios e pesos definidos pelo docente responsável pelo PI.
- O docente responsável pode criar a ficha/rubrica, finalizar, reabrir ou corrigir a avaliação.
- Alunos podem avaliar outros alunos; coordenação atribui avaliador e data.
- Qualquer docente pode adicionar avaliação para projeto de Extensão.
- Nota do projeto pode ser pública; avaliações individuais feitas por docente são visíveis somente aos alunos daquele projeto. Notas individuais não são públicas.
- Não é necessário manter histórico de valores anteriores de notas.

## Critérios de aceite que a especificação deve completar
Cálculo reproduzível com pesos definidos para o PI; acesso restrito às notas individuais; nota pública somente no nível do projeto; finalização, reabertura e correção pelo docente responsável; nenhum histórico de valores anteriores.

## Detalhes ainda não definidos
Escala, precisão, arredondamento, tratamento de critério sem peso, avaliação ausente, acesso a avaliações feitas por alunos, motivo de correção e momento de bloqueio da ficha.

## Trabalho das equipes
Backend implementa cálculo/permissões; DB armazena valores atuais e rubrica sem histórico anterior; Frontend apresenta notas visíveis ao papel; QA verifica cálculo com exemplos aprovados, autorização e visibilidade.

## Rastreabilidade
EPIC-PI-001; REQ-PI-003; PG-008; SPEC-PI-002; SPEC-AUTH-004; [regras oficiais](../product/official-validation-decisions.md).
