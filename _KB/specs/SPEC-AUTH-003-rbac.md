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
Aplicar autorização por papéis e permissões no servidor a cada operação protegida. Esta especificação permanece Draft; os critérios abaixo são propostas para revisão em PG-006.

## Escopo
Os perfis institucionais identificados em ADR-003 incluem Aluno, Docente, Coordenação, CPA e Administrador. A existência dos perfis não define, por si só, quais ações cada perfil pode executar.

## Critérios de aceite propostos
- **AC-AUTH-003-01 — Verificação server-side:** Dada uma operação protegida, quando a API a processar, então ela valida no servidor a identidade, o papel e a permissão aplicável, conforme MH-SEC-002.
- **AC-AUTH-003-02 — Negação por padrão:** Dada uma operação sem regra explícita de permissão, quando um usuário a solicitar, então o servidor nega o acesso.
- **AC-AUTH-003-03 — Acesso permitido:** Dado um usuário autenticado com a permissão aprovada para a ação e o recurso, quando solicitar essa ação, então o servidor permite apenas o escopo definido na matriz aprovada.
- **AC-AUTH-003-04 — Acesso negado:** Dado um usuário sem a permissão exigida, quando solicitar a ação, então o servidor nega a operação e não altera o recurso.
- **AC-AUTH-003-05 — Interface:** Quando a interface ocultar ou desabilitar ações sem permissão, então a API continua aplicando a mesma autorização independentemente da interface.

## Alinhamento pendente (propostas do caderno não aprovadas)
- Aprovar matriz versionada de papéis × ações × recursos e escopo por turma/projeto/unidade.
- Decidir se múltiplos papéis acumulam permissões, quais papéis podem coexistir e quem pode atribuir/remover cada papel.
- Definir usuário sem papel, permissão desconhecida, mudança de papel em sessão ativa e indisponibilidade da fonte de permissões.
- O conjunto de perfis em ADR-003 não equivale a uma matriz de autorização completa. PO/coordenação aprova regras; Segurança revisa menor privilégio.

## Trabalho dependente da decisão
Backend aplica autorização server-side e negação por padrão; DB guarda papéis/escopos se aprovados; Frontend reflete ações disponíveis sem substituir a API; QA testa matriz positiva e negativa, escopo cruzado e mudanças de papel.

## Dependências e rastreabilidade
REQ-AUTH-003; MH-SEC-002; ADR-003; SPEC-AUTH-001; SPEC-AUTH-004; PG-006. A matriz é bloqueadora para implementação funcional completa e aprovação do SPEC.
