---
title: "Estratégia Geral de CI/CD (Integração e Entrega Contínua)"
domain: "devops"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# 🚀 Estratégia Geral de CI/CD

A estratégia de automação garante que todo código seja validado por testes de unidade, integração, segurança estática e qualidade antes de ser implantado de forma automatizada e segura na AWS.

---

## 1. Visão Geral das Esteiras de CI/CD

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

## 2. Responsabilidade Transversal de CI/CD
* **Owner Técnico Geral:** **Luciano Jr** (Definição dos quality gates, bloqueios de pipeline, políticas de build e aprovações de release).
* **Execução Técnica:** **Fazano** e time de Cloud/DevOps (Vinicius Pereira, Felipe Nunes).
* **QA Lead:** **Nicolle** (Integração dos testes automatizados e suítes E2E no pipeline).

---

## 3. Documentos Relacionados
* [Workflows do GitHub Actions](github-actions.md)
* [Estratégia de Deploy](deployment.md)
* [Procedimento de Rollback](rollback.md)
