---
id: ADR-004
status: Accepted
owner: Cloud & DevOps
normalized_at: 2026-09-10
---

# ADR-004 — Plataforma de Computação Serverless com AWS ECS Fargate

## Status
Accepted

## Context
A infraestrutura precisa executar contêineres Docker em alta disponibilidade, dentro de uma VPC privada com segurança Multi-AZ, sem exigir que os estudantes gerenciem sistemas operacionais de instâncias virtuais (EC2) ou a complexidade de clusters Kubernetes (EKS).

## Decision
Adotar o **AWS ECS Fargate** como serviço de computação para o backend da API. O Fargate provê execução serverless de contêineres com cobrança por segundo de uso de vCPU e memória, integração nativa com o Application Load Balancer (ALB), CloudWatch Logs e subnets privadas.

## Alternatives Considered
1. **Amazon EKS (Kubernetes):** Rejeitado pela curva de aprendizado extrema para um projeto semestral e custo base fixo elevado ($73/mês apenas pelo control plane).
2. **AWS App Runner:** Rejeitado pelas limitações de configuração de rede em subnets privadas, execução de migrations efêmeras e controle fino de ALB/WAF.
3. **Amazon EC2 Pura:** Rejeitado pelo overhead de gerenciar patches de segurança, SO e falta de auto-scaling automático simplificado.

## Consequences
* **Positivas:**
  * Zero gerenciamento de servidores físicos ou virtuais.
  * Execução segura em subnets privadas sem IP público.
  * Facilidade de execução de tasks pontuais para migrations do banco.
  * Baixo custo operacional (~$32/mês para Staging + Produção). Nota (2026-10-07): com o ADR-012, apenas Produção existe na AWS; a estimativa vigente está no material de apoio de custos.
* **Negativas:**
  * Tempo de inicialização (*cold start*) de novas tasks é ligeiramente superior ao de instâncias EC2 pré-aquecidas (~30 a 45 segundos).

## Related Documents
- [Infraestrutura AWS](../../operations/infrastructure.md)
- [Topologia de Rede](../../operations/infrastructure.md)
- [Terraform](../../operations/infrastructure.md)
