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

## Regras de edital e inscrição — MVP T14
- Edital é entidade própria, distinta de aviso, e pode ter vínculo opcional com um projeto de Extensão.
- Coordenação cria, edita, publica e encerra editais; não há edição por aluno.
- Aluno ativo e com vínculo institucional ativo é elegível; não há filtro adicional de curso, série, desempenho ou turma.
- Não há limite de vagas nem fila de espera.
- A janela é `starts_at <= now < ends_at`, armazenada em UTC e avaliada pelo servidor com relógio injetável; a apresentação usa `America/Sao_Paulo`.
- Cada aluno possui no máximo uma inscrição por edital. Os estados são `SUBMITTED` e `WITHDRAWN`.
- Desistência só é aceita durante a janela e não permite reenvio no mesmo edital.
- Não há aprovação manual nem envio de e-mail; API e interface exibem o resultado.
- Inscrição duplicada retorna `409 Conflict` e não cria nova linha.

Detalhes fora do escopo de T14: relação com atividades/horas, notificações por e-mail, limite de horas e regras de submissão de atividades, que pertencem a T15.

## Trabalho das equipes
Backend/DB implementam avisos e inscrições sem tratar entidades como sinônimas; Frontend apresenta público, janela e status; QA valida papéis, fuso, abertura/fechamento e duplicidade conforme regras que vierem a ser completadas.

## Rastreabilidade
EPIC-EXT-001; REQ-EXT-001; PG-009/PG-010; SPEC-PI-001; [regras oficiais](../product/official-validation-decisions.md).
