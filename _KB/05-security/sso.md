---
title: "Arquitetura do Single Sign-On (SSO) Centralizado"
domain: "security"
status: "accepted"
owner: "Luciano Jr"
last_updated: "2026-08-27"
---

# 🌐 Arquitetura do Single Sign-On (SSO) Centralizado

Especificação do motor de Single Sign-On institucional que unifica a experiência de login entre o Portal Público, o Painel Administrativo e futuras integrações.

---

## 1. Fluxo de SSO Baseado em OAuth2 / OIDC com PKCE

```mermaid
sequenceDiagram
    autonumber
    actor User as Usuário
    participant ClientApp as Aplicação Web (Admin / Portal)
    participant SSOServer as SSO Central (auth.universidade.edu.br)
    participant BackendAPI as Backend API de Negócio

    User->>ClientApp: Clica em "Entrar com SSO Institucional"
    ClientApp->>ClientApp: Gera code_verifier e code_challenge (PKCE SHA-256)
    ClientApp->>SSOServer: Redireciona para /oauth/authorize?response_type=code&client_id=...&code_challenge=...
    SSOServer-->>User: Exibe tela única de login e consentimento
    User->>SSOServer: Digita e-mail e senha
    SSOServer->>SSOServer: Valida credenciais e gera authorization_code temporário (TTL 60s)
    SSOServer-->>ClientApp: Redireciona para redirect_uri?code=XYZ123
    ClientApp->>SSOServer: POST /oauth/token {code, code_verifier, client_id}
    SSOServer->>SSOServer: Valida code_verifier contra o hash do code_challenge
    SSOServer-->>ClientApp: Retorna {accessToken (JWT RS256), idToken, refreshToken}
    ClientApp->>BackendAPI: Requisições com Header "Authorization: Bearer <accessToken>"
```

---

## 2. Federação e Expansão Futura (Pós-MVP)
* O SSO está preparado para conectar provedores de identidade externos corporativos (Google Workspace for Education e Microsoft Azure AD / SAML 2.0) a partir da Sprint 5, bastando plugar os adaptadores OIDC no módulo `auth`.

---

## 3. Documentos Relacionados
* [Autenticação e Sessões](authentication.md)
* [Matriz de Permissões RBAC](iam-rbac.md)
* [ADR-003 — Autenticação Centralizada](../03-architecture/adr/ADR-003-sso-iam-jwt-rs256.md)
