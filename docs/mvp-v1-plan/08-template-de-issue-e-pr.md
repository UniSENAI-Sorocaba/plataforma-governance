# 08 — Template de Issue e Pull Request

## Template de Issue

```markdown
# [TASK-ID] Nome curto da task

## Objetivo
Descreva o resultado observável que precisa existir ao final.

## Referências
- Backlog:
- SPEC/ADR:
- Must Have:
- Dependências:

## Escopo de implementação
- [ ] item técnico 1
- [ ] item técnico 2
- [ ] item funcional 3

## Fora do escopo
- comportamento não incluído nesta task;
- melhoria futura;
- integração que depende de outra task.

## Agentes
- Executor: caminho de um arquivo em `.agents/`, por exemplo `.agents/backend-agent.md`
- Revisor técnico: caminho de um arquivo em `.agents/`
- Revisor de segurança/qualidade: `.agents/quality-security-agent.md`
- Aceite funcional: PO/LPO ou agente explicitamente indicado pela task

## Testes obrigatórios
- comando/unitário:
- integração/API:
- contrato:
- E2E:
- segurança/performance:

## Validações manuais
- cenário feliz:
- cenário de erro:
- autorização/privacidade:
- acessibilidade/UX:

## Métricas de aceite
- métrica:
- meta:
- valor observado:

## Evidências esperadas
- link do PR:
- commit integrado:
- relatório de teste:
- screenshot/trace/log:

## Riscos e rollback
- risco:
- mitigação:
- rollback:

## Critério de Done
- [ ] código integrado
- [ ] testes verdes
- [ ] evidências anexadas
- [ ] revisão concluída
- [ ] matriz de rastreabilidade atualizada
```

## Template de Pull Request

```markdown
## Task
[TASK-ID] — [nome]

## O que foi implementado
- mudança 1
- mudança 2

## Como validar
```bash
# comandos reproduzíveis
```

## Testes executados
- [ ] unitário
- [ ] integração/API
- [ ] contrato
- [ ] E2E
- [ ] segurança
- [ ] performance

## Evidências
- relatório:
- screenshot/trace:
- métrica:

## Impacto e compatibilidade
- API:
- banco/migration:
- frontend:
- infraestrutura:

## Riscos e rollback
- risco:
- rollback:

## Revisores
- técnico:
- Quality/Security: `.agents/quality-security-agent.md`
- Infrastructure: `.agents/infrastructure-agent.md`
- PO, quando aplicável:
```

## Regras de abertura

- uma Issue deve representar uma unidade vertical ou uma mudança técnica claramente isolada;
- PRs que misturam backend, frontend, banco e infraestrutura devem justificar a integração conjunta;
- toda migration deve vir com validação de banco limpo e upgrade;
- toda rota protegida deve vir com teste 401/403;
- toda alteração pública deve vir com teste de privacidade;
- toda mudança de release deve atualizar evidência e rollback.
