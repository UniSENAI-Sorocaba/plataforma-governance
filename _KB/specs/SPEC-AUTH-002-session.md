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

## Decisões pendentes para aprovação
1. Vida útil do refresh token, expiração por inatividade e expiração absoluta.
2. Escopo de revogação quando houver reutilização (token, sessão, família ou todas as sessões do usuário).
3. Semântica de logout: apenas dispositivo atual ou todas as sessões; efeito imediato sobre access tokens já emitidos.
4. Concorrência entre renovações, tolerância de relógio e comportamento para múltiplas abas/dispositivos.
5. Path/domain do cookie e proteções CSRF/origin compatíveis com os clientes previstos.
6. Eventos e evidências para tentativas recusadas, alinhados a SPEC-AUTH-004.

## Dependências e rastreabilidade
REQ-AUTH-002; MH-SEC-004; ADR-003; SPEC-AUTH-004; PG-006. Critérios e políticas de sessão precisam de revisão do PO, Backend e Segurança antes de mudar o status.
