---
title: Knowledge Base da Plataforma Digital
status: Approved
owner: Product Governance
last_updated: 2026-09-10
baseline: governance-v0.1.0-candidate
---

# Knowledge Base

Esta é a fonte normativa da Plataforma Digital. Estado de tarefas pertence ao GitHub Project; código e migrations pertencem aos repositórios de implementação.

## Mapa

- `governance/`: autoridade, equipes, responsabilidades e processo.
- `product/`: visão, escopo, personas, módulos e épicos.
- `requirements/` e `specs/`: necessidades e comportamento verificável.
- `must-haves/`: invariantes obrigatórios.
- `architecture/` e `contracts/`: decisões e interfaces versionadas.
- `engineering/`, `security/` e `operations/`: padrões e runbooks.
- `operations/guides/`: material de apoio não normativo, como o guia de Cloud & DevOps em `operations/guides/cloud-devops/`.
- `agents/`: limites e fluxo de agentes.
- `traceability/generated/`: índices derivados; não editar manualmente.
- `archive/legacy-2026-09-09/`: baseline anterior preservada com hashes.

## Hierarquia de autoridade

Em conflito: baseline aprovada mais recente → SPEC/Requirement → Must Have → ADR/Contract → guias → arquivo histórico. Nenhum documento `Draft` é normativo.

## Mudanças

Toda mudança ocorre por PR, respeita CODEOWNERS, mantém IDs estáveis e atualiza rastreabilidade. Consulte `governance/workflow.md`.
