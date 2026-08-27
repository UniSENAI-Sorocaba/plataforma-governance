---
title: "Topologia de Ambientes (Local, Staging e Produção)"
domain: "infrastructure"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# 🌍 Topologia de Ambientes (Local, Staging e Produção)

Especificação das diferenças de configuração, isolamento e dimensionamento entre os ambientes do ciclo de vida da plataforma.

---

## 1. Matriz de Configuração dos Ambientes

| Característica | Local (Desenvolvimento) | Staging (Homologação) | Produção (Go-Live) |
| :--- | :--- | :--- | :--- |
| **Provedor** | Docker Compose Local | AWS ECS Fargate | AWS ECS Fargate |
| **Branch Git** | `feature/*` | `develop` | `main` (Tags SemVer) |
| **Deploy** | Manual local (`turbo run dev`) | Automático via CI/CD | Manual com Aprovação de Gate |
| **Banco de Dados** | PostgreSQL 16 em Contêiner | RDS PostgreSQL Single-AZ (`db.t4g.micro`)| RDS PostgreSQL Multi-AZ (`db.t4g.micro`) |
| **Armazenamento S3** | LocalStack / Pasta Local | Bucket S3 Staging Privado | Bucket S3 Produção Criptografado |
| **Auto-Stop FinOps**| Não se aplica | Ativo (Desliga 22h às 07h e fins de semana)| **Desativado (24/7 Uptime)** |
| **Segredos / Chaves**| Arquivo `.env` local | AWS Secrets Manager Staging | AWS Secrets Manager Prod |

---

## 2. Documentos Relacionados
* [Infraestrutura AWS](aws.md)
* [Networking](networking.md)
* [FinOps](../07-devops/finops.md)
