# 06 — Matriz de Métricas, Aceite e Evidências

## 1. Métricas globais do MVP/V1

| Área | Métrica | Meta de aceite | Evidência obrigatória | Bloqueia release |
|---|---|---:|---|---|
| Funcional | Jornadas P0 completas | 100% | relatório E2E + vídeo/log quando necessário | Sim |
| Testes | Cobertura global | >= 75% | relatório versionado de cobertura | Sim |
| Backend | Erros 5xx em smoke | 0 | relatório de smoke | Sim |
| API | Contratos breaking | 0 não aprovados | resultado OpenAPI/contract test | Sim |
| Segurança | High/Critical sem tratamento | 0 | SAST/SCA/ZAP/container/IaC reports | Sim |
| Performance | Carga sustentada | 200 RPS | k6 report | Sim |
| Performance | p95 | <= 500 ms | k6/APM | Sim |
| Frontend | Lighthouse performance | >= 90 | relatório staging | Sim |
| Frontend | Lighthouse accessibility | >= 90 | relatório staging + auditoria manual | Sim |
| Frontend | Lighthouse SEO | >= 90 | relatório staging | Sim |
| Disponibilidade | Healthcheck | 100% no smoke | logs de execução | Sim |
| Operação | Rollback ensaiado | 1 execução aprovada | runbook + evidência | Sim |
| Banco | Migrations limpas | 100% | log de banco limpo | Sim |
| Banco | Upgrade incremental | 100% | log de upgrade | Sim |
| Privacidade | Dados privados no portal | 0 ocorrências | testes de catálogo + revisão | Sim |
| Logs técnicos | Correlation ID e ausência de dados sensíveis | 100% das jornadas instrumentadas | logs sanitizados + smoke | Sim |

## 2. Métricas por domínio

### IAM

- login válido: sucesso em 100% dos casos válidos;
- credencial inválida: 100% rejeitada;
- refresh reuse: 100% rejeitado;
- rotas protegidas: 100% com teste 401/403;
- vazamento de token/senha em logs: zero;
- logs técnicos de login, logout, reset e autorização sem segredos: 100%.

### Projetos e equipes

- transições válidas: 100% aceitas;
- transições inválidas: 100% rejeitadas;
- solicitação duplicada: zero duplicidade criada;
- concorrência em aceite/remoção: zero estado inconsistente;
- upload inválido: 100% rejeitado;
- acesso indevido a arquivo: 100% bloqueado.

### Extensão, avaliação e certificados

- total de horas: 100% reproduzível;
- cálculo de nota: determinístico em 100% dos fixtures;
- vínculo/autorização de avaliador inválidos: 100% bloqueados;
- certificado adulterado: 100% detectado;
- certificado revogado: 100% identificado.

### Portal

- filtros e paginação: 100% dos casos de contrato;
- conteúdo não publicado exposto: zero;
- páginas críticas SSR: 100%;
- navegação por teclado: 100% das jornadas críticas;
- URLs canônicas e sitemap: válidos em 100% das páginas públicas.

## 3. Evidência mínima por item

Cada item P0 deve possuir uma linha com:

| Campo | Conteúdo |
|---|---|
| ID | Backlog ID e issue |
| SPEC | especificação normativa |
| PR | pull request integrado e commit |
| Código | arquivos ou módulo principal |
| Teste | comando e resultado |
| Aceite | métrica observada e valor |
| Evidência | log, screenshot, relatório ou fixture |
| Revisor | agente e data |
| Risco | risco residual, owner e prazo |

## 4. Severidade e decisão

| Severidade | Regra |
|---|---|
| Blocker/P0 | impede merge ou release; exige correção antes do avanço |
| High | bloqueia V1, salvo aceite formal com mitigação e prazo |
| Medium | pode entrar com owner e prazo antes do próximo gate |
| Low | backlog priorizado, sem bloquear MVP |

## 5. Template de registro de aceite

```markdown
## [ID] — [nome]

- Fase/subfase:
- Executor:
- Revisor: caminho do agente em `.agents/` e data
- SPEC:
- PR/commit integrado:
- Comando de validação:
- Resultado observado:
- Métrica/meta:
- Evidência:
- Riscos residuais:
- Decisão: PASS | PASS WITH RISK | FAIL
- Data:
```

## 6. Gate de passagem

Uma fase passa quando:

1. todos os critérios obrigatórios estão `PASS`;
2. nenhum blocker/P0 permanece aberto;
3. métricas estão acompanhadas de evidência reproduzível;
4. dependências da próxima fase estão liberadas;
5. o revisor registra a decisão;
6. o PO aceita o comportamento quando houver impacto no produto.
