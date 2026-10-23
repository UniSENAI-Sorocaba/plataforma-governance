---
id: SPEC-PI-001
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-PI-001]
requirements: [REQ-PI-001]
affected_systems: [backend, frontend, database]
legacy_aliases: [US05]
---
# Propostas e equipes

## Objetivo
Captar propostas de PI/Extensão e formar equipes. Esta especificação permanece Draft; as regras candidatas abaixo ainda exigem decisão em PG-008.

## Alinhamento pendente
O card/base atual menciona convite; o caderno propõe que o estudante solicite participação em uma janela e o docente aceite ou negue, sem convite individual. Produto/coordenação acadêmica e docentes devem decidir:
- Jornada oficial e estados: convite, solicitação, aprovação/negação, desistência e remoção.
- Elegibilidade, janela, vagas, notificações e motivo obrigatório na remoção pelo docente.
- Regras na troca de semestre e conta/aluno vinculado a mais de uma turma.
- Limite de no máximo um PI e uma Extensão por estudante; como tratar projeto/atividade classificado em ambos e solicitações concorrentes.
- Categorias PI/Extensão: não inferir que participação contada em ambas aprova um tipo `HYBRID`.

## Trabalho dependente da decisão
Após aprovação, Backend/DB implementam estados, vínculos, limites consistentes e autorização; Frontend implementa a jornada escolhida; QA testa transições, negativas, desistência, concorrência e limite por categoria. Critérios e regra aprovada devem ser registrados antes de retirar Draft.

## Rastreabilidade
PG-007/PG-008; REQ-PI-001; EPIC-PI-001. Mapa cruzado: [KB de reconciliação](../product/functional-rules-reconciliation.md).