---
title: "Definition of Done (DoD) Oficial"
domain: "governance"
status: "accepted"
owner: "Luciano Jr / Fellipe Raszejas"
last_updated: "2026-08-27"
---

# ✅ Definition of Done (DoD) Oficial

Critérios de qualidade e engenharia inegociáveis para que uma User Story seja considerada **Concluída (Done)** e entregue ao final da Sprint.

---

## 1. Checklist Oficial de Definition of Done (DoD)

Uma história só pode ser movida para **Done** quando cumprir integralmente:

- [ ] **Código Implementado:** Código-fonte escrito aderente aos padrões do projeto (Clean Code, TypeScript strict e sem console.logs).
- [ ] **Testes Automatizados:** Testes unitários e de integração escritos cobrindo todos os cenários de aceite descritos na história.
- [ ] **Cobertura de Código Mínima:** Cobertura de linhas do novo código $\ge 80\%$ validada pelo Jest.
- [ ] **Code Review Aprovado:** Pull Request aprovado formalmente por no mínimo **2 revisores autorizados** (com 1 Tech Lead).
- [ ] **Quality Gate & SAST Verde:** Pipeline do GitHub Actions verde, sem vulnerabilidades no SonarQube e Trivy.
- [ ] **Migrations Aplicadas:** Scripts de migração de banco de dados executados sem falhas e sem quebra de compatibilidade.
- [ ] **Documentação Atualizada:** Especificação OpenAPI (Swagger) atualizada e documentação de código/KB sincronizada.
- [ ] **Deploy em Staging:** Deploy automatizado concluído com sucesso no ambiente AWS Staging.
- [ ] **Homologação pelo PO:** Funcionalidade validada e aprovada pelo Product Owner (Fellipe Raszejas ou Luciano Jr).
- [ ] **Critérios de Aceite Atendidos:** 100% dos cenários Gherkin da User Story validados manualmente ou via E2E.

---

## 2. Documentos Relacionados
* [Definition of Ready](definition-of-ready.md)
* [Quality Gates](../08-quality/strategy.md)
* [Diretrizes de Pull Requests](../04-development/pull-requests.md)
