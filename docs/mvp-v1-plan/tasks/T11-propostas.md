# T11 — Criar modelo de propostas e participação

**Fase:** F3  | **Referências:** DB-008, BE-007, FE-006, QA-011

## Objetivo

Permitir o cadastro de projetos como rascunho ou publicado e preparar o modelo de participação por solicitação do aluno e decisão docente.

## Implementação

- Modelar projeto/proposta e o relacionamento de docentes responsáveis sem assumir um `owner` singular. O modelo deve garantir pelo menos um responsável.
- Modelar separadamente publicação (`DRAFT`/`PUBLISHED`) e ciclo de vida (`ACTIVE`/`ARCHIVED`), com reabertura/arquivamento autorizados ao responsável.
- Modelar solicitação de participação iniciada pelo aluno e decisão docente; não criar entidade, endpoint ou tela de convite individual.
- Validar `title` (5–200), `summary` (20–500), `description` (50–5000), classificação, duração e ao menos um responsável; rascunho exige o conjunto mínimo e publicação exige o conjunto completo.
- Aplicar elegibilidade a aluno autenticado, ativo e institucionalmente vinculado; não criar limite de vagas.
- Modelar período com início inclusivo, fim exclusivo, semestre e fuso `America/Sao_Paulo`; coordenação pode ajustar/reabrir sem retroatividade.
- Impedir edição fora das permissões e transições formalmente definidas.
- Persistir o estado atual sem criar histórico de auditoria de negócio ou histórico de valores anteriores de horas/notas.

## Dependências

T03, T09 e T10.

## Testes e validações

- Testar criação/consulta/edição permitidas por papel, publicação e rascunho, campos mínimos, responsável ausente, estados `ACTIVE/ARCHIVED`, isolamento, solicitação/decisão de participação, concorrência dos limites de participação, recuperação de rascunho e E2E.
- Não criar exclusão nem submissão separada de proposta; testar `DRAFT/PUBLISHED`, `ACTIVE/ARCHIVED` e as transições de solicitação definidas na SPEC.

## Agentes necessários

Executor: .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md. Revisor: .agents/architecture-agent.md. Validação: .agents/quality-security-agent.md. Aceite: PO.

## Métrica e evidência de aceite

100% das regras e transições formalmente aprovadas cobertas; zero alteração manual no banco no E2E; nenhum fluxo de convite individual ou estado de submissão não aprovado introduzido.

## Critério de Done

Proposta percorre o fluxo aprovado de criação, rascunho/publicação e, quando contratado, participação por solicitação/decisão, com autorização server-side. Logs técnicos devem ser sanitizados e não podem funcionar como auditoria de negócio.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
