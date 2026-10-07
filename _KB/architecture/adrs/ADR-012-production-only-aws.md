---
id: ADR-012
status: Accepted
date: 2026-10-07
owners: [Cloud & DevOps]
---

# ADR-012 — Somente o ambiente de produção na AWS

## Status
Accepted

## Context
A POL-INFRA-004 fixa o orçamento da AWS em US$ 120 por mês. A estimativa de custos de 2026-10-05 (preços on-demand de us-east-1) mostrou que:

- a arquitetura com alta disponibilidade completa e staging permanente custaria cerca de US$ 337 por mês;
- mesmo otimizada e seguindo os ADRs literalmente, ficaria em cerca de US$ 197 por mês;
- com staging efêmero na AWS, chegaria a cerca de US$ 97 por mês, mas exigiria automação para criar e destruir o ambiente, disciplina para não deixá-lo ligado e manteria uma segunda superfície de ataque na nuvem.

A maior parte do custo de um ambiente vem de componentes cobrados por hora de existência (load balancer, NAT, banco de dados e endereços IPv4 públicos), e não do uso. Cada ambiente adicional na AWS repete esse custo fixo.

O ADR-011 exige que produção seja isolada de non-production. O ADR-002 prevê uma instância RDS Multi-AZ, o que só cabe no orçamento se o custo fixo de outros ambientes for eliminado.

## Decision
Apenas o ambiente `production` existe na AWS, em uma conta dedicada, na região us-east-1. O papel de staging passa a ser cumprido fora da AWS:

1. **Development:** na máquina de cada desenvolvedor, com Docker Compose e o emulador MiniStack.
2. **Validação efêmera:** criada dentro do job do GitHub Actions a cada execução, com a imagem recém-construída (o mesmo digest que será publicado), PostgreSQL 16 em container, MiniStack para S3 e Secrets Manager, migrations e seeds sintéticos. Executa smoke, testes de contrato, E2E, DAST de base e carga em escala reduzida, e é destruída ao fim do job.
3. **Produção pré-go-live:** até o go-live (INF-019), a conta de produção não contém usuários nem dados reais e é usada como ambiente de integração, inclusive para o teste de carga (QA-024, INF-017), o ensaio de rollback (INF-018) e o primeiro ensaio de restore (INF-016).
4. **Produção após o go-live:** deploy somente com go/no-go registrado; testes de carga apenas em janela controlada e comunicada; ensaios de restore em instância temporária dentro da própria conta de produção, destruída ao final, sem que dados pessoais saiam da conta.

O artefato promovido a produção continua sendo a mesma imagem, identificada pelo digest, que passou pela validação efêmera.

## Alternatives Considered
1. **Staging permanente na AWS:** rejeitado. Custo de US$ 76 a US$ 148 por mês apenas para staging, incompatível com o orçamento.
2. **Staging efêmero na AWS:** rejeitado. Cabe no orçamento, mas obriga produção a abrir mão de Multi-AZ, depende de automação adicional e mantém credenciais e recursos de non-production na nuvem.
3. **Development e staging em uma conta AWS compartilhada:** rejeitado pelo mesmo custo fixo e por não acrescentar validação que o ambiente efêmero não cubra.

## Consequences
* **Positivas:**
  * Custo estimado entre US$ 77 e US$ 91 por mês, conforme a variante de rede e banco, com folga para controles de segurança (CloudTrail, GuardDuty, KMS e, opcionalmente, WAF).
  * Viabiliza RDS Multi-AZ em produção, conforme o ADR-002.
  * Isolamento de produção garantido por construção (ADR-011): não há non-production na AWS, nem credenciais de nuvem para non-production.
  * Ambientes de teste reproduzíveis e descartáveis a cada execução, sem dados reais.
* **Negativas:**
  * Diferenças entre o emulador e a AWS (IAM, rede real, atributos não suportados) só aparecem em produção. Mitigação: o período pré-go-live funciona como homologação na AWS real, e mudanças de infraestrutura após o go-live passam por `plan` revisado.
  * Testes de carga em containers do runner não representam o dimensionamento real do Fargate; a evidência definitiva de desempenho é obtida em produção antes do go-live.
  * A validação efêmera consome minutos do GitHub Actions (2.000 por mês para a organização no plano Free com repositórios privados), o que exige filtros de caminho, cancelamento de execuções concorrentes e acompanhamento do consumo.
  * Após o go-live, não há ambiente na AWS para ensaios destrutivos; eles exigem janela de manutenção ou recursos temporários na própria conta.

## Documentos atualizados
- `_KB/architecture/deployment.md`
- RUNBOOK-INFRA-002 (`_KB/operations/runbooks/deployment.md`)
- POL-INFRA-002, POL-INFRA-003 e POL-INFRA-004
- Notas nos ADR-004 e ADR-011
- `GITHUB_CONFIGURATION.md`, seção 9
- `backlogs/cloud-devops.md` (INF-009, INF-016 e INF-019)

Permanecem para as equipes responsáveis: QA-019 e QA-026 (`backlogs/quality-security.md`), DB-018 (`backlogs/database.md`), risco R03 (`_KB/governance/risks.md`) e a definição de DAST no glossário (`_KB/product/glossary.md`).

## Related Documents
- [ADR-002 — Persistência com isolamento de schemas](ADR-002-postgresql-schema-isolation.md)
- [ADR-004 — AWS ECS Fargate](ADR-004-aws-ecs-fargate-platform.md)
- [ADR-011 — Isolamento de ambientes AWS](ADR-011-environment-isolation.md)
- [FinOps (POL-INFRA-004)](../../operations/finops.md)
- [Material de apoio: custos e FinOps](../../operations/guides/cloud-devops/09-custos-e-finops.md)
