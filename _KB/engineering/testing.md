---
id: POL-QA-002
status: Approved
owner: Quality, Tests & Security
approved_at: 2026-09-10
---

# Estratégia de testes

Usar unitários para lógica, integração para banco/serviços, contract tests nas fronteiras, E2E para jornadas críticas, k6 para carga e SAST/SCA/DAST para segurança. Cada AC automatizável aponta para evidência. FAIL bloqueia merge; WARN exige justificativa humana.
