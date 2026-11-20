# T19 — Implementar catálogo, filtros e paginação

**Fase:** F5  | **Referências:** BE-018, DB-014, FE-015, QA-018

## Objetivo

Disponibilizar catálogo público paginado, filtrável e sem dados privados.

## Implementação

- Criar projeção pública segura
- filtros por curso/semestre/ODS
- paginação estável
- índices e EXPLAIN
- estados vazio/erro.

## Dependências

T11, T18 e T10.

## Testes e validações

- Testar contrato de filtros, paginação, privacidade, consulta vazia, benchmark e EXPLAIN.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md. Revisor: .agents/architecture-agent.md. Validação: .agents/quality-security-agent.md.

## Métrica e evidência de aceite

Zero dados privados em respostas públicas; query dentro da meta de p95.

## Critério de Done

Usuário anônimo pesquisa projetos aprovados consistentemente.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
