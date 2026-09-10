---
title: "Plano de Releases e Versionamento"
domain: "planning"
status: "accepted"
owner: "Luciano Jr / Fellipe Raszejas"
last_updated: "2026-08-27"
---

# 🚀 Plano de Releases & Versionamento Semântico

A estratégia de entrega estabelece a **Release v1.0.0 (Escopo Obrigatório - MVP)** com implantação formal em produção no **início de dezembro (Semana 14)**, estruturada através de versões intermediárias em Staging. As funcionalidades adicionais compõem a **Release v2.0.0 (Fase 2 - Próximo Semestre)**.

---

## 1. Calendário Oficial de Releases

```
+--------------------------------------------------------------------------------------------------------------------+
|                                           CALENDÁRIO OFICIAL DE RELEASES                                           |
+---------------------+-------------------+--------------+-----------------------------------------------------------+
| VERSÃO              | PRAZO ALVO        | AMBIENTE     | ESCOPO & OBJETIVO                                         |
+---------------------+-------------------+--------------+-----------------------------------------------------------+
| **v0.1.0-alpha**    | Semana 4 (Set)    | Staging      | SSO/IAM inicial + Captação de Projetos e Editais          |
| **v0.4.0-beta**     | Semana 6 (Out)    | Staging      | Bancas Examinadoras + Submissão e Validação de Horas      |
| **v0.8.0-rc**       | Semana 8 (Out)    | Staging      | Avaliação Docente, Rubricas, Notas, Certificados e Vitrine|
| **v0.9.0-hardening**| Semana 12 (Nov)   | Staging      | Prestação de Contas, Hardening, Carga k6 e Testes E2E     |
| **v1.0.0 (MVP)**    | **Início Dezembro**| **PRODUÇÃO** | **ESCOPO OBRIGATÓRIO (SSO + PI/Extensão + Portal Público)**|
+---------------------+-------------------+--------------+-----------------------------------------------------------+
| **v2.0.0 (Fase 2)** | **Próximo Semestre**| **PRODUÇÃO** | **BACKLOG EXPANSÃO (Patrimônio, Carreiras, IC, CPA/Ouv.)** |
+---------------------+-------------------+--------------+-----------------------------------------------------------+
```

---

## 2. Escopo Detalhado da Release v1.0.0 (Escopo Obrigatório — Dezembro)
* **1. SSO / IAM:** Login único institucional, autenticação OAuth2/JWT RS256, controle RBAC de 5 perfis, controle de sessões e auditoria.
* **2. Projetos Integradores & Extensão:** Captação de propostas de PI e ações de extensão (incluindo modelos híbridos), gestão e alocação de equipes/alunos, agendamento de bancas, avaliação docente por rubricas estruturadas, cálculo consolidado de notas/médias e apuração/validação automatizada de horas curriculares com certificados PDF (SHA-256).
* **3. Portal Público:** Vitrine pública responsiva de projetos desenvolvidos, módulo de divulgação do impacto comunitário e prestação de contas social, busca facetada e validador de certificados.
* **4. Engenharia & Infra:** AWS VPC Multi-AZ, ECS Fargate, RDS PostgreSQL 16, CI/CD com GitHub Actions, observabilidade CloudWatch e custo $< \$120/\text{mês}$.

---

## 3. Rito de Release e Gate de Aprovação de Produção (Go-Live Dezembro)
1. **Criação da Release Branch:** `release/v1.0.0` aberta a partir de `develop`.
2. **Code Freeze:** Congelamento total de código; permitidos apenas bugfixes blockers identificados em Staging.
3. **Bateria de Testes Finais:** Execução de testes de carga (k6 com 200 RPS) e suíte E2E (Playwright) com 100% de sucesso.
4. **Homologação:** Assinatura formal de aceite dos Product Owners (Fellipe Raszejas / Luciano Jr) e Professores Orientadores.
5. **Deploy Automatizado:** Criação da tag Git `v1.0.0` na branch `main`, disparando o workflow do GitHub Actions para deploy em Produção via ECS Fargate com *Rolling Update*.

---

## 4. Documentos Relacionados
* [Roadmap do Projeto](roadmap.md)
* [Planejamento de Sprints](sprint-plan.md)
* [Runbook de Deploy](../10-runbooks/deployment.md)
* [Procedimento de Rollback](../07-devops/rollback.md)
