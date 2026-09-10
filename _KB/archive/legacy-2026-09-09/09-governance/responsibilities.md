---
title: "Papéis e Atribuições de Liderança Transversal"
domain: "governance"
status: "accepted"
owner: "Fellipe Raszejas / Luciano Jr"
last_updated: "2026-08-27"
---

# 👑 Papéis & Atribuições de Liderança Transversal

Detalhamento da atuação das lideranças e consolidação das responsabilidades de **Luciano Jr** como **Owner Técnico Transversal e Product Owner Auxiliar**.

---

## 1. Modelo de Liderança de Luciano Jr (Owner vs. Executor)

Para garantir máxima eficiência sem sobrecarga operacional ou centralização de gargalos, Luciano Jr atua sob o modelo de **Owner de Governança Técnica e Decisão**, delegando a execução tática aos respectivos líderes de especialidade:

```
                              +---------------------------------------+
                              |              LUCIANO JR               |
                              |  - PO Auxiliar / Trainee              |
                              |  - Líder Técnico & Arquiteto Geral    |
                              +---------------------------------------+
                                                  |
         +--------------------+-------------------+-------------------+--------------------+
         |                    |                   |                   |                    |
+--------v-------+   +--------v-------+  +--------v-------+  +--------v-------+   +--------v-------+
|    PRODUTO     |   |  ARQUITETURA   |  |     CLOUD      |  |  QA / DEVSEC   |   |    SSO/IAM     |
| (Com Fellipe)  |   | (Com Marco)    |  | (Com Fazano)   |  | (Com Nicolle)  |   | (Owner Direto) |
| Refinamento,   |   | Modelagem,     |  | Terraform,     |  | Quality Gates, |   | OAuth2, JWT,   |
| DoR, DoD,      |   | Contratos API, |  | CI/CD, FinOps, |  | SAST, Cobert., |   | RBAC, Políticas|
| Homologação    |   | Padrões DDD    |  | AWS Budgets    |  | Testes E2E     |   | de Segurança   |
+----------------+   +----------------+  +----------------+  +----------------+   +----------------+
```

---

## 2. Consolidação das Responsabilidades por Domínio

### 2.1 Produto & Agile (com Fellipe Raszejas — PO Titular)
* Apoio na priorização e refinamento contínuo do Product Backlog.
* Detalhamento de User Stories, critérios de aceite BDD/Gherkin e fluxos de usuário.
* Facilitação e acompanhamento das cerimônias ágeis (Planning, Dailies, Reviews, Retrospectivas).
* Homologação formal de entregas e acompanhamento de métricas (Velocity, Burndown, Lead Time).

### 2.2 Arquitetura de Software & Backend (com Marco — Líder Backend)
* Definição e evolução da arquitetura Monólito Modular baseada em DDD.
* Definição de padrões de contratos de API RESTful e DTOs tipados.
* Governança de isolamento entre módulos de domínio e prevenção de acoplamento.

### 2.3 SSO / IAM & Segurança da Informação (Owner Direto)
* Arquitetura da central de autenticação e autorização (OAuth2/OIDC com PKCE).
* Desenho das políticas de tokens JWT (RS256) e Refresh Tokens seguros.
* Definição da matriz de perfis RBAC e trilhas de auditoria de acessos.

### 2.4 Cloud Platform, DevOps & FinOps (com Fazano — Líder Cloud)
* Definição da topologia AWS (VPC Multi-AZ, ECS Fargate, RDS PostgreSQL, ALB, S3, WAF).
* Governança de scripts Terraform e esteiras de CI/CD no GitHub Actions.
* Monitoramento do orçamento AWS Budgets ($120/mês) e regras de auto-stop de Staging.

### 2.5 Qualidade & DevSecOps (com Nicolle — Líder QA)
* Definição da pirâmide de testes e metas de cobertura mínima ($\ge 75\%$).
* Integração de ferramentas SAST (Trivy), DAST (OWASP ZAP) e Testcontainers no CI/CD.
* Validação de Quality Gates antes de merges e releases em produção.

---

## 3. Documentos Relacionados
* [Estrutura de Squads](team-structure.md)
* [Matriz RACI](raci.md)
* [Ritos Scrum](ceremonies.md)
