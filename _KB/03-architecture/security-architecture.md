---
title: "Arquitetura de Segurança da Informação"
domain: "architecture"
status: "accepted"
owner: "Luciano Jr"
last_updated: "2026-08-27"
---

# 🔒 Arquitetura de Segurança da Informação

A segurança da plataforma é projetada sob o princípio de **Defesa em Profundidade** (*Defense-in-Depth*) e **Privilégio Mínimo** (*Least Privilege*).

---

## 1. Camadas de Segurança da Plataforma

```mermaid
graph TD
    subgraph Camada_Borda [1. Camada de Borda & Rede]
        CF[CloudFront HTTPS / TLS 1.3]
        WAF[AWS WAF - Rate Limit / SQLi / XSS]
        ALB[Application Load Balancer Privado]
    end

    subgraph Camada_Aplicacao [2. Camada de Aplicação & Identidade]
        JWT_Guard[NestJS AuthGuard - Validação RS256]
        RBAC_Guard[NestJS RolesGuard - RBAC / Permissions]
        Zod_Pipe[ValidationPipe - Zod / Sanitização de Input]
    end

    subgraph Camada_Dados [3. Camada de Dados & Criptografia]
        RDS_Enc[(PostgreSQL com Criptografia em Repouso KMS)]
        S3_Enc[(Amazon S3 Server-Side Encryption AES-256)]
        Secrets_Mgr[AWS Secrets Manager - Chaves RSA e Senhas]
    end

    CF --> WAF --> ALB --> JWT_Guard --> RBAC_Guard --> Zod_Pipe
    Zod_Pipe --> RDS_Enc & S3_Enc
    JWT_Guard -.->|Busca Chave Pública| Secrets_Mgr
```

---

## 2. Padrão de Autenticação e Emissão de Tokens

* **Algoritmo de Assinatura:** **RS256** (RSA Signature with SHA-256, chave de 2048 bits). O backend assina o token com a chave privada obtida no Secrets Manager; qualquer serviço pode validar a autenticidade usando a chave pública.
* **Access Token:** Validade curta de **15 minutos**, trafegado via cabeçalho `Authorization: Bearer <token>`.
* **Refresh Token:** String criptográfica opaca de 64 bytes (`crypto.randomBytes(64).toString('hex')`), armazenada exclusivamente em cookie com flags:
  `HttpOnly; Secure; SameSite=Strict; Path=/api/v1/auth/refresh`.

---

## 3. Fluxo de Autorização RBAC

```mermaid
sequenceDiagram
    autonumber
    actor User as Usuário
    participant Front as Frontend
    participant ALB as Application Load Balancer
    participant Guard as Auth & RBAC Guard (NestJS)
    participant Controller as Business Controller
    participant DB as PostgreSQL (Schema de Negócio)

    User->>Front: Dispara ação (ex: Lançar Nota PI)
    Front->>ALB: POST /api/v1/academic/evaluations (Header: Bearer JWT)
    ALB->>Guard: Encaminha requisição
    Guard->>Guard: Valida assinatura do JWT (Chave Pública RSA)
    alt JWT Expirado ou Inválido
        Guard-->>Front: 401 Unauthorized
    else JWT Válido
        Guard->>Guard: Verifica Permissões: Roles ['PROFESSOR'], Scopes ['eval:write']
        alt Permissão Insuficiente
            Guard-->>Front: 403 Forbidden
        else Permissão Concedida
            Guard->>Controller: Executa método com UserContext injetado
            Controller->>DB: Transação SQL (Schema academic_pi)
            DB-->>Controller: Commit realizado
            Controller-->>Front: 201 Created + JSON de resposta
            Front-->>User: Atualiza interface com feedback de sucesso
        end
    end
```

---

## 4. Documentos Relacionados
* [ADR-003 — Autenticação Centralizada com JWT RS256](adr/ADR-003-sso-iam-jwt-rs256.md)
* [Visão Geral de Segurança](../05-security/overview.md)
* [Matriz de Permissões RBAC](../05-security/iam-rbac.md)
* [Threat Model](../05-security/threat-model.md)
