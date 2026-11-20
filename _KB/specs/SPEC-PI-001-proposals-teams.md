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
Cadastrar projetos de PI/Extensão e gerenciar participação de alunos conforme as decisões oficiais do caderno.

## Regras oficiais
- Docentes cadastram propostas e verificam manualmente se já existe proposta equivalente; o sistema não bloqueia duplicidades.
- Um projeto pode ser contínuo ou ter data de encerramento. Participantes podem mudar a cada semestre.
- No cadastro, docente escolhe rascunho ou publicado. Rascunho fica disponível a alunos autenticados; publicado aparece no site público.
- Todo projeto tem pelo menos um docente responsável.
- Não há convites individuais: durante período de inscrição, aluno solicita participação; docente aprova ou nega.
- Docente pode remover participante e registra justificativa.
- Cada aluno participa de no máximo um projeto de PI e um de Extensão por vez. Projeto que conta para ambos ocupa ambos os limites.
- Somente docente pode reabrir ou arquivar projeto.

## Critérios de aceite — BE-007: propostas e ciclo de vida
- **AC-PI-001-01 — Criação:** docente autorizado cria proposta válida e recebe recurso persistido como rascunho quando escolhe rascunho; uma proposta equivalente já existente não causa rejeição automática. O sistema não deve tentar deduzir equivalência.
- **AC-PI-001-02 — Publicação inicial:** quando o docente escolhe publicação no cadastro, a API persiste a opção e o catálogo público pode retornar o projeto; se escolhe rascunho, o acesso anônimo não retorna o conteúdo e aluno autenticado pode consultá-lo.
- **AC-PI-001-03 — Responsável:** não é possível concluir o cadastro sem pelo menos um docente responsável. Tentativa inválida não deixa projeto parcialmente criado.
- **AC-PI-001-04 — Tipo e duração:** persistir a classificação PI, Extensão ou ambas e a escolha contínuo/data final exatamente como informadas. Não inferir data final para projeto contínuo nem converter um tipo no outro.
- **AC-PI-001-05 — Edição:** somente docente responsável pode editar. Após publicação, apenas título, resumo, descrição, data final futura e autorização de fotos são editáveis; a publicação não muda implicitamente. Classificação, continuidade e responsáveis só mudam antes da publicação e antes de solicitação pendente ou vínculo aprovado.
- **AC-PI-001-06 — Reabrir/arquivar:** somente docente responsável executa `ACTIVE → ARCHIVED` ou `ARCHIVED → ACTIVE`. Arquivar bloqueia novas solicitações, edição e publicação pública, mantendo vínculos consultáveis; reabrir não republica automaticamente. Não existe exclusão física.
- **AC-PI-001-07 — Isolamento:** consulta/alteração fora do escopo autorizado não retorna dados do projeto; a resposta de negação não inclui título, membros ou outros dados protegidos.
- **AC-PI-001-08 — Publicação:** a opção de publicação controlada pelo docente determina a inclusão no catálogo público. Dados privados de participantes, horas e avaliações individuais não são expostos como consequência da publicação.
- **Evidência de implementação:** cenários de integração para rascunho/publicado, equivalente sem bloqueio, responsável ausente, permissões e leitura anônima; registrar request/response e estado persistido sem incluir credenciais.

## Critérios de aceite — BE-008: participação
- **AC-PI-001-09 — Solicitação:** aluno solicita participação por iniciativa própria somente dentro do período de inscrição vigente. Não existe endpoint ou ação de convite individual.
- **AC-PI-001-10 — Decisão docente:** docente autorizado no projeto aprova ou nega a solicitação. Uma decisão por ator sem autorização é negada no servidor; a decisão não pode alterar participantes de outro projeto.
- **AC-PI-001-11 — Limites simultâneos:** ao aprovar aluno em PI, rejeitar a aprovação se ele já estiver vinculado a outro PI; aplicar a mesma regra separadamente para Extensão. Para projeto classificado simultaneamente como PI e Extensão, validar e consumir ambos os limites na mesma operação.
- **AC-PI-001-12 — Concorrência:** duas aprovações concorrentes que fariam o aluno exceder um limite não podem ambas persistir. A implementação deve proteger a invariável no banco/transação, não apenas na validação de tela.
- **AC-PI-001-13 — Remoção:** docente autorizado remove participante com justificativa não vazia; aluno, docente fora do escopo ou justificativa ausente não concluem a remoção. Após remoção, o vínculo deixa de contar no limite de participação.
- **AC-PI-001-14 — Sem convite:** aceite/recusa de convite não faz parte do fluxo. Dados ou rotas legadas de convite não devem ser reutilizados para representar a solicitação do aluno sem reconciliação do contrato.
- **AC-PI-001-15 — Sem exposição indevida:** aluno só consulta os detalhes de projeto permitidos ao seu papel; a listagem pública não inclui solicitação pendente, justificativa de remoção ou lista privada de membros.

## Decisões de fechamento do MVP
- Campos: `title` (5–200), `summary` (20–500), `description` (50–5000),
  `classification` (`PI`, `EXTENSION`, `BOTH`), `continuity`
  (`CONTINUOUS`, `FIXED_END`), `end_date` quando aplicável e ao menos um
  responsável.
- Rascunho exige título, classificação, duração e responsável. Publicação
  exige também resumo, descrição e data final quando a duração não for
  contínua. Não existe `SUBMITTED`.
- Estados formais: publicação `DRAFT/PUBLISHED`; ciclo `ACTIVE/ARCHIVED`;
  solicitação `PENDING/APPROVED/DENIED/WITHDRAWN`; vínculo
  `ACTIVE/REMOVED`.
- Qualquer aluno autenticado, ativo e institucionalmente vinculado é elegível;
  o MVP não aplica curso, série ou desempenho. Não há limite de vagas.
- `PENDING` pode ser retirada enquanto o período estiver aberto. `DENIED` e
  `WITHDRAWN` só podem gerar novo pedido em período posterior. Vínculo
  removido também só pode ser solicitado novamente em período posterior.
- Um ou mais responsáveis são permitidos. Todos possuem escopo de gestão; o
  último responsável não pode ser removido.
- Coordenação é dona dos períodos de inscrição e pode ajustá-los ou reabri-los.
  `start_at` é inclusivo, `end_at` exclusivo; persistência em UTC e regra no
  fuso `America/Sao_Paulo`. Não há retroatividade.
- Arquivar bloqueia novas solicitações, edições e publicação pública; mantém
  vínculos consultáveis. Reabrir não republica automaticamente.
- O MVP não envia e-mail nem oferece bypass administrativo. Conflitos de
  concorrência ou duplicidade retornam `409 Conflict` sem alteração parcial.
- Não há deduplicação automática de propostas equivalentes.

## Transições explicitamente conhecidas
| Estado/condição conhecida | Ação | Ator definido | Resultado conhecido |
| --- | --- | --- | --- |
| Cadastro de proposta | escolher rascunho ou publicado | docente responsável | `DRAFT` ou `PUBLISHED` |
| Projeto ativo | arquivar | docente responsável | `ACTIVE → ARCHIVED`; bloqueia novas solicitações, edição e publicação |
| Projeto arquivado | reabrir | docente responsável | `ARCHIVED → ACTIVE`; não republica automaticamente |
| Período vigente | solicitar participação | aluno elegível | solicitação `PENDING` |
| Solicitação pendente | aprovar ou negar | docente responsável | `APPROVED` ou `DENIED` |
| Solicitação pendente | desistir | aluno solicitante | `WITHDRAWN` |
| Participante ativo | remover com justificativa | docente responsável | vínculo `REMOVED` |

Esta tabela fecha os estados e transições do MVP. “Submeter” permanece
reservado para atividades/entregáveis, não para uma etapa adicional de
proposta.

## Trabalho por equipe
- Backend: autorização server-side, validação dos critérios acima e operação transacional para limites simultâneos.
- Database: persistir tipo(s), continuidade/data final, publicação, responsabilidade e vínculo/decisão; garantir invariantes concorrentes sem criar estados de negócio não aprovados.
- Frontend: distinguir rascunho/publicado e solicitação/decisão; não oferecer convite individual.
- QA: usar cenários de sucesso e negação para cada critério acima, incluindo duas aprovações concorrentes e isolamento entre projetos.

## Rastreabilidade
EPIC-PI-001; REQ-PI-001; PG-007/PG-008; [BE-007](https://github.com/UniSENAI-Sorocaba/plataforma-backend/issues/7); [BE-008](https://github.com/UniSENAI-Sorocaba/plataforma-backend/issues/8); [regras oficiais](../product/official-validation-decisions.md).
