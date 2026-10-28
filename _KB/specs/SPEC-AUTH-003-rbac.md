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
- Docentes criam projetos, aprovam ou removem alunos dos projetos e validam horas dos alunos vinculados aos projetos sob sua responsabilidade.
- Alunos registram e editam atividades do projeto enquanto elas não tiverem sido avaliadas ou validadas.
- Uma pessoa que exerce mais de uma função acumula as permissões dessas funções no mesmo cadastro.
- Todo projeto exige pelo menos um docente responsável; este aprova/remover participantes e registra justificativa na remoção.
- O mesmo docente responsável valida horas; outros docentes podem adicionar avaliação de Extensão.
- Um único fluxo de login apresenta as funcionalidades previstas para o semestre; a interface não substitui autorização da API.

## Critérios de aceite que a especificação deve completar
Autorizar as ações acima no servidor; negar por padrão ações não definidas; restringir docentes ao projeto sob sua responsabilidade quando assim definido; registrar justificativa para remoção; permitir acumulação de funções sem duplicar cadastro.

## Detalhes ainda não definidos
Matriz completa de ações e escopos por papel, quem atribui/remove cada função, comportamento quando há múltiplos docentes responsáveis, e papéis técnicos distintos que não aparecem no caderno. Registrar esses detalhes sem contradizer as permissões oficiais.

## Trabalho das equipes
Backend implementa autorização; DB persiste funções e vínculos; Frontend reflete permissões; QA cobre matriz allow/deny, escopo de projeto e combinação de papéis.

## Rastreabilidade
EPIC-AUTH-001; REQ-AUTH-003; PG-006; SPEC-AUTH-001; [regras oficiais](../product/official-validation-decisions.md).
