---
id: POL-GOV-010
status: Approved
owner: Technical Leads
approved_at: 2026-09-10
---

# Git e Pull Requests

Usar o fluxo: branch curta → PR direcionado a `develop` → merge em `develop`. Todo PR de desenvolvimento deve selecionar `develop` como branch de destino; PRs direcionados diretamente a `main` não fazem parte do fluxo regular. `develop` é a branch de integração e `main` recebe apenas promoções aprovadas de `develop` para release. Push direto e force push são proibidos. Checks, CODEOWNERS e conversas resolvidas são obrigatórios. Releases partem de commits aprovados de `main` por tags protegidas. O PR referencia Issue, SPEC/baseline, testes, riscos e rollback.
