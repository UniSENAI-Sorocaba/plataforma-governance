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

## Alinhamento pendente (propostas do caderno não aprovadas)
- Decidir login institucional OIDC/OAuth2 versus login local por CPF e senha; não alterar ADR-003 nem o contrato sem aprovação formal.
- Definir fonte de identidade, identificador, vínculo com pessoa/turmas, estados de conta e provisionamento por CSV (campos, duplicatas, reimportação, erros e desativação).
- Definir primeiro acesso e recuperação. Se reset manual for aprovado: verificação de identidade, papel autorizado, expiração, troca obrigatória e revogação de sessões.
- Resolver o contrato CONTRACT-AUTH-001 referenciado e ausente em _KB/contracts/.
- PO/coordenação decide regras de produto; Segurança e responsável técnico revisam riscos/compatibilidade.

## Trabalho dependente da decisão
Backend/DB implementam autenticação, provisionamento e restrições aprovadas; Frontend implementa telas/estados; QA valida login válido/inválido, conta não provisionada, erros e recuperação. Critérios de aceite devem cobrir somente a alternativa aprovada.

## Dependências e rastreabilidade
REQ-AUTH-001; MH-SEC-001 e MH-SEC-004; ADR-003; POL-SEC-001; PG-006. Os critérios são propostas e exigem revisão do PO e dos revisores indicados antes de mudar o status.
