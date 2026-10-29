---
kind: sprint-acceptance-package
status: Draft
owner: Fellipe Raszejas
technical_owners: [Backend, Database, Quality, Cloud & DevOps, Frontend]
approval: []
sprint: S5
epics: []
canonical_specs: [SPEC-AUTH-001, SPEC-AUTH-002, SPEC-AUTH-003, SPEC-PI-001, SPEC-PI-002, SPEC-PI-003, SPEC-PI-004, SPEC-EXT-001, SPEC-EXT-002, SPEC-PORTAL-001, SPEC-PORTAL-002]
source_of_truth: ../product/official-validation-decisions.md
---

# Sprint 5 — Confiabilidade, segurança e desempenho

## Natureza deste pacote

S5 é transversal e predominantemente técnico. Este documento registra critérios de produto/aceitação sobre a qualidade do MVP; não cria um novo EPIC de negócio, não introduz endpoints e não substitui critérios funcionais das SPECs por domínio.

## Resultado esperado

Os fluxos aprovados das sprints anteriores atendem ao alvo de carga, mantêm dados protegidos, recuperam-se de falhas operacionais conforme metas aprovadas e deixam riscos residuais visíveis para decisão de release.

## Critérios de aceite propostos

- AC-S5-01 — Carga: a suite reproduzível de QA-024 executa o alvo registrado de 200 RPS e p95 ≤ 500 ms. O relatório identifica perfil de carga, duração, ambiente, conjunto de dados, taxa de erro e recursos medidos. Não alegar aprovação a partir de uma execução sem esses dados.
- AC-S5-02 — Escopo da carga: os fluxos e proporções de leitura/escrita usados no k6 são escolhidos com Produto, Backend e QA e representam jornadas liberadas; valores não definidos são registrados como hipótese de teste.
- AC-S5-03 — Segurança: SAST, SCA, análise de container e IaC não deixam finding High/Critical sem correção ou aceite formal de risco com owner, justificativa e prazo.
- AC-S5-04 — ZAP: varredura do ambiente aprovado não deixa finding High/Critical sem correção ou aceite formal. Ambiente/credenciais de teste e fronteira pública devem ser registrados; não presumir staging AWS, que não está confirmado no plano atual.
- AC-S5-05 — Backup e restauração do banco: uma restauração isolada demonstra integridade e tempos medidos; o critério RPO/RTO só pode ser marcado aprovado depois de Produto/Operações definirem os limites aceitáveis.
- AC-S5-06 — Separação de dados: backup/restore do PostgreSQL não altera a decisão específica sobre retenção de arquivos de projeto; esta não autoriza apagar nem duplicar os objetos de projeto.
- AC-S5-07 — Evidência de desempenho: consultas lentas e pool são avaliados com evidência, e toda mudança de índice/pool tem comparação antes/depois sem degradar integridade.
- AC-S5-08 — Regressão: os cenários funcionais já aprovados continuam passando; testes não podem reintroduzir bancas, convites individuais, OIDC como login do MVP ou históricos de horas/notas.
- AC-S5-09 — Auditoria e logs: não criar trilha de auditoria de negócio incompatível com o Caderno. Logs técnicos não registram senhas, tokens nem segredos.
- AC-S5-10 — Evidência: cada resultado aponta commit, workflow/ambiente, horário, ferramenta/versão, saída, severidade, limitações e responsável pelo aceite.

## Dependências e contratos

- Backend: BE-021 (findings), endpoints já aprovados e BE-020 (cobertura contínua).
- Database: DB-017/018/019.
- Qualidade: QA-023/024/025/026/027.
- Cloud: INF-016/017/018.
- Frontend: FE-021.
- Contratos de API não são entregável novo de S5; qualquer mudança de rota/schema deve alterar o contrato OpenAPI e passar compatibilidade antes de merge.
- Não introduzir regra de negócio para satisfazer benchmark ou scanner.

## Decisões pendentes do PO / Operações

1. Definir jornadas, distribuição de requisições e dados de referência para o teste de 200 RPS.
2. Definir RPO/RTO aceitáveis e a instância/ambiente autorizado para restore.
3. Confirmar alvo de ZAP e quais exceções de segurança exigem aceite e de qual autoridade.
4. Priorizar riscos residuais que possam impedir uso do MVP.
5. A meta 200 RPS/p95 ≤ 500 ms vem da QA-024; qualquer mudança é uma decisão explícita, não suposição desta SPEC.

## Rastreabilidade

Issues BE-020/021; DB-016/017/018/019; QA-023/024/025/026/027; FE-021; INF-016/017/018; SPECs e contratos das jornadas efetivamente integradas.

## Histórico

- Draft preparado para validação de Produto e owners técnicos; não aprovado e não normativo até revisão.
