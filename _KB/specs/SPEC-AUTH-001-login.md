---
id: SPEC-AUTH-001
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-AUTH-001]
requirements: [REQ-AUTH-001]
must_haves: [MH-SEC-001, MH-SEC-004]
contracts: [CONTRACT-AUTH-001]
affected_systems: [backend, frontend, database]
legacy_aliases: [US01]
---
# Login, cadastro e primeiro acesso

## Objetivo
Autenticar as contas cadastradas para a Plataforma Digital. Regras funcionais abaixo transcrevem decisões oficiais do Caderno de Validações.

## Regras oficiais
- Não haverá provedor externo de identidade. O aluno entra usando CPF e cria sua própria senha no primeiro acesso; pode alterá-la depois.
- Cadastro inicial por importação CSV feita por usuários com permissão de coordenação; não haverá autocadastro público.
- Um CPF corresponde a um cadastro, que pode receber permissões de mais de uma função.
- Coordenação pode inativar aluno ou turma. A conta permanece ativa se o aluno também estiver ativo em outra turma.
- O fluxo de login é único; após autenticar, a interface mostra as funcionalidades previstas para o semestre.
- Docentes e coordenação podem redefinir a senha de outro usuário; na próxima entrada, esse usuário precisa criar uma senha nova.

## Critérios de aceite que a especificação deve completar
- AC-AUTH-001-01: CPF provisionado e senha válida autenticam a pessoa.
- AC-AUTH-001-02: usuário não provisionado ou conta inativa não entra.
- AC-AUTH-001-03: não há autocadastro público; provisionamento inicial ocorre pela função de coordenação via CSV.
- AC-AUTH-001-04: senha redefinida por docente/coordenação exige nova senha no próximo acesso.
- AC-AUTH-001-05: credenciais e segredos nunca aparecem em logs ou erros.

## Detalhes ainda não definidos
Formato, colunas, validação, duplicatas, erros parciais e reimportação do CSV; normalização/mascaramento/unicidade do CPF; verificação de identidade para reset; efeitos do reset em sessões existentes; estados de bloqueio/expiração. Não inferir OIDC, OAuth2 ou recuperação por token como regras do produto.

## Trabalho das equipes
Backend/DB implementam identidade local, provisionamento e estado de conta; Frontend implementa login, primeiro acesso e troca de senha; QA cobre sucesso, falhas, importação e autorização.

## Rastreabilidade
EPIC-AUTH-001; REQ-AUTH-001; PG-005/PG-006; [regras oficiais](../product/official-validation-decisions.md). Revisar CONTRACT-AUTH-001 e ADRs incompatíveis antes da implementação.
