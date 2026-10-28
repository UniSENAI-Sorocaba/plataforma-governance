---
id: SPEC-EXT-001
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-EXT-001]
requirements: [REQ-EXT-001]
affected_systems: [backend, frontend, database]
legacy_aliases: [US09]
---
# Avisos, editais e inscrições

## Regras oficiais
- Docentes e coordenação podem publicar avisos, gerais ou destinados a um projeto específico. Aviso não é automaticamente edital.
- Coordenação define datas dos períodos de inscrição; elas podem ser alteradas. Fuso UTC-3 (Brasília).
- Aluno solicita participação durante o período; docente aprova ou nega.
- Depois de o aluno ser aprovado no projeto, somente docente pode alterar sua inscrição/participação.
- Os projetos podem ser publicados no site público por opção do docente responsável.

## Detalhes ainda não definidos
Se edital é entidade própria e sua relação com aviso, projeto e atividade; elegibilidade, vagas, inscrição duplicada, cancelamento, prazos no instante-limite, notificações e quem altera o período. O conflito de prorrogação de etapas de extensão está referenciado em SPEC-EXT-002.

## Trabalho das equipes
Backend/DB implementam avisos e inscrições sem tratar entidades como sinônimas; Frontend apresenta público, janela e status; QA valida papéis, fuso, abertura/fechamento e duplicidade conforme regras que vierem a ser completadas.

## Rastreabilidade
EPIC-EXT-001; REQ-EXT-001; PG-009/PG-010; SPEC-PI-001; [regras oficiais](../product/official-validation-decisions.md).
