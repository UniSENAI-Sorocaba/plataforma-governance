---
id: SPEC-AUTH-003
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-AUTH-001]
requirements: [REQ-AUTH-003]
must_haves: [MH-SEC-002]
affected_systems: [backend, frontend, database]
legacy_aliases: [US03]
---
# Autorização RBAC

## Objetivo
Aplicar no servidor as permissões oficiais de coordenação, docentes e alunos, respeitando o cadastro único por CPF.

## Regras oficiais
- Coordenação cria e gerencia usuários e permissões, importa cadastros e pode inativar turma ou aluno.
- O papel Docente inclui o perfil denominado Professor; não são papéis distintos neste fluxo. Qualquer Docente pode criar e editar campos permitidos dos projetos, inclusive alterar explicitamente status e responsáveis, conforme SPEC-PI-001. Aprovação/remoção de participantes e validação de horas seguem as regras de responsabilidade descritas nesta SPEC.
- Alunos registram e editam atividades do projeto enquanto elas não tiverem sido avaliadas ou validadas.
- Uma pessoa que exerce mais de uma função acumula as permissões dessas funções no mesmo cadastro.
- Todo projeto exige pelo menos um docente responsável; este aprova/remover participantes e registra justificativa na remoção.
- O mesmo docente responsável valida horas; outros docentes podem adicionar avaliação de Extensão.
- Um único fluxo de login apresenta as funcionalidades previstas para o semestre; a interface não substitui autorização da API.

## Critérios de aceite que a especificação deve completar
Autorizar as ações acima no servidor; negar por padrão ações não definidas; não exigir vínculo de responsável para edição dos campos permitidos por Docente; manter as ações de participação/horas restritas conforme os critérios seguintes; registrar justificativa para remoção; permitir acumulação de funções sem duplicar cadastro.

## Detalhes ainda não definidos
Matriz completa de ações e escopos por papel, quem atribui/remove cada função, comportamento quando há múltiplos docentes responsáveis, e papéis técnicos distintos que não aparecem no caderno. Registrar esses detalhes sem contradizer as permissões oficiais.

## Trabalho das equipes
Backend implementa autorização; DB persiste funções e vínculos; Frontend reflete permissões; QA cobre matriz allow/deny, escopo de projeto e combinação de papéis.

## Matriz de cenários de autorização
- **AC-AUTH-003-01 — Acumular funções:** atribuir duas funções à mesma pessoa mantém um cadastro por CPF; após autenticar, a API permite cada ação autorizada a pelo menos uma das funções sem criar conta duplicada.
- **AC-AUTH-003-02 — Coordenação:** usuário sem permissão de coordenação não importa CSV, mantém cadastro nem inativa aluno/turma.
- **AC-AUTH-003-03 — Projeto e participação:** qualquer pessoa com papel Docente (inclui Professor) pode criar/editar campos permitidos do projeto e alterar explicitamente status ou responsáveis; aluno não cria nem edita o projeto. Aprovar/remover participante e validar horas seguem a responsabilidade definida na SPEC-PI-001 e no Caderno. A forma de representar líder e múltiplos responsáveis permanece pendente, sem bloquear a possibilidade de troca explícita.
- **AC-AUTH-003-04 — Justificativa:** remoção sem justificativa é rejeitada sem retirar o vínculo; remoção válida conserva a justificativa associada à operação conforme a regra de produto. Não criar histórico de auditoria, vedado pelo caderno.
- **AC-AUTH-003-05 — Acesso de aluno:** aluno pode enviar/corrigir informações dentro do período aplicável; operações administrativas de aprovação, remoção, validação de horas ou arquivamento são negadas.
- **AC-AUTH-003-06 — Negação no servidor:** chamar diretamente a API sem a permissão necessária produz negação mesmo que o cliente mostre/force a ação; resposta não expõe dados fora do escopo.
- Para ações e escopos que o caderno não atribui, manter negação por padrão e abrir decisão de produto antes de conceder permissões.

## Rastreabilidade
EPIC-AUTH-001; REQ-AUTH-003; PG-006; SPEC-AUTH-001; [regras oficiais](../product/official-validation-decisions.md).
