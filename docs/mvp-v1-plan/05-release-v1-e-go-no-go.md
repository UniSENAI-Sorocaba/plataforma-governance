# 05 — Release V1, DevSecOps e Go/No-Go

## Objetivo

Converter o MVP funcional em uma V1 implantável, observável, segura e reversível.

## Subfase A — Quality gates

### Etapa A1 — Testes automatizados

**Itens:** `QA-003`, `QA-007`, `QA-008` a `QA-020`.  
**Aceite:** testes API cobrem jornadas P0; contratos detectam breaking change; E2E cobre login, proposta, equipe, entregável, horas, avaliação, certificado e portal; cobertura global mínima é 75%, com metas específicas definidas por linguagem.

### Etapa A2 — Segurança

**Itens:** `QA-002`, `QA-005`, `QA-006`, `QA-025`, `QA-026`.  
**Aceite:** threat model atualizado; SAST, SCA, secret scanning, container scan, IaC scan e ZAP executados; zero High/Critical sem correção ou aceite formal; nenhum segredo real em repositório, artefato ou log.

### Etapa A3 — Performance

**Itens:** `QA-024`, `INF-017`, `DB-017`, `DB-019`.  
**Aceite:** cenário k6 sustenta 200 RPS; p95 <= 500 ms; taxa de erro < 1%; pool de conexões não esgota; consultas lentas possuem evidência e correção ou risco aceito.

## Subfase B — Operação

### Etapa B1 — Observabilidade

**Itens:** `INF-012`, `INF-013`.  
**Aceite:** logs estruturados com correlation ID; métricas de erro, latência, disponibilidade e banco; alarmes testados; dashboard permite identificar uma falha de jornada P0.

### Etapa B2 — Backup e restore

**Itens:** `INF-015`, `INF-016`, `DB-018`.  
**Aceite:** backup diário com retenção definida; restore em instância temporária; RPO/RTO medidos; integridade das migrations e dados restaurados comprovada.

### Etapa B3 — Deploy e rollback

**Itens:** `INF-018` a `INF-021`.  
**Aceite:** versão anterior é recuperável; gatilho de rollback é observável; responsável de plantão definido; rollback ensaiado; smoke pós-deploy registrado; runbook testado por pessoa diferente do autor.

## Subfase C — Homologação

### Etapa C1 — Regressão consolidada

**Itens:** `QA-023`, `QA-028`.  
**Aceite:** todas as jornadas P0 são executadas em staging; falhas geram defeito com owner, severidade e prazo; nenhum P0 permanece aberto sem decisão formal.

### Etapa C2 — Pacote de release

**Itens:** `PG-017`, `PG-018`, `QA-030`.  
**Aceite:** cada Must Have aponta SPEC, Issue, PR integrado e evidência; exceções possuem justificativa, risco, owner, prazo e mitigação; pacote é navegável e não contém segredos ou dados pessoais indevidos.

### Etapa C3 — Decisão go/no-go

**Participantes:** PO/LPO, .agents/orchestrator.md, .agents/governance-agent.md, .agents/quality-security-agent.md, .agents/infrastructure-agent.md, .agents/architecture-agent.md, .agents/backend-agent.md, .agents/database-agent.md e .agents/frontend-agent.md.  
**Go:** todos os bloqueadores P0 atendidos; smoke e rollback aprovados; risco residual aceito formalmente.  
**No-go:** qualquer falha P0, finding crítico sem tratamento, artefato ausente ou rollback não ensaiado.

## Checklist de release

- [ ] código integrado na branch de release;
- [ ] migrations testadas em banco limpo e upgrade;
- [ ] build e artefatos identificados por versão imutável;
- [ ] contrato e frontend compatíveis;
- [ ] testes API, contrato, E2E, performance e segurança executados;
- [ ] cobertura e vulnerabilidades dentro das metas;
- [ ] backup/restore e rollback comprovados;
- [ ] smoke pós-deploy executado;
- [ ] aprovação do PO registrada;
- [ ] decisão go/no-go publicada.

## Estado desta execução

O pacote foi avaliado em 2026-11-21. A decisão atual é **NO-GO controlado**: o MVP local está integrado e validado, mas staging/AWS não estão disponíveis para executar E2E consolidado, Lighthouse, DAST, backup/restore, smoke e rollback. A decisão detalhada, owners e critérios de desbloqueio estão em [F6-go-no-go-2026-11-21.md](./evidence/F6-go-no-go-2026-11-21.md).
