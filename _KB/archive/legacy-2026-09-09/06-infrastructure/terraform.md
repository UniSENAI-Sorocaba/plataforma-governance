---
title: "Infraestrutura como Código com Terraform"
domain: "infrastructure"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# 🏗️ Infraestrutura como Código (IaC) com Terraform

Estrutura de diretórios, módulos reutilizáveis, gerenciamento de state remoto e convenções para o código Terraform.

---

## 1. Estrutura de Diretórios do Terraform

```text
infra/terraform/
├── environments/
│   ├── staging/                      # Declaração do ambiente de Staging
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   └── production/                   # Declaração do ambiente de Produção
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
├── modules/
│   ├── vpc/                          # Módulo de Rede (VPC, Subnets, IGW, NAT, Route Tables)
│   ├── ecs/                          # Módulo de Computação (Cluster, Task Definition, Service)
│   ├── rds/                          # Módulo de Banco (PostgreSQL 16 Multi-AZ, Subnet Group)
│   ├── s3/                           # Módulo de Storage (Buckets, Políticas e Lifecycle)
│   ├── alb/                          # Módulo de Load Balancer (ALB, Target Groups, Listeners)
│   ├── security/                     # Módulo de Segurança (WAF, Security Groups, IAM Roles)
│   └── monitoring/                   # Módulo de Observabilidade (CloudWatch Logs, Dashboards, Alarmes)
└── backend.tf                        # Configuração do S3 Backend e DynamoDB State Lock
```

---

## 2. Configuração do State Remoto com Lock (`backend.tf`)

```hcl
terraform {
  required_version = ">= 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }

  backend "s3" {
    bucket         = "plataforma-digital-terraform-state"
    key            = "environments/${var.environment}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "plataforma-digital-terraform-locks"
    encrypt        = true
  }
}
```

---

## 3. Política Obrigatória de Tags

Todos os recursos criados devem herdar as tags padrão:
```hcl
locals {
  common_tags = {
    Project     = "PlataformaDigitalIntegrada"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "LucianoJr-Fazano"
    CostCenter  = "Academico2026"
  }
}
```

---

## 4. Documentos Relacionados
* [Serviços AWS](aws.md)
* [Ambientes](environments.md)
* [FinOps](../07-devops/finops.md)
