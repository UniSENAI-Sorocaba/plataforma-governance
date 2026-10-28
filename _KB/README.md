---
title: Knowledge Base da Plataforma Digital
status: Approved
owner: Product Governance
last_updated: 2026-10-28
baseline: governance-v0.1.0-candidate
---

# Knowledge Base

Esta é a fonte normativa da Plataforma Digital. Estado de tarefas pertence ao GitHub Project; código e migrations pertencem aos repositórios de implementação.

## Mapa

- `governance/`: autoridade, equipes, responsabilidades e processo.
- `product/`: visão, escopo, personas, módulos, épicos e decisões oficiais do produto.
- `requirements/` e `specs/`: necessidades e comportamento verificável.
- `must-haves/`: invariantes obrigatórios.
- `architecture/` e `contracts/`: decisões e interfaces versionadas.
- `engineering/`, `security/` e `operations/`: padrões e runbooks.
- `operations/guides/`: material de apoio não normativo, como o guia de Cloud & DevOps em `operations/guides/cloud-devops/`.
- `agents/`: limites e fluxo de agentes.
- `traceability/generated/`: índices derivados; não editar manualmente.
- `archive/legacy-2026-09-09/`: baseline anterior preservada com hashes.

## Hierarquia de autoridade

Para regras de negócio cobertas pelo Caderno de Validações de Escopo — AUTH, PI e Extensão, prevalecem as respostas oficiais do caderno sobre regras funcionais anteriores conflitantes. A transcrição versionada está em [Regras oficiais do caderno de validações](product/official-validation-decisions.md). ADRs, contratos, SPECs, Must Haves e guias incompatíveis devem ser reconciliados por PR, preservando rastreabilidade e deixando explícitos os detalhes que o caderno não definiu.

Para temas não respondidos pelo caderno, permanece a baseline aprovada mais recente → SPEC/Requirement → Must Have → ADR/Contract → guias → arquivo histórico. Nenhum documento `Draft` é normativo. Uma resposta oficial do caderno não torna automaticamente uma SPEC completa: faltas de critérios, estados, dados e detalhes técnicos permanecem registradas como lacunas.

## Mudanças

Toda mudança ocorre por PR, respeita CODEOWNERS, mantém IDs estáveis e atualiza rastreabilidade. Consulte `governance/workflow.md`.
