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
- **AC-PI-001-05 — Edição:** somente docente com permissão no escopo do projeto pode editar campos permitidos; atualização não altera publicação nem responsáveis implicitamente. A lista de campos editáveis e a regra de reenvio após publicação ainda dependem de decisão (ver lacunas).
- **AC-PI-001-06 — Reabrir/arquivar:** uma ação de reabertura ou arquivamento iniciada por aluno ou usuário sem papel docente é negada no servidor. A ação docente só pode ser persistida quando a transição correspondente estiver definida; estados de origem/destino e efeito sobre pedidos permanecem pendentes, sem inventar estado.
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

## Lacunas que bloqueiam fechamento dos critérios
O caderno não define campos obrigatórios da proposta, nomes formais e estados intermediários, campos editáveis após publicar, janela (quem abre/fecha, fronteira de horário e timezone), elegibilidade, vagas, duplicidade de solicitações, desistência/reenvio, notificações, mudança semestral dos participantes, comportamento de pedidos ao reabrir/arquivar, múltiplos responsáveis nem política de erro para concorrência. Os critérios marcados como condicionais não autorizam criar essas regras. PO deve decidir as lacunas de produto; Backend/DB/QA podem avançar nas invariantes já definidas e registrar contrato técnico para as restantes.

## Transições explicitamente conhecidas
| Estado/condição conhecida | Ação | Ator definido | Resultado conhecido |
| --- | --- | --- | --- |
| Cadastro de proposta | escolher rascunho ou publicado | docente | rascunho visível a alunos autenticados; publicado no site público |
| Período de inscrição vigente | solicitar participação | aluno | solicitação aguarda decisão docente; estado formal ainda não nomeado |
| Solicitação existente | aprovar ou negar | docente autorizado | participação aprovada ou solicitação negada |
| Participante vinculado | remover com justificativa | docente | vínculo removido |
| Projeto existente | reabrir ou arquivar | docente | ação permitida; origem/destino formal e efeitos pendentes |

Esta tabela registra somente comportamentos respondidos; não é autorização para implementar estados ou transições implícitos. “Submeter” na descrição da BE-007 precisa ser alinhado com a decisão de cadastro em rascunho/publicado antes de ser tratado como uma etapa separada.

## Trabalho por equipe
- Backend: autorização server-side, validação dos critérios acima e operação transacional para limites simultâneos.
- Database: persistir tipo(s), continuidade/data final, publicação, responsabilidade e vínculo/decisão; garantir invariantes concorrentes sem criar estados de negócio não aprovados.
- Frontend: distinguir rascunho/publicado e solicitação/decisão; não oferecer convite individual.
- QA: usar cenários de sucesso e negação para cada critério acima, incluindo duas aprovações concorrentes e isolamento entre projetos.

## Rastreabilidade
EPIC-PI-001; REQ-PI-001; PG-007/PG-008; [BE-007](https://github.com/UniSENAI-Sorocaba/plataforma-backend/issues/7); [BE-008](https://github.com/UniSENAI-Sorocaba/plataforma-backend/issues/8); [regras oficiais](../product/official-validation-decisions.md).
