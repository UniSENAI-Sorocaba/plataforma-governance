---
title: "Product Backlog Estruturado"
domain: "planning"
status: "accepted"
owner: "Fellipe Raszejas / Luciano Jr"
last_updated: "2026-08-27"
---

# 📋 Product Backlog Estruturado

O Product Backlog está organizado por **Épicos**, **Features** e **User Stories**, estruturado entre o **Escopo Obrigatório com entrega em Dezembro (MVP)** e o **Backlog / Fase 2 (Próximo Semestre)**.

* **P0 — Crítico:** Bloqueante para o MVP Obrigatório de Dezembro.
* **P1 — Alta:** Essencial para a experiência completa e prestação de contas no MVP.
* **P2 / P3 — Fase 2:** Postergado para o planejamento do próximo semestre.

---

## 🎯 PARTE 1: ESCOPO OBRIGATÓRIO — DEZEMBRO (MVP DO SEMESTRE)

| ID Épico | Feature | ID US | Título da User Story | Prioridade | Squad Responsável | Sprint Alvo |
| :--- | :--- | :--- | :--- | :---: | :--- | :---: |
| **EP01-IAM** | Autenticação Central | **US01** | Login institucional e emissão de Access/Refresh Token | **P0** | Squad Core | Sprint 1 |
| **EP01-IAM** | Gestão de Sessões | **US02** | Revogação de tokens e logout centralizado | **P0** | Squad Core | Sprint 1 |
| **EP01-IAM** | Autorização RBAC | **US03** | Controle de permissões por perfil nas rotas da API | **P0** | Squad Core | Sprint 2 |
| **EP01-IAM** | Auditoria | **US04** | Log de auditoria de acessos e operações críticas | **P1** | Squad Core | Sprint 3 |
| **EP02-PI** | Captação & Equipes | **US05** | Captação de propostas de PI/Extensão e convite de alunos | **P0** | Squad Acadêmico | Sprint 1 |
| **EP02-PI** | Bancas & Avaliadores| **US06** | Vinculação de professores e agendamento de bancas | **P0** | Squad Acadêmico | Sprint 2 |
| **EP02-PI** | Avaliação & Notas | **US07** | Lançamento de notas por rubricas e cálculo consolidado | **P0** | Squad Acadêmico | Sprint 3 |
| **EP02-PI** | Entregáveis | **US08** | Upload de relatórios finais e artefatos no S3 | **P0** | Squad Acadêmico | Sprint 2 |
| **EP03-EXT** | Editais & Inscrições | **US09** | Publicação de editais e inscrição de discentes em extensão| **P0** | Squad Extensão & Portal | Sprint 1 |
| **EP03-EXT** | Validação de Horas | **US10** | Submissão de relatório de atividade e apuração de horas | **P0** | Squad Extensão & Portal | Sprint 2 |
| **EP03-EXT** | Certificação | **US11** | Emissão e validação pública de certificados em PDF | **P0** | Squad Extensão & Portal | Sprint 3 |
| **EP04-PUB** | Vitrine de Projetos | **US12** | Listagem pública e busca facetada de projetos de PI/Extensão| **P0** | Squad Extensão & Portal | Sprint 3 |
| **EP04-PUB** | Detalhes & Impacto | **US13** | Divulgação do impacto comunitário e prestação social | **P1** | Squad Extensão & Portal | Sprint 4 |

---

## ⏳ PARTE 2: BACKLOG / FASE 2 (POSTERGADO PARA O PRÓXIMO SEMESTRE)

| ID Épico | Feature | ID US | Título da User Story | Prioridade | Planejamento |
| :--- | :--- | :--- | :--- | :---: | :---: |
| **EP05-PAT** | Notebooks | **US14** | Inventário de notebooks, QR Code e check-in/check-out | **P2** | Próximo Semestre (2027.1) |
| **EP05-PAT** | Salas & Avarias | **US15** | Agendamento de salas fora do horário e registro de avarias | **P2** | Próximo Semestre (2027.1) |
| **EP06-CAR** | Banco de Talentos | **US16** | Cadastro de currículo e visualização de vagas de estágio | **P3** | Próximo Semestre (2027.1) |
| **EP07-IC** | Planos de Trabalho | **US17** | Submissão de projetos de Iniciação Científica e relatórios | **P3** | Próximo Semestre (2027.1) |
| **EP08-CPA** | Autoavaliação & Ouv. | **US18** | Formulários anônimos de avaliação e canal de relatos | **P2** | Próximo Semestre (2027.1) |

---

## 2. Documentos Relacionados
* [Delimitação do MVP](../01-product/mvp.md)
* [User Stories Detalhadas](user-stories.md)
* [Planejamento de Sprints](sprint-plan.md)
* [Roadmap Semestral](roadmap.md)
