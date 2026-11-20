# 01 — Agentes, Governança e Operação

## 1. Princípio

Cada entrega deve possuir um agente executor, um agente revisor e um agente de aceite quando houver impacto funcional ou de release. O executor não pode aprovar sozinho a própria mudança normativa, de segurança ou de produto.

## 2. Agentes do plano

| Agente | Responsabilidade | Artefatos de saída | Gate que aprova |
|---|---|---|---|
| PO/LPO (humanos) | prioridade, escopo, aceite funcional, autoridade e exceções | decisão de produto, aceite, exceção | escopo e jornadas |
| .agents/governance-agent.md | rastreabilidade, baseline, SPECs, Must Haves e compliance | matriz SPEC→Issue→PR→evidência, compliance report | conformidade e exceções |
| .agents/architecture-agent.md | limites modulares, contratos, ADRs e dependências | ADR, desenho de integração, API policy | arquitetura |
| .agents/backend-agent.md | domínio, API, segurança de aplicação e regras | código, testes, OpenAPI e handoff | backend |
| .agents/database-agent.md | schema, migrations, constraints, seeds e restore | SQL, migration evidence e dicionário | dados |
| .agents/frontend-agent.md | jornadas, SSR, acessibilidade, UX e integração de API | telas, testes e métricas Web Vitals | experiência |
| .agents/quality-security-agent.md | testes, regressão, evidências, threat model e scans | relatório de testes, findings e matriz AC | qualidade e segurança |
| .agents/infrastructure-agent.md | CI/CD, Terraform, MiniStack, observabilidade e rollback | workflow, plano, logs e runbook | operação |
| .agents/orchestrator.md | coordenação de staging, handoffs, smoke, dependências e go/no-go | checklist, decisão e pacote final | coordenação de release |

## 3. Agentes por fase

| Fase | Executor primário | Revisores obrigatórios | Aceite final |
|---|---|---|---|
| F0 | .agents/governance-agent.md + .agents/architecture-agent.md | .agents/orchestrator.md, .agents/backend-agent.md, .agents/database-agent.md, .agents/frontend-agent.md, .agents/quality-security-agent.md e .agents/infrastructure-agent.md | PO/LPO |
| F1 | .agents/backend-agent.md + .agents/database-agent.md + .agents/infrastructure-agent.md | .agents/architecture-agent.md e .agents/quality-security-agent.md | .agents/architecture-agent.md |
| F2 | .agents/backend-agent.md + .agents/frontend-agent.md | .agents/database-agent.md, .agents/architecture-agent.md e .agents/quality-security-agent.md | PO + .agents/quality-security-agent.md |
| F3 | .agents/backend-agent.md + .agents/frontend-agent.md + .agents/database-agent.md | .agents/architecture-agent.md e .agents/quality-security-agent.md | PO |
| F4 | .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md | .agents/architecture-agent.md e .agents/quality-security-agent.md | PO + .agents/quality-security-agent.md |
| F5 | .agents/frontend-agent.md + .agents/backend-agent.md | .agents/quality-security-agent.md e .agents/infrastructure-agent.md | PO |
| F6 | .agents/quality-security-agent.md + .agents/infrastructure-agent.md + .agents/orchestrator.md | .agents/governance-agent.md, .agents/architecture-agent.md, .agents/backend-agent.md, .agents/database-agent.md, .agents/frontend-agent.md e PO/LPO | Go/no-go do PO/LPO |

## 4. Protocolo de execução de cada etapa

### Entrada

- issue pronta com objetivo, escopo, critérios de aceite e dependências;
- SPEC ou referência normativa identificada;
- branch criada a partir da base de integração;
- dados e contrato necessários disponíveis;
- estratégia de teste definida.

### Execução

1. implementar a menor fatia vertical funcional;
2. adicionar teste próximo do comportamento;
3. atualizar contrato e documentação;
4. executar validações locais;
5. anexar evidências ao PR;
6. solicitar revisão técnica e funcional.

### Saída

- PR aprovado e integrado;
- teste automatizado reproduzível;
- evidência versionada;
- métrica de aceite registrada;
- risco residual e follow-up, se houver;
- atualização da matriz de rastreabilidade.

## 5. Regras de branch e integração

- `origin/develop` é a base de integração enquanto `main` ainda contiver apenas bootstrap;
- não fazer merge em lote de branches que misturam domínios sem revisão;
- escolher um PR canônico quando existirem branches duplicadas;
- rebase/merge de `develop` na branch somente antes da revisão final;
- `main` recebe somente incrementos que passam o gate correspondente;
- branch não integrada não conta como funcionalidade entregue;
- documentação sem código e teste deve ser marcada como evidência documental, nunca como aceite de produto.

## 6. Cadência e cerimônias

| Cerimônia | Frequência | Participantes | Saída |
|---|---|---|---|
| Triagem de bloqueios | diária | .agents/orchestrator.md e agentes executores da task | impedimentos atualizados |
| Integração técnica | 2x por semana | .agents/architecture-agent.md, .agents/orchestrator.md, .agents/backend-agent.md, .agents/database-agent.md, .agents/frontend-agent.md, .agents/infrastructure-agent.md e .agents/quality-security-agent.md | conflitos e contratos resolvidos |
| Demonstração | fim de cada subfase | squads + PO | aceite/devolução funcional |
| Revisão de risco | semanal | LPO, .agents/governance-agent.md, .agents/quality-security-agent.md e .agents/infrastructure-agent.md | riscos com owner e prazo |
| Go/no-go | fim da F6 | .agents/orchestrator.md, PO/LPO, .agents/quality-security-agent.md, .agents/infrastructure-agent.md e .agents/governance-agent.md | decisão registrada |

## 7. Definition of Done operacional

Uma etapa não é Done se faltar qualquer item abaixo:

- código integrado na base correta;
- teste automatizado adequado ao risco;
- lint/build/scan aplicáveis aprovados;
- contrato e migration atualizados;
- evidência de aceite anexada;
- revisão técnica e funcional concluída;
- documentação/runbook atualizado;
- rollback ou mitigação definida quando houver impacto operacional;
- aceite do PO quando a mudança alterar comportamento do produto.
