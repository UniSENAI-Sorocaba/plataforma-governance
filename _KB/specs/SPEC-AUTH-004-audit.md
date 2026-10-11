---
id: SPEC-AUTH-004
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-AUTH-001]
requirements: [REQ-AUTH-004]
must_haves: [MH-SEC-004]
affected_systems: [backend, database]
legacy_aliases: [US04]
---
# Auditoria de autenticação e operações críticas

## Objetivo
Registrar acessos e operações críticas com contexto suficiente para investigação, aplicando minimização de dados. Esta especificação permanece Draft; os critérios abaixo são propostas para revisão em PG-006.

## Campos mínimos propostos
Cada evento registrado inclui ator (ou indicação de ator não autenticado), ação, alvo/recurso, instante e identificador de correlação. Campos adicionais só devem ser incluídos quando justificados para investigação e aprovados.

## Critérios de aceite propostos
- **AC-AUTH-004-01 — Eventos críticos:** Quando ocorrer login, logout, renovação/revogação de sessão ou operação crítica definida pelo produto, então o sistema registra um evento de auditoria com os campos mínimos aplicáveis.
- **AC-AUTH-004-02 — Resultado:** O evento registra se a ação foi permitida ou negada, quando esse resultado for necessário para a trilha de auditoria aprovada.
- **AC-AUTH-004-03 — Minimização:** Quando um evento for gravado, então não inclui senha, access token, refresh token, segredo, nem dados pessoais além do mínimo aprovado, conforme MH-SEC-004 e POL-SEC-001.
- **AC-AUTH-004-04 — Correlação:** Dado um identificador de correlação da requisição, quando uma ação gerar auditoria, então o evento preserva esse identificador para relacionar a ação aos logs técnicos sem copiar credenciais ou tokens.
- **AC-AUTH-004-05 — Acesso aos registros:** Quando os eventos forem consultados, então o acesso segue menor privilégio e as consultas são rastreáveis, conforme política a aprovar.

## Decisões pendentes para aprovação
1. Catálogo exato de eventos auditáveis, incluindo tentativas inválidas e falhas de autorização.
2. Esquema/tipos dos campos, origem do instante, sincronização de relógio e tratamento de identificadores externos.
3. Retenção, descarte, exportação e acesso aos registros; papéis autorizados a consultá-los.
4. Comportamento quando o armazenamento de auditoria estiver indisponível (bloquear ação, fila durável ou outro modo).
5. Separação operacional entre trilha de auditoria e logs técnicos, e evidência de integridade dos eventos.

## Dependências e rastreabilidade
REQ-AUTH-004; MH-SEC-004; POL-SEC-001; SPEC-AUTH-001–003; PG-006. Retenção, acesso e comportamento em falha são decisões de produto/segurança e permanecem em aberto até revisão formal.
