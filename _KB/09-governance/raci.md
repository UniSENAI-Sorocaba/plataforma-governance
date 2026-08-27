---
title: "Matriz RACI Geral do Projeto"
domain: "governance"
status: "accepted"
owner: "Luciano Jr / Fellipe Raszejas"
last_updated: "2026-08-27"
---

# 📊 Matriz RACI Geral do Projeto

Definição formal de responsabilidades por processo e decisão técnica no projeto.

* **R (Responsible):** Quem executa a atividade.
* **A (Accountable):** Quem aprova e responde pelo resultado final (apenas 1 por linha).
* **C (Consulted):** Quem é consultado previamente para tomada de decisão.
* **I (Informed):** Quem é formalmente informado após a execução.

---

## 1. Matriz de Atribuições

| Atividade / Decisão Técnica | PO (Fellipe) | Luciano Jr | Tech Lead Back (Marco) | Tech Lead Front (Nicolas L.) | Tech Lead DB (Isabelly) | Tech Lead Cloud (Fazano) | Tech Lead QA (Nicolle) | Stakeholders / Profs |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Definição de Backlog e Prioridades** | **A** | R | C | C | C | C | C | I |
| **Definição da Arquitetura do Sistema** | C | **A** | R | R | R | R | C | I |
| **Arquitetura e Políticas de SSO/IAM** | I | **A** | R | R | C | C | C | I |
| **Modelagem do Banco e Migrations** | I | C | R | I | **A** | I | I | I |
| **Desenvolvimento de APIs Backend** | I | C | **A** (R: Squads) | C | C | I | C | I |
| **Desenvolvimento de Interfaces Frontend**| C | I | C | **A** (R: Squads) | I | I | C | I |
| **Infraestrutura AWS e Terraform** | I | C | I | I | I | **A** (R: Cloud) | I | I |
| **Pipelines de CI/CD e Deploy** | I | C | C | C | I | **A** | C | I |
| **Estratégia de Testes e Quality Gates** | I | C | C | C | I | I | **A** (R: QA) | I |
| **FinOps e Orçamento Cloud AWS** | I | **A** | I | I | I | R | I | I |
| **Aprovação de Release em Produção** | **A** | R | C | C | C | C | R | I |

---

## 2. Documentos Relacionados
* [Estrutura de Equipe](team-structure.md)
* [Responsabilidades de Liderança](responsibilities.md)
* [Definition of Done](definition-of-done.md)
