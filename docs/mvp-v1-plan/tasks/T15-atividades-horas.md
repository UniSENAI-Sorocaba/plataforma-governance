# T15 — Implementar atividades e horas de extensão

**Fase:** F4  | **Referências:** BE-014, DB-013, FE-012, QA-015

## Objetivo

Registrar atividades, decisões docentes e total de horas aprovadas.

## Implementação

- Criar atividade
- aprovar/rejeitar com motivo
- totalizar apenas aprovadas
- impedir duplicidade e valores inválidos
- manter estado atual e motivo, sem histórico de auditoria de negócio.

## Dependências

T14 e T10.

## Testes e validações

- Testar envio, aprovação/rejeição, limites, reenvio, duplicidade, total acumulado e ausência de histórico de negócio.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md. Validação: .agents/quality-security-agent.md. Aceite: PO.

## Métrica e evidência de aceite

Total reproduzível em 100% dos fixtures de horas.

## Critério de Done

Aluno e docente visualizam estado e total correto.

## Decisões de implementação do MVP

- Horas em incrementos de 0,25, entre 0,25 e 100 por atividade; sem limite acumulado não definido.
- Estados formais: `SUBMITTED`, `APPROVED`, `REJECTED`; recusa exige motivo e aprovação exige horas aprovadas.
- Reenvio de atividade recusada é permitido antes do encerramento do período e substitui o registro atual, sem histórico.
- Duplicidade é a mesma combinação de projeto, período, aluno e título normalizado.
- O prazo é o `ends_at` do período, com fronteira final exclusiva; o ajuste excepcional permanece bloqueado até resolução de Q61/Q62.

## Evidência

Consultar [F4-T15-execution-2026-11-20.md](../evidence/F4-T15-execution-2026-11-20.md).

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
