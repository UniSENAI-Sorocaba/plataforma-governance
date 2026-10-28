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
Cadastrar projetos de PI/Extensão e gerenciar participação de alunos segundo as decisões oficiais do caderno.

## Regras oficiais
- Docentes cadastram propostas e verificam manualmente se já existe proposta equivalente; o sistema não bloqueia duplicidades.
- Um projeto pode ser contínuo ou ter data de encerramento. Participantes podem mudar a cada semestre.
- No cadastro, docente escolhe rascunho ou publicado. Rascunho fica disponível a alunos autenticados; publicado aparece no site público.
- Todo projeto tem pelo menos um docente responsável.
- Não há convites individuais: durante período de inscrição, aluno solicita participação; docente aprova ou nega.
- Docente pode remover participante e registra justificativa.
- Cada aluno participa de no máximo um projeto de PI e um de Extensão por vez. Projeto que conta para ambos ocupa ambos os limites.
- Somente docente pode reabrir ou arquivar projeto.

## Transições cobertas por esta SPEC
- Proposta criada como rascunho ou publicada pelo docente.
- Publicação torna o projeto visível no site público; rascunho fica restrito a alunos autenticados.
- A participação segue solicitação do aluno e decisão de aprovação/negação do docente durante período de inscrição.
- Docente responsável remove aluno com justificativa; docente pode reabrir ou arquivar projeto.

## Detalhes ainda não definidos
Campos mínimos, ciclo detalhado de edição/submissão, nomes e estados intermediários, quem abre/fecha janela, elegibilidade, vagas, desistência/reenvio, notificações, troca de semestre, coexistência de docentes responsáveis e tratamento transacional de solicitações concorrentes. Não adicionar convite individual.

## Trabalho das equipes
Backend/DB implementam as transições e limites no servidor/banco; Frontend apresenta rascunho/publicação e pedido de participação; QA testa transições válidas/inválidas, papéis, justificativa, visibilidade, limites e concorrência.

## Rastreabilidade
EPIC-PI-001; REQ-PI-001; PG-007/PG-008; BE-007/BE-008; [regras oficiais](../product/official-validation-decisions.md).
