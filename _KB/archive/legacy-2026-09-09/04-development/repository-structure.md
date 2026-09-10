---
title: "Estrutura do Monorepo e Pacotes"
domain: "development"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# 📦 Estrutura do Monorepo & Pacotes

O repositório unificado organiza todas as aplicações, bibliotecas compartilhadas, configurações de infraestrutura e documentação viva.

```text
plataforma-digital/
├── .github/
│   ├── workflows/
│   │   ├── ci-pr.yml                 # Pipeline de validação de Pull Requests
│   │   ├── cd-staging.yml            # Pipeline de deploy automático para Staging
│   │   └── cd-production.yml         # Pipeline de release para Produção
│   └── pull_request_template.md
├── apps/
│   ├── web-portal/                   # Next.js 14 (App Router) - Vitrine Pública
│   ├── web-admin/                    # Next.js 14 - Painel Administrativo / Acadêmico
│   └── api-server/                   # NestJS - Backend Modular Monolith
│       ├── src/
│       │   ├── modules/
│       │   │   ├── auth/             # SSO, IAM, RBAC, JWT, Sessões
│       │   │   ├── academic-pi/      # Projetos Integradores, Equipes, Bancas, Notas
│       │   │   ├── extension/        # Editais, Horas, Validações, Certificados
│       │   │   ├── assets/           # Patrimônio (Notebooks/QR, Salas) - Pós-MVP
│       │   │   └── institutional/    # CPA, Ouvidoria, Avaliações - Pós-MVP
│       │   ├── shared/               # Middlewares, Guards, Interceptors, Filters
│       │   └── main.ts
│       └── test/
├── packages/
│   ├── ui/                           # Design System (Tailwind, Radix UI / Shadcn)
│   ├── shared-types/                 # Interfaces TS, DTOs e Enums compartilhados
│   ├── crypto-utils/                 # Helpers de hash, criptografia e validação de token
│   └── config/                       # ESLint, Prettier e TSConfigs base
├── infra/
│   ├── docker/
│   │   ├── Dockerfile.api            # Multi-stage build otimizado da API
│   │   ├── Dockerfile.web            # Multi-stage build do Frontend
│   │   └── docker-compose.yml        # Ambiente de desenvolvimento local completo
│   └── terraform/
│       ├── environments/
│       │   ├── staging/              # Configurações de Staging
│       │   └── production/           # Configurações de Produção
│       ├── modules/
│       │   ├── vpc/                  # Redes, Subnets, NAT, IGW, Security Groups
│       │   ├── ecs/                  # Cluster Fargate, Task Definitions, Service
│       │   ├── rds/                  # PostgreSQL 16 Multi-AZ, Subnet Groups
│       │   ├── s3/                   # Buckets de arquivos com criptografia
│       │   └── monitoring/           # CloudWatch Dashboards, Logs e Alarmes
│       └── shared/
├── _KB/                              # Knowledge Base Oficial do Projeto
├── package.json
├── pnpm-workspace.yaml
├── turbo.json
└── README.md
```

---

## 1. Regras de Importação no Monorepo
* **Proibição de imports relativos cruzados entre apps:** `apps/web-portal` nunca pode importar diretamente arquivos de `apps/api-server`.
* **Uso obrigatório de pacotes:** Tipos compartilhados devem ser exportados em `packages/shared-types` e consumidos como `@plataforma/shared-types`.
* **Componentes visuais:** Componentes de interface devem ser criados em `packages/ui` e consumidos como `@plataforma/ui`.

---

## 2. Documentos Relacionados
* [ADR-005 — Ferramentas de Monorepo](../03-architecture/adr/ADR-005-monorepo-tooling.md)
* [Padrões de Código](coding-standards.md)
* [Guia de Setup](setup.md)
