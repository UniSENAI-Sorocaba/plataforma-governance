---
id: POL-QA-001
status: Approved
owner: Quality, Tests & Security
approved_at: 2026-09-10
---

# Política de qualidade

Backend: lines >= 80% e branches >= 70%; auth, authorization, security e regras core: lines >= 90% e branches >= 80%. Frontend: lógica testável >= 70%, com E2E obrigatório nos fluxos críticos. Infra usa fmt, validate, lint, scan e plan validation.

API CRUD de referência: p95 <= 500 ms no cenário versionado; alerta operacional em p95 > 800 ms por 5 minutos. Frontend público: LCP <= 2,5 s, INP <= 200 ms e CLS <= 0,1.
