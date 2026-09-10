---
title: "Topologia de Rede AWS, VPC e Security Groups"
domain: "infrastructure"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# 🌐 Topologia de Rede AWS, VPC & Security Groups

Arquitetura de rede isolada em duas Zonas de Disponibilidade (*Availability Zones*) para garantir resiliência e segurança.

---

## 1. Estrutura de Subnets da VPC (`10.0.0.0/16`)

```
VPC CIDR: 10.0.0.0/16 (us-east-1)
├── Availability Zone us-east-1a:
│   ├── Public Subnet A:     10.0.1.0/24   (ALB, Internet Gateway, NAT Gateway A)
│   ├── Private App Subnet A: 10.0.10.0/24  (ECS Tasks da API)
│   └── Private DB Subnet A:  10.0.20.0/24  (RDS PostgreSQL Master)
│
└── Availability Zone us-east-1b:
    ├── Public Subnet B:     10.0.2.0/24   (ALB redundante)
    ├── Private App Subnet B: 10.0.11.0/24  (ECS Tasks da API)
    └── Private DB Subnet B:  10.0.21.0/24  (RDS PostgreSQL Standby Multi-AZ)
```

---

## 2. Regras de Firewall (Security Groups)

```
[Internet]
   │ HTTPS (443)
   ▼
[ALB Security Group]
   │ HTTP (3000) [Origem: Exclusivamente ALB-SG]
   ▼
[ECS Task Security Group]
   │ PostgreSQL (5432) [Origem: Exclusivamente ECS-SG]
   ▼
[RDS Security Group]
```

### Princípio de Bloqueio Estrito:
* O Security Group do RDS bloqueia **qualquer** acesso externo; somente o Security Group das tasks ECS tem autorização para conectar na porta 5432.
* As tasks ECS não possuem IP público e acessam a internet externa (para envio de e-mails/chamadas) através do NAT Gateway.

---

## 3. Documentos Relacionados
* [Serviços AWS](aws.md)
* [Terraform](terraform.md)
* [Segurança](../05-security/overview.md)
