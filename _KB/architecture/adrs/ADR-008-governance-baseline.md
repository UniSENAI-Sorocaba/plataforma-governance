---
id: ADR-008
status: Accepted
date: 2026-09-10
owners: [Product Governance, Cloud & DevOps]
---

# Distribuição da baseline

Baselines usam tag `governance-vMAJOR.MINOR.PATCH` e SHA imutável. Cada repo contém `.governance-baseline`; CI confirma tag → SHA antes do compliance. Cópias locais alteráveis não são autoridade.
