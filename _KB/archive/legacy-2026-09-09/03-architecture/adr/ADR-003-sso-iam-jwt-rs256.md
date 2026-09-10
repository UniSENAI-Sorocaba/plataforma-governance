# ADR-003 — Estratégia de Autenticação Centralizada com JWT RS256 e OAuth2

## Status
Accepted

## Context
A plataforma possui múltiplos perfis de usuários (Alunos, Docentes, Coordenação, CPA, Administradores) e diversas aplicações web (Portal Público, Painel Admin, APIs). É fundamental garantir autenticação sem estado (*stateless*), segura contra adulterações e com controle de acesso granular (RBAC).

## Decision
Construir um motor proprietário de SSO/IAM baseado nos padrões **OAuth2 e OpenID Connect (OIDC)** com emissão de **Access Tokens JWT assinados assimetricamente com algoritmo RS256** (RSA de 2048 bits) e **Refresh Tokens criptográficos opacos** trafegados exclusivamente em cookies seguros `HttpOnly; Secure; SameSite=Strict`. As chaves privadas RSA residem com segurança no AWS Secrets Manager.

## Alternatives Considered
1. **JWT Simétrico (HS256):** Rejeitado porque exige o compartilhamento da mesma chave secreta em todos os validadores, aumentando o risco de comprometimento.
2. **Sessões Stateful com Redis:** Rejeitado pelo custo adicional de manter um cluster AWS ElastiCache e menor facilidade de escala horizontal.
3. **Solução Externa (Auth0 / AWS Cognito):** Rejeitado para fins de aprendizado acadêmico, controle total de regras institucionais e custo recorrente.

## Consequences
* **Positivas:**
  * Validação de token extremamente rápida e sem consulta a banco nas rotas de leitura.
  * Assinatura assimétrica robusta: apenas o módulo `auth` assina; os demais módulos apenas verificam com a chave pública.
  * Alta proteção contra ataques XSS e CSRF.
* **Negativas:**
  * Exige rotina de rotação de chaves e gerenciamento cuidadoso do tempo de expiração curto (15 min).

## Related Documents
- [Arquitetura de Segurança](../security-architecture.md)
- [Autenticação e Sessões](../../05-security/authentication.md)
- [Matriz de Permissões RBAC](../../05-security/iam-rbac.md)
