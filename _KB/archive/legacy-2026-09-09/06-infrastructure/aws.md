---
title: "Catálogo de Serviços AWS e Dimensionamento"
domain: "infrastructure"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# ☁️ Catálogo de Serviços AWS & Dimensionamento

Lista detalhada dos serviços AWS selecionados, justificativas de escolha, configurações e estimativas de custo.

---

## 1. Tabela de Serviços AWS

| Serviço AWS | Função no Projeto | Justificativa Técnica | Alternativa Avaliada & Rejeitada | Custo Estimado / Mês |
| :--- | :--- | :--- | :--- | :---: |
| **AWS VPC** | Isolamento de rede Multi-AZ | Segurança essencial com subnets públicas e privadas em 2 AZs (`us-east-1a` e `us-east-1b`). | Rede padrão sem VPC (Inseguro). | Gratuito |
| **AWS ECS Fargate** | Execução de Contêineres Serverless | Não exige manutenção de VMs; escalabilidade automática, isolamento por task e baixo custo. | EKS (Overhead operacional gigantesco) / EC2 pura. | ~$32.00 |
| **Amazon RDS PostgreSQL** | Banco de dados relacional Multi-AZ | Alta confiabilidade, backups automatizados diários, patches gerenciados e integridade ACID. | PostgreSQL em EC2 (Risco alto de perda de dados). | ~$35.00 |
| **Application Load Balancer** | Distribuição de tráfego HTTPS | Terminação TLS, health checks granulares e integração nativa com AWS WAF e ECS. | Nginx em EC2 (Falta de escalabilidade e alta manutenção). | ~$18.00 |
| **Amazon S3** | Armazenamento de PDFs e evidências | Durabilidade de 99.999999999%, URLs pré-assinadas para upload seguro e custos ínfimos. | Disco EBS do contêiner (Perda ao recriar task). | ~$4.00 |
| **Amazon CloudFront** | CDN para frontend e assets estáticos | Cache estático global, redução drástica de latência e blindagem de ataques DDoS. | Servir assets direto do Next.js/S3 (Sobrecarga de CPU/banda). | ~$3.00 |
| **AWS Secrets Manager** | Gestão de chaves RSA e credenciais | Rotação de chaves e injeção segura de variáveis de ambiente no ECS em tempo de execução. | Variáveis hardcoded no código/Git (Grave falha de segurança). | ~$2.50 |
| **Amazon CloudWatch** | Logs centralizados, métricas e alarmes | Monitoramento nativo de CPU, memória, latência e logs de contêiner em tempo real. | Datadog / New Relic (Custo inviável para projeto semestral). | ~$5.00 |
| **AWS WAF** | Web Application Firewall no ALB | Proteção contra SQLi, XSS, rate limiting por IP e bloqueio de scanners automatizados. | - | ~$6.00 |
| **TOTAL ESTIMADO MENSAL** | - | - | - | **~$105.50 / mês** |

---

## 2. Documentos Relacionados
* [ADR-004 — AWS ECS Fargate](../03-architecture/adr/ADR-004-aws-ecs-fargate-platform.md)
* [Terraform](terraform.md)
* [FinOps e Controle Orçamentário](../07-devops/finops.md)
