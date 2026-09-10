---
title: "Visão Geral de Infraestrutura e Nuvem"
domain: "infrastructure"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# ☁️ Visão Geral de Infraestrutura & Nuvem

A infraestrutura da plataforma é provisionada integralmente como código (**Infrastructure as Code - IaC**) via **Terraform** na nuvem **Amazon Web Services (AWS)**, projetada com foco em alta confiabilidade, segurança Multi-AZ, automação de deploys e custos otimizados.

---

## 1. Princípios de Arquitetura de Infraestrutura
* **100% Declarativa:** Nenhum recurso é criado manualmente via console da AWS (*ClickOps proibido*). Toda mudança passa pelo Terraform.
* **Isolamento de Rede:** O backend e o banco de dados rodam exclusivamente em subnets privadas sem IP público atribuído.
* **Serverless First:** Uso de serviços gerenciados e serverless (ECS Fargate, RDS PostgreSQL, S3, CloudFront) para eliminar tarefas operacionais de SO.

---

## 2. Responsabilidades da Frente de Infraestrutura
* **Owner Técnico Geral:** **Luciano Jr** (Definição da topologia, governança de custos FinOps, dimensionamento e revisão de módulos Terraform).
* **Líder Técnico de Cloud/DevOps:** **Fazano** (Coordenação da execução do Terraform, automação de pipelines e monitoramento).
* **Engenheiros de Cloud:** Vinicius Pereira, Felipe Nunes, Gustavo Gomes, Gabriel Camargo.

---

## 3. Documentos Relacionados
* [Catálogo de Serviços AWS](aws.md)
* [Topologia de Rede](networking.md)
* [Terraform](terraform.md)
* [Docker](docker.md)
