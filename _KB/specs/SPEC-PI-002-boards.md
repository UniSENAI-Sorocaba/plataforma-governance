---
id: SPEC-PI-002
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-PI-001]
requirements: [REQ-PI-002]
affected_systems: [backend, frontend, database]
legacy_aliases: [US06]
---
# Avaliações de projetos

## Regras oficiais
- Não haverá bancas, agendamento de sala ou link.
- O número de avaliações pode variar; o sistema não impõe número fixo.
- Para Extensão, qualquer docente pode adicionar uma avaliação.
- Alunos podem avaliar outros alunos.
- No PI, o docente responsável define critérios e pesos das avaliações dos alunos; coordenação atribui qual aluno avalia cada projeto e em qual data.
- O docente responsável pelo PI finaliza, reabre ou corrige avaliação.

## Detalhes ainda não definidos
Estados e prazos de avaliação, quem seleciona projeto de Extensão, critérios de elegibilidade, ausência ou retirada de avaliador, escala e relação detalhada com notas consolidadas. Não criar entidade/agenda de banca.

## Trabalho das equipes
Backend/DB implementam avaliações individuais e autorização; Frontend apresenta o fluxo sem agenda de banca; QA testa atribuição, permissões, datas e estados após definição dos critérios faltantes.

## Rastreabilidade
EPIC-PI-001; REQ-PI-002; PG-008; SPEC-PI-003; [regras oficiais](../product/official-validation-decisions.md).
