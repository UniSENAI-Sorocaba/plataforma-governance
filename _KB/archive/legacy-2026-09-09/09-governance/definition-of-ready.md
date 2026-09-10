---
title: "Definition of Ready (DoR) Oficial"
domain: "governance"
status: "accepted"
owner: "Fellipe Raszejas / Luciano Jr"
last_updated: "2026-08-27"
---

# 📋 Definition of Ready (DoR) Oficial

Critérios obrigatórios que uma User Story deve atender durante o Refinamento antes de poder ser puxada para o Sprint Backlog no Sprint Planning.

---

## 1. Checklist Oficial de Definition of Ready (DoR)

Uma história está **Pronta (Ready)** quando atende 100% dos seguintes pontos:

- [ ] **Descrição Estruturada:** Descrição clara no formato padrão: *Como [perfil], quero [ação], para [objetivo de negócio]*.
- [ ] **Critérios de Aceite BDD:** Cenários de aceite documentados em formato Gherkin (*Dado / Quando / Então*), cobrindo cenários felizes e cenários de erro/exceção.
- [ ] **Dependências Resolvidas:** Dependências técnicas, de banco de dados ou de outros módulos identificadas e mapeadas.
- [ ] **Contratos de Dados (DTOs):** Schemas e tipos preliminares identificados no pacote `packages/shared-types`.
- [ ] **Design Validado:** Protótipos de tela (Figma/Wireframes) validados pelo PO (caso a história possua interface visual).
- [ ] **Estimativa em Pontos:** História estimada e pontuada pelo squad (Story Points).
- [ ] **Requisitos de Segurança Mapeados:** Papéis RBAC necessários (`@Roles()`) e impactos de LGPD previamente definidos.

---

## 2. Documentos Relacionados
* [Definition of Done](definition-of-done.md)
* [User Stories](../02-planning/user-stories.md)
* [Cerimônias Scrum](ceremonies.md)
