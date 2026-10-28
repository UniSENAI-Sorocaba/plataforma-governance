---
id: SPEC-AUTH-002
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-AUTH-001]
requirements: [REQ-AUTH-002]
must_haves: [MH-SEC-004]
affected_systems: [backend, frontend, database]
legacy_aliases: [US02]
---
# Sessão, renovação e logout

## Objetivo
Definir a duração e o ciclo de vida da sessão local de uma conta autenticada. O caderno é oficial para login local e reset manual, mas não detalha tokens ou sessão.

## Regras oficiais aplicáveis
- Não há provedor externo de identidade; o acesso usa CPF e senha local.
- Docente ou coordenação pode redefinir senha de outra pessoa; ela cria nova senha na próxima entrada.
- Mudança de senha pode ser feita depois do primeiro acesso.

## Detalhes ainda não definidos
Duração de sessão, mecanismo de refresh/logout, expiração por inatividade, concorrência entre sessões/dispositivos e efeito do reset sobre sessões ativas. ADR-003 e CONTRACT-AUTH-001 devem ser revistos para retirar o fluxo incompatível com a autenticação local; seus valores técnicos antigos não são regra de negócio aprovada por esta SPEC.

## Critérios de aceite que a especificação deve completar
Definir e testar criação e encerramento de sessão, expiração, reset obrigatório, logout e comportamento de sessões existentes após reset. Credenciais, tokens e segredos nunca aparecem em logs ou respostas.

## Trabalho das equipes
Backend/DB implementam o mecanismo de sessão decidido; Frontend integra login, troca de senha e logout; QA valida estados e falhas depois que o ciclo de vida for especificado.

## Rastreabilidade
EPIC-AUTH-001; REQ-AUTH-002; PG-006; SPEC-AUTH-001; [regras oficiais](../product/official-validation-decisions.md).
