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
- O Caderno menciona projeto contínuo ou com data de encerramento, mas esta SPEC não define um campo, contrato ou comportamento técnico para essa informação. Não criar nem inferir campo, estado ou data de continuidade/encerramento; qualquer dado existente dessa natureza não deve ser alterado automaticamente. Participantes podem mudar a cada semestre.
- No cadastro, docente escolhe rascunho ou publicado. Rascunho corresponde a `PROPOSED` e publicado corresponde a `APPROVED` no campo único `status` do projeto; não há um campo/boolean separado de publicação. `PROPOSED` não aparece para visitantes anônimos e pode ser consultado por aluno autenticado; `APPROVED` pode ser retornado pelo catálogo público.
- Todo projeto tem pelo menos um docente responsável.
- Não há convites individuais: durante período de inscrição, aluno solicita participação; docente aprova ou nega.
- Docente pode remover participante e registra justificativa.
- Cada aluno participa de no máximo um projeto de PI e um de Extensão por vez. Projeto que conta para ambos ocupa ambos os limites.
- Somente docente pode reabrir ou arquivar projeto.

## Refinamento de Produto para esta revisão

- Neste fluxo, o papel/perfil chamado Professor está incluído em Docente; não tratar Professor como papel distinto.
- Criar e editar dados de projeto é ação de Docente. Aluno não cria nem edita o projeto: o fluxo previsto para ele é solicitar participação e atuar como participante. Esta restrição não impede solicitações de participação nem entregas permitidas ao aluno.
- Qualquer Docente pode editar os campos permitidos, sem exigir vínculo prévio ou escopo de responsável no projeto. A lista de campos editáveis ainda não está definida.
- Docente pode alterar explicitamente o `status` entre `PROPOSED` (rascunho) e `APPROVED` (publicado); a visibilidade pública acompanha o valor atual do mesmo campo. Status não muda como efeito implícito de outra edição.
- Docente pode alterar explicitamente a atribuição de responsável pelo projeto, preservando ao menos um Docente responsável. Se a função de líder estiver representada como responsável, a atribuição também pode ser trocada. A lista geral de campos editáveis e as regras específicas de substituição ainda precisam ser documentadas.
- Continuidade/data final: o Caderno menciona a distinção, mas não há campo nem funcionamento especificado nesta entrega. Não criar, alterar ou inferir essa informação.

## Critérios de aceite — BE-007: propostas e ciclo de vida
- **AC-PI-001-01 — Criação:** usuário com papel Docente (inclui Professor) cria proposta válida; aluno não pode criar nem editar dados do projeto. A proposta equivalente já existente não causa rejeição automática e o sistema não tenta deduzir equivalência.
- **AC-PI-001-02 — Status inicial e publicação:** o cadastro persiste um único campo `status`: `PROPOSED` para rascunho ou `APPROVED` para publicado. Não existe boolean/campo separado de publicação. Com `PROPOSED`, visitante anônimo não obtém o projeto e aluno autenticado pode consultá-lo; com `APPROVED`, o catálogo público pode retorná-lo, respeitando os campos públicos definidos.
- **AC-PI-001-03 — Responsável:** não é possível concluir o cadastro sem pelo menos um Docente responsável. Toda edição ou substituição explícita de responsáveis mantém pelo menos um Docente responsável; falha de validação não deixa atualização parcial.
- **AC-PI-001-04 — Continuidade/data final:** o Caderno menciona projeto contínuo ou com data de encerramento, mas esta SPEC não define campo nem comportamento. Não criar ou derivar campo/data por inferência, nem alterar automaticamente qualquer informação existente sobre isso. O contrato de dados e o comportamento ficam pendentes de definição.
- **AC-PI-001-05 — Edição de projeto:** qualquer usuário com papel Docente (inclui Professor) pode editar campos permitidos, sem exigir vínculo/escopo prévio no projeto. Aluno não cria nem edita dados do projeto porque seu fluxo é solicitar participação e atuar como participante. A lista de campos permitidos ainda não está definida e precisa de decisão antes de ser congelada no contrato.
- **AC-PI-001-06 — Transições de status:** Docente pode mudar explicitamente o status entre `PROPOSED` e `APPROVED`; a API persiste a transição no mesmo campo `status`, e a visibilidade pública acompanha o novo status. Aluno e usuário sem papel Docente não podem executar a transição. Docente pode reabrir ou arquivar projetos, mas nomes dos estados, condições e efeitos dessas transições adicionais — inclusive sobre pedidos pendentes — ainda não estão definidos.
- **AC-PI-001-07 — Autorização e leitura:** aluno não pode alterar dados do projeto; Docente pode editar os campos permitidos sem vínculo prévio ao projeto. Leitura de dados privados continua sujeita às regras de visibilidade por papel. Resposta de negação não revela título, membros ou outros dados protegidos.
- **AC-PI-001-08 — Privacidade na publicação:** somente campos públicos aprovados podem ser retornados pelo catálogo. Dados privados de participantes, horas e avaliações individuais não são expostos por o projeto estar em `APPROVED`.
- **Evidência de implementação:** cenários de integração para criação/edição por Docente (inclui Professor), negação a aluno, status `PROPOSED`/`APPROVED` e suas transições explícitas, troca de responsável, equivalente sem bloqueio, responsável ausente e leitura anônima; registrar request/response e estado persistido sem incluir credenciais.

## Critérios de aceite — BE-008: participação
- **AC-PI-001-09 — Solicitação:** aluno solicita participação por iniciativa própria somente dentro do período de inscrição vigente. Não existe endpoint ou ação de convite individual.
- **AC-PI-001-10 — Decisão docente:** docente autorizado no projeto aprova ou nega a solicitação. Uma decisão por ator sem autorização é negada no servidor; a decisão não pode alterar participantes de outro projeto.
- **AC-PI-001-11 — Limites simultâneos:** ao aprovar aluno em PI, rejeitar a aprovação se ele já estiver vinculado a outro PI; aplicar a mesma regra separadamente para Extensão. Para projeto classificado simultaneamente como PI e Extensão, validar e consumir ambos os limites na mesma operação.
- **AC-PI-001-12 — Concorrência:** duas aprovações concorrentes que fariam o aluno exceder um limite não podem ambas persistir. A implementação deve proteger a invariável no banco/transação, não apenas na validação de tela.
- **AC-PI-001-13 — Remoção:** docente responsável remove participante com justificativa não vazia; aluno, usuário sem papel Docente ou justificativa ausente não concluem a remoção. Após remoção, o vínculo deixa de contar no limite de participação.
- **AC-PI-001-14 — Sem convite:** aceite/recusa de convite não faz parte do fluxo. Dados ou rotas legadas de convite não devem ser reutilizados para representar a solicitação do aluno sem reconciliação do contrato.
- **AC-PI-001-15 — Sem exposição indevida:** aluno só consulta os detalhes de projeto permitidos ao seu papel; a listagem pública não inclui solicitação pendente, justificativa de remoção ou lista privada de membros.

## Lacunas que bloqueiam fechamento dos critérios
Ainda não estão definidos: campos obrigatórios da proposta; lista de campos editáveis; condições específicas para trocar responsável/líder e tratamento de múltiplos responsáveis; campos e semântica técnica de continuidade/data final; demais estados e transições além de `PROPOSED`↔`APPROVED`; janela de inscrição (responsável, fronteira de horário e timezone); elegibilidade, vagas, duplicidade de solicitações, desistência/reenvio, notificações, mudança semestral dos participantes e efeito de reabrir/arquivar sobre pedidos. Não inferir regras para preencher essas lacunas. Backend/DB/QA podem avançar nos critérios já definidos e deixar os campos dependentes de decisão identificados.

## Transições explicitamente conhecidas
| Estado/condição conhecida | Ação | Ator definido | Resultado conhecido |
| --- | --- | --- | --- |
| Cadastro de proposta | definir status inicial `PROPOSED` ou `APPROVED` | Docente (inclui Professor) | `PROPOSED`: aluno autenticado consulta e anônimo não; `APPROVED`: pode aparecer no catálogo público |
| Projeto em `PROPOSED` ou `APPROVED` | mudar explicitamente o status entre esses valores | qualquer usuário com papel Docente | API atualiza o mesmo campo `status`; visibilidade pública acompanha o valor corrente |
| Período de inscrição vigente | solicitar participação | aluno | solicitação aguarda decisão docente; estado formal ainda não nomeado |
| Solicitação existente | aprovar ou negar | docente autorizado | participação aprovada ou solicitação negada |
| Participante vinculado | remover com justificativa | docente | vínculo removido |
| Projeto existente | reabrir ou arquivar | docente | ação permitida; origem/destino formal e efeitos pendentes |

Esta tabela registra somente comportamentos respondidos; não é autorização para implementar estados ou transições implícitos. “Submeter” na descrição da BE-007 precisa ser alinhado com a decisão de cadastro em rascunho/publicado antes de ser tratado como uma etapa separada.

## Trabalho por equipe
- Backend: autorização server-side por papel Docente (inclui Professor), edição explícita de status/responsáveis e negação de criação/edição por aluno; validar critérios e proteger limites simultâneos por operação transacional.
- Database: persistir um único campo `status` (`PROPOSED`/`APPROVED` para os significados definidos), responsabilidades e vínculos/decisões; não criar campo nem derivação de continuidade/data final enquanto o contrato estiver pendente; garantir invariantes concorrentes sem adicionar estados não aprovados.
- Frontend: apresentar rascunho/publicado a partir do valor de `status`, permitir as transições e trocas explícitas previstas para Docente e não oferecer criação/edição de projeto ao aluno; manter solicitação/decisão sem convite individual.
- QA: cobrir criação/edição e transições por Docente, negação para aluno, troca explícita de responsável, leitura pública por status e duas aprovações concorrentes de participação.

## Rastreabilidade
EPIC-PI-001; REQ-PI-001; PG-007/PG-008; [BE-007](https://github.com/UniSENAI-Sorocaba/plataforma-backend/issues/7); [BE-008](https://github.com/UniSENAI-Sorocaba/plataforma-backend/issues/8); [regras oficiais](../product/official-validation-decisions.md).
