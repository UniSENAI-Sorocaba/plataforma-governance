---
kind: release-acceptance-package
status: Draft
owner: Fellipe Raszejas
co_owners: [Luciano Menezes Júnior, Gabriel Ribeiro de Camargo Miranda, Felipe Marques]
approval: []
sprint: S6
epics: []
canonical_specs: []
source_of_truth: ../../product/official-validation-decisions.md
---

# Sprint 6 — Homologação, escopo de release e go/no-go

## Natureza deste pacote

S6 fecha um release: homologação, aceite, decisão de publicação e documentação operacional. Não é um EPIC de funcionalidade e não autoriza ampliar o MVP. Cada fluxo continua rastreado à SPEC/EPIC de produto que o originou.

## Resultado esperado

A equipe apresenta evidência verificável das jornadas aprovadas, a lista do que entra e do que fica fora do release, riscos aceitos com responsáveis e uma decisão registrada de go/no-go. Se go, há smoke test e plano de rollback; se no-go, os bloqueios têm owner e próximo passo.

## Critérios de aceite propostos

- AC-S6-01 — Escopo: release inclui apenas funcionalidades aprovadas e compatíveis com o Caderno. Escopo, exclusões e exceções estão registrados e aprovados antes do deploy.
- AC-S6-02 — Rastreabilidade: cada requisito Must Have/P0 no escopo aponta SPEC vigente, issue, PR integrado e evidência de aceite; issue fechada isoladamente não serve como evidência funcional.
- AC-S6-03 — Go/no-go: parecer reúne resultados de QA-028 e aprovações funcionais/de operação. Decisão, responsáveis, data, riscos aceitos e pendências ficam registrados.
- AC-S6-04 — Bloqueio: falha de critério P0, finding crítico sem aceite formal, ou ausência de artefato essencial impede marcar go; exceção exige autoridade, justificativa, owner e prazo explicitamente registrados.
- AC-S6-05 — Smoke: QA-029 executa jornadas e verificações de produção autorizadas após deploy, registra resultado e não expõe dados reais desnecessários.
- AC-S6-06 — Rollback: antes do deploy há gatilho observável para rollback, responsável de plantão, versão anterior recuperável e procedimento ensaiado; resultado do ensaio aponta INF-018/019/020.
- AC-S6-07 — Pós-deploy: smoke e decisão de manter/rollback são registrados; incidente ou falha aciona comunicação e runbook aprovado.
- AC-S6-08 — Pacote final: QA-030 reúne índice navegável, evidências, riscos aceitos e links para código/PRs, sem duplicar segredos, dados pessoais ou artefatos proibidos.
- AC-S6-09 — Runbooks: instruções de deploy, API, Frontend, banco, rollback e incidente são testadas por alguém diferente de seu autor ou registram claramente a limitação.
- AC-S6-10 — Regra de negócio: o release não contém banca/agenda, convite individual, login por provedor externo ou histórico de valores anteriores de horas/notas como comportamento do MVP.

## Responsabilidades para aprovação

- Fellipe Raszejas (PO): aceita escopo funcional e exclusões do release; fecha a lista de critérios pendentes de Produto.
- Luciano Menezes Júnior (LPO/PO Coach): desempata decisão global de visão/prioridade e registra exceções de escopo conforme governança.
- Gabriel Ribeiro de Camargo Miranda (líder de Qualidade): emite parecer de evidências, regressão e go/no-go técnico de qualidade.
- Felipe Marques (líder Cloud & DevOps): confirma prontidão operacional, deploy, smoke/rollback e riscos de infraestrutura.
- Leads de Backend, Frontend e Database confirmam suas evidências e limitações de domínio.
- Nenhuma pessoa ou squad deve converter seu próprio teste em aceite de Produto sem a aprovação indicada.

## Dependências

PG-017/018; QA-028/029/030; INF-019/020/021; BE-022; FE-022; DB-020; evidências integradas das SPECs e issues que entram no release.

## Decisões pendentes para validação

1. Autoridade final e quórum para go/no-go e para exceção de critério, alinhados a ownership/workflow aprovados.
2. Definir quais Must Haves/P0 são bloqueadores absolutos e formato de aceite de risco, sem contrariar política já aprovada.
3. Ambiente/janela do smoke, dados de teste e critérios exatos de rollback para cada classe de falha.
4. Política de retenção/localização do pacote final, respeitando privacidade e regras de dados.
5. Confirmar que todos os itens S3–S5 no release têm critérios aprovados e não estão bloqueados por lacuna de Produto.

## Rastreabilidade

PG-017/018; QA-028/029/030; INF-019/020/021; BE-022; FE-022; DB-020; Definition of Done/Ready; SPECs e Must Haves incluídos no escopo.

## Histórico

- Draft preparado para validação de PO, LPO, Qualidade e Operações; não aprovado e não normativo até revisão.
