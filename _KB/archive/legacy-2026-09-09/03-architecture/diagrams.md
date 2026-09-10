---
title: "Catálogo Geral de Diagramas do Sistema"
domain: "architecture"
status: "accepted"
owner: "Luciano Jr"
last_updated: "2026-08-27"
---

# 📊 Catálogo Geral de Diagramas do Sistema

Este documento centraliza todos os diagramas Mermaid do sistema, organizados por perspectiva arquitetural.

---

## 1. Diagrama Geral da Arquitetura
```mermaid
graph TD
    ClientBrowser[Navegadores Desktop / Mobile]
    CloudFront[AWS CloudFront CDN]
    S3Static[AWS S3 - Static Assets & SPA]
    ALB[Application Load Balancer]
    WAF[AWS WAF]
    
    subgraph AWS_VPC[AWS VPC - Multi-AZ]
        subgraph Public_Subnet[Public Subnets]
            ALB
        end
        
        subgraph Private_App_Subnet[Private App Subnets]
            ECS[AWS ECS Fargate Cluster]
            subgraph Modular_Monolith[Backend Modular Monolith]
                API_GW[Internal Router / Middleware]
                ModAuth[Module: SSO / IAM]
                ModAcademic[Module: Projetos Integradores]
                ModExtension[Module: Extensão Universitária]
                ModAssets[Module: Gestão Patrimonial]
                ModInst[Module: CPA & Ouvidoria]
            end
        end
        
        subgraph Private_DB_Subnet[Private DB Subnets]
            RDS[(Amazon RDS PostgreSQL 16)]
            S3Storage[AWS S3 Private Storage - Documentos & Certificados]
        end
    end

    ClientBrowser -->|HTTPS| CloudFront
    CloudFront -->|Assets Estáticos| S3Static
    CloudFront -->|API Requests / Dynamic| WAF
    WAF --> ALB
    ALB --> ECS
    ECS --> API_GW
    API_GW --> ModAuth
    API_GW --> ModAcademic
    API_GW --> ModExtension
    API_GW --> ModAssets
    API_GW --> ModInst
    
    ModAuth & ModAcademic & ModExtension & ModAssets & ModInst -->|Schemas Isolados| RDS
    ModAcademic & ModExtension -->|Signed URLs / Uploads| S3Storage
```

---

## 2. Diagrama do Fluxo de Autenticação Central (OAuth2 OIDC com PKCE)
```mermaid
sequenceDiagram
    autonumber
    actor User as Usuário (Aluno/Docente)
    participant Front as Frontend (Next.js)
    participant AuthMod as Módulo SSO/IAM
    participant DB as PostgreSQL (Schema auth)
    participant Storage as Navegador (Memory / HttpOnly Cookie)

    User->>Front: Acessa tela de login e submete credenciais
    Front->>AuthMod: POST /api/v1/auth/login {email, password, client_id}
    AuthMod->>DB: Busca usuário e hash Argon2id
    DB-->>AuthMod: Retorna registro do usuário
    AuthMod->>AuthMod: Valida senha e status da conta
    AuthMod->>AuthMod: Gera AccessToken (JWT RS256) e RefreshToken criptográfico
    AuthMod->>DB: Grava sessão e hash do RefreshToken em auth.sessions
    AuthMod-->>Front: Retorna 200 OK + Payload {user, accessToken, exp} + Set-Cookie (refreshToken)
    Front->>Storage: Armazena accessToken em memória (Zustand/Context)
    Front-->>User: Redireciona para Dashboard do perfil
```

---

## 3. Diagrama do Pipeline de CI/CD (GitHub Actions)
```mermaid
flowchart TD
    subgraph PR_Pipeline[Pipeline de Pull Request]
        A[Git Push / Abrir PR] --> B[Lint & Format Check]
        B --> C[TypeScript Typecheck]
        C --> D[Testes Unitários & Cobertura]
        D --> E[Testes de Integração com Testcontainers]
        E --> F[SonarQube Quality Gate & SAST Trivy]
        F -->|Aprovado| G[Permitido Merge no develop]
        F -->|Reprovado| H[Bloqueia PR]
    end

    subgraph Staging_Pipeline[Deploy Contínuo - Staging]
        G --> I[Merge em develop]
        I --> J[Build Docker Image multi-arch]
        J --> K[Push Image AWS ECR staging]
        K --> L[Terraform Apply / ECS Task Update]
        L --> M[Execução Automática de Migrations]
        M --> N[Healthcheck / Smoke Tests]
    end

    subgraph Prod_Pipeline[Deploy de Produção - Release Tag]
        O[Tag Git vX.Y.Z criada] --> P[Aprovação Manual Tech Lead / PO]
        P --> Q[Deploy ECS Fargate Produção]
        Q --> R[Verificação de Healthcheck]
        R -->|Falha| S[Rollback Automático de Task ECS]
        R -->|Sucesso| T[Release Concluída com Sucesso]
    end
```

---

## 4. Diagrama de Topologia de Infraestrutura AWS
```mermaid
graph TB
    Internet((Internet)) --> IGW[Internet Gateway]
    IGW --> CloudFront[AWS CloudFront CDN]
    CloudFront --> WAF[AWS WAF]
    WAF --> ALB[Application Load Balancer]
    
    subgraph VPC_10_0_0_0_16[VPC 10.0.0.0/16]
        subgraph AZ_A[Availability Zone us-east-1a]
            PubSubA[Public Subnet 10.0.1.0/24 - NAT Gateway A]
            PrivAppA[Private App Subnet 10.0.10.0/24 - ECS Task A]
            PrivDBA[Private DB Subnet 10.0.20.0/24 - RDS Master]
        end
        
        subgraph AZ_B[Availability Zone us-east-1b]
            PubSubB[Public Subnet 10.0.2.0/24]
            PrivAppB[Private App Subnet 10.0.11.0/24 - ECS Task B]
            PrivDBB[Private DB Subnet 10.0.21.0/24 - RDS Standby Multi-AZ]
        end
    end
    
    ALB --> PrivAppA & PrivAppB
    PrivAppA & PrivAppB --> PrivDBA
    PrivAppA & PrivAppB --> Secrets[AWS Secrets Manager]
    PrivAppA & PrivAppB --> S3Priv[AWS S3 Private Documents]
    PrivAppA & PrivAppB --> CWLogs[Amazon CloudWatch Logs & Metrics]
```

---

## 5. Diagrama de Deploy e Rollback de ECS Tasks
```mermaid
stateDiagram-v2
    [*] --> BuildArtifact: GitHub Actions Trigger
    BuildArtifact --> RunMigrations: Executa Migrations (Backward-Compatible)
    RunMigrations --> DeployECS: Inicia Nova Task ECS Fargate (Blue/Green)
    DeployECS --> HealthCheck: ALB dispara /healthz
    
    state HealthCheck {
        [*] --> Verifying
        Verifying --> Success: HTTP 200 em 3 checks consecutivos
        Verifying --> Failure: Timeout ou HTTP 5xx
    }
    
    Success --> SwitchTraffic: Desvia 100% do tráfego para nova Task
    SwitchTraffic --> StopOldTask: Desliga Tasks antigas com grace period
    StopOldTask --> [*]: Deploy Concluído
    
    Failure --> RollbackAlert: Dispara Alerta CloudWatch / Slack
    RollbackAlert --> KeepOldTask: Mantém Task estável rodando
    KeepOldTask --> AbortDeploy: Aborta deploy e notifica equipe
    AbortDeploy --> [*]: Falha Contida
```

---

## 6. Documentos Relacionados
* [Visão Geral da Arquitetura](overview.md)
* [Infraestrutura AWS](../06-infrastructure/aws.md)
* [CI/CD Pipelines](../07-devops/ci-cd.md)
