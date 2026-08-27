---
title: "Gestão de Segredos e Variáveis Sensíveis"
domain: "security"
status: "accepted"
owner: "Luciano Jr / Fazano"
last_updated: "2026-08-27"
---

# 🔐 Gestão de Segredos & Variáveis Sensíveis

Estratégia para armazenamento, injeção e rotação de credenciais, chaves criptográficas e variáveis sensíveis na nuvem AWS.

---

## 1. Uso do AWS Secrets Manager
Em ambientes de Staging e Produção, nenhuma variável sensível é injetada via texto puro ou arquivos `.env`. As credenciais residem no **AWS Secrets Manager**:
* `plataforma/jwt/rsa-private-key`: Chave privada RSA (PEM) usada para assinar tokens JWT.
* `plataforma/jwt/rsa-public-key`: Chave pública RSA para validação de assinatura.
* `plataforma/database/credentials`: Usuário e senha mestra do PostgreSQL RDS.
* `plataforma/smtp/credentials`: Credenciais do provedor de e-mail transacional.

---

## 2. Injeção no ECS Fargate em Tempo de Execução
O Terraform configura a Task Definition do ECS Fargate para recuperar os segredos diretamente do Secrets Manager via IAM Task Execution Role:
```json
"secrets": [
  {
    "name": "DATABASE_URL",
    "valueFrom": "arn:aws:secretsmanager:us-east-1:123456789012:secret:plataforma/database/credentials:DATABASE_URL::"
  },
  {
    "name": "JWT_PRIVATE_KEY",
    "valueFrom": "arn:aws:secretsmanager:us-east-1:123456789012:secret:plataforma/jwt/rsa-private-key:key::"
  }
]
```

---

## 3. Prevenção de Vazamento no Repositório (Gitleaks)
* **Pre-commit hook:** Execução obrigatória do `gitleaks protect --staged` antes de qualquer commit.
* **CI Scan:** Job no GitHub Actions que varre o histórico completo do PR em busca de chaves privadas, strings de conexão ou tokens vazados.

---

## 4. Documentos Relacionados
* [Threat Modeling](threat-model.md)
* [Infraestrutura AWS](../06-infrastructure/aws.md)
* [Terraform](../06-infrastructure/terraform.md)
