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
# Login institucional

## Objetivo
Autenticar usuários institucionais e iniciar uma sessão de acordo com ADR-003 e a política de segurança. Esta especificação permanece Draft; os critérios abaixo são propostas para revisão em PG-006.

## Escopo
- Autenticação institucional com OIDC e emissão própria de access token JWT RS256 (RSA 2048 bits).
- Emissão de refresh token opaco em cookie `HttpOnly; Secure; SameSite=Strict`.
- A chave privada de assinatura permanece no AWS Secrets Manager. O access token tem expiração curta de 15 minutos, conforme ADR-003.
- Senhas nunca são armazenadas em texto puro. Se houver autenticação local por senha, aplicar Argon2id conforme POL-SEC-001.

## Critérios de aceite propostos
- **AC-AUTH-001-01 — Login válido:** Dado um usuário institucional ativo e uma prova de identidade válida aceita pela configuração institucional, quando concluir o login, então o sistema cria uma sessão e emite access token e refresh token conforme ADR-003 e o contrato de autenticação publicado.
- **AC-AUTH-001-02 — Identidade inválida:** Dada uma prova ausente, inválida, expirada ou rejeitada pelo provedor configurado, quando ocorrer o login, então o acesso é negado e nenhum token ou sessão autenticada é emitido.
- **AC-AUTH-001-03 — Proteção de credenciais:** Quando login for processado ou falhar, então credenciais, tokens e segredos não aparecem em logs, conforme MH-SEC-004.
- **AC-AUTH-001-04 — Chave de assinatura:** Quando um access token for emitido, então ele é assinado com a chave privada protegida no Secrets Manager e validável com a chave pública correspondente.

## Decisões pendentes para aprovação
1. Fonte institucional de identidade e fluxo OIDC (provedor, endpoints, atributos e ambientes).
2. Como contas são provisionadas, desativadas e vinculadas a pessoas; política para usuário sem vínculo.
3. Respostas de erro, limitação de tentativas e proteção contra enumeração de contas.
4. Claims obrigatórias, issuer, audience, identificador de usuário e política de rotação/distribuição da chave pública.
5. Publicar o contrato `CONTRACT-AUTH-001` referenciado neste documento. Ele não foi encontrado em `_KB/contracts/`; a aprovação deste SPEC depende de resolver essa referência.

## Dependências e rastreabilidade
REQ-AUTH-001; MH-SEC-001 e MH-SEC-004; ADR-003; POL-SEC-001; PG-006. Os critérios são propostas e exigem revisão do PO e dos revisores indicados antes de mudar o status.
