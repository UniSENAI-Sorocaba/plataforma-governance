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
Manter sessões institucionais renováveis e revogáveis, com rotação de refresh token, logout centralizado e detecção de reutilização. Esta especificação permanece Draft; os critérios abaixo são propostas para revisão em PG-006.

## Regras de segurança
- Access token JWT RS256 com expiração de 15 minutos; refresh token opaco em cookie `HttpOnly; Secure; SameSite=Strict`, conforme ADR-003.
- Tokens e credenciais não podem aparecer em logs (MH-SEC-004).
- O armazenamento e a revogação server-side devem permitir reconhecer o estado da sessão e tentativas de reutilização, sem armazenar o refresh token em texto puro.

## Critérios de aceite propostos
- **AC-AUTH-002-01 — Renovação:** Dada uma sessão ativa e um refresh token válido, quando a renovação for solicitada, então o token anterior deixa de ser aceito e um novo refresh token é emitido.
- **AC-AUTH-002-02 — Token inválido:** Dado um refresh token expirado, revogado ou desconhecido, quando for usado, então a renovação é recusada e nenhum novo token é emitido.
- **AC-AUTH-002-03 — Reutilização:** Dado um refresh token já rotacionado, quando ele for apresentado novamente, então o evento é detectado, a renovação é recusada e a sessão/família de tokens afetada é revogada conforme a política aprovada.
- **AC-AUTH-002-04 — Logout:** Dada uma sessão autenticada, quando o usuário fizer logout, então o refresh token é invalidado server-side e removido do cliente; uma tentativa posterior de renovação falha.
- **AC-AUTH-002-05 — Expiração:** Quando o access token atingir 15 minutos de validade, então ele deixa de ser aceito; uma renovação requer sessão e refresh token válidos.

## Alinhamento pendente (propostas do caderno não aprovadas)
- O caderno sugere reset manual; decidir se o fluxo vigente de recuperação por token permanece ou muda. Se houver reset manual, aprovar verificação, autoridade, expiração, troca obrigatória e efeito sobre sessões existentes.
- Confirmar duração absoluta/inatividade do refresh token, alcance de logout/revogação, escopo de revogação por reutilização, concorrência entre renovações e política de múltiplas abas/dispositivos.
- Aprovar expiração e revogação imediata, cookie e proteção CSRF/origin para clientes previstos.
- Produto e Segurança aprovam política; Backend/arquitetura definem compatibilidade técnica sem escolher regra de negócio.

## Trabalho dependente da decisão
Backend/DB implementam sessão, rotação, revogação e estado conforme política; Frontend integra login/logout/renovação; QA testa expiração, reutilização, logout, concorrência e falhas. Eventos devem seguir SPEC-AUTH-004.

## Dependências e rastreabilidade
REQ-AUTH-002; MH-SEC-004; ADR-003; SPEC-AUTH-004; PG-006. Critérios e políticas de sessão precisam de revisão do PO, Backend e Segurança antes de mudar o status.
