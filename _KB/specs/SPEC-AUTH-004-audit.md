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

## Decisão oficial
O Caderno de Validações determina que não haverá registros de auditoria. Também não se mantém histórico dos valores anteriores de notas e horas. Requisitos anteriores da KB que obrigam trilha de auditoria de negócio conflitam com esta decisão e precisam ser reconciliados.

## Limite
Esta decisão não autoriza expor senhas, tokens ou segredos. Logs operacionais/técnicos necessários à execução devem ser minimizados e sanitizados; não devem funcionar como trilha persistente de ações de negócio. A política para métricas e logs técnicos precisa ser compatibilizada com segurança sem reintroduzir auditoria funcional.

## Critérios de aceite
- Não criar persistência de eventos de auditoria de negócio para os fluxos cobertos pelo caderno.
- Alterações de nota e horas não guardam valores anteriores.
- Senhas, tokens e segredos não aparecem em logs, erros ou métricas.

## Trabalho das equipes
PO/Governança reconciliam Must Haves, ADRs e cards que exigem auditoria de negócio. Backend/DB retiram apenas a trilha incompatível depois da reconciliação; QA verifica ausência de histórico de negócio e ausência de vazamento de credenciais.

## Cenários de aceite verificáveis
- **AC-AUTH-004-01 — Sem auditoria de negócio:** após criar/editar proposta, aprovar/remover participante, alterar nota ou horas, não é criado registro persistente de auditoria/histórico de valores anteriores.
- **AC-AUTH-004-02 — Logs técnicos sanitizados:** em login inválido, reset e falha de autorização, logs técnicos necessários não contêm senha, token, CPF completo nem conteúdo sensível do pedido.
- **AC-AUTH-004-03 — Sem confusão de propósito:** métricas/logs operacionais não podem ser consultados como trilha de auditoria de negócio nem manter payload funcional para reconstruir valores anteriores.
- Revisar MH-SEC-004 e contratos antes da implementação para que a remoção de auditoria de negócio não remova controles de proteção de credenciais. Não criar persistência substituta com outro nome.

## Rastreabilidade
EPIC-AUTH-001; REQ-AUTH-004; PG-006; SPEC-PI-003; SPEC-EXT-002; [regras oficiais](../product/official-validation-decisions.md). Esta SPEC fica Draft enquanto referências incompatíveis não forem reconciliadas.
