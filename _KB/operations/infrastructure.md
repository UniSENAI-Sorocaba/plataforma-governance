---
id: POL-INFRA-003
status: Approved
owner: Cloud & DevOps
approved_at: 2026-09-10
---

# Infraestrutura

AWS gerenciada por Terraform, com production isolado, PostgreSQL 16, containers, armazenamento S3 protegido e frontend com runtime SSR. Apenas production existe na AWS (ADR-012): development executa localmente e a validação ocorre em ambiente efêmero no CI, sem dados reais. Backup de produção é diário com retenção inicial de 14 dias; restore real deve ser validado antes do go-live.
