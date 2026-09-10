---
title: "Visão Geral da Arquitetura do Sistema"
domain: "architecture"
status: "accepted"
owner: "Luciano Jr / Marco"
last_updated: "2026-08-27"
---

# 🏗️ Visão Geral da Arquitetura do Sistema

## 1. Padrão Arquitetural Escolhido: Monólito Modular (Modular Monolith)

A plataforma adota o padrão **Modular Monolith** orientado a domínios (DDD), com foco absoluto na entrega dos módulos do **Escopo Obrigatório — Dezembro (MVP)**.

```
                                  COMPARAÇÃO ARQUITETURAL
+----------------------------+-----------------------------+-------------------------------+
| CRITÉRIO                   | MONÓLITO MODULAR (ESCOLHIDO)| MICROSSERVIÇOS DISTRIBUÍDOS   |
+----------------------------+-----------------------------+-------------------------------+
| Complexidade de Deploy     | BAIXA (1 contêiner App)     | ALTA (8+ contêineres/repos)   |
| Transações entre Domínios  | ACID nativo no PostgreSQL   | Eventual/Saga (alto risco)    |
| Custo de Infraestrutura    | BAIXO ($60-$100/mês Fargate)| ALTO ($350+/mês instâncias/ALB|
| Curva de Aprendizado Time  | BAIXA (Interfaces TS locais)| ALTA (gRPC, Filas, Network)   |
| Viabilidade até Dezembro   | ALTA (95% confiança)        | CRÍTICA (< 40% confiança)     |
+----------------------------+-----------------------------+-------------------------------+
```

### Justificativa Técnica:
Para um time de 25 desenvolvedores entregando um ecossistema acadêmico integrado no prazo improrrogável de início de dezembro, microsserviços distribuídos puros introduziriam latência de rede, overhead de serialização, transações distribuídas (Saga/2PC) e custos inviáveis de infraestrutura na AWS. O Monólito Modular provê isolamento rigoroso de código com execução em processo único de altíssimo desempenho.

---

## 2. Visão Geral dos Componentes da Plataforma (Escopo Dezembro)

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
            subgraph Modular_Monolith[Backend Modular Monolith - Escopo Dezembro]
                API_GW[Internal Router / Middleware]
                ModAuth[Module 1: SSO / IAM Central]
                ModAcademic[Module 2: Projetos Integradores & Extensão]
                ModPortal[Module 3: Portal Público & Prestação Social]
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
    API_GW --> ModPortal
    
    ModAuth & ModAcademic & ModPortal -->|Schemas auth, academic_pi, extension| RDS
    ModAcademic -->|Signed URLs / Uploads| S3Storage
```

---

## 3. Delimitação de Fases de Arquitetura

1. **Escopo Obrigatório — Dezembro (MVP do Semestre Atual):**
   * `auth`: SSO / IAM Central (OAuth2, JWT RS256, RBAC de 5 perfis, auditoria).
   * `academic_pi_extension`: Captação de projetos (inc. híbridos), equipes, bancas examinadoras, avaliação docente por rubricas, consolidação de notas e apuração automatizada de horas com certificação digital.
   * `public_portal`: Vitrine pública de ações, divulgação do impacto social, módulo de prestação de contas, busca e validação de certificados.
2. **Backlog / Fase 2 (Próximo Semestre):**
   * Expansão dos módulos e schemas de Gestão Patrimonial (`assets`), Carreiras (`careers`), Iniciação Científica (`science`) e CPA/Ouvidoria (`institutional`).

---

## 4. Documentos Relacionados
* [Contexto do Sistema](system-context.md)
* [Arquitetura de Aplicação](application-architecture.md)
* [Arquitetura de Dados](data-architecture.md)
* [Delimitação do MVP](../01-product/mvp.md)
