# Plano de Reorganização da Knowledge Base

> Status: **Approved and Implemented**
>
> Aprovação explícita: 2026-09-10
>
> Resultado da execução: `_KB_MIGRATION_REPORT.md`
>
> Escopo desta versão: auditoria dos 79 arquivos Markdown existentes em `_KB/`, análise complementar de `new_teams.md` como fonte externa de composição organizacional e proposta de migração. Nenhum arquivo da `_KB` foi movido, renomeado, consolidado ou reclassificado nesta etapa.
>
> Data da auditoria: 2026-09-09

## 1. Executive Summary

A `_KB` atual tem boa cobertura temática, links relativos íntegros e cinco ADRs já identificados, mas ainda funciona como documentação de um monorepo e de uma estrutura organizacional anterior. Ela não possui requisitos, specifications, Must Haves ou contratos globais com IDs próprios; mistura definição normativa com estado operacional; e atribui muitas decisões a pessoas e papéis que foram substituídos pela composição de equipes fornecida para esta auditoria.

Recomenda-se manter um repositório dedicado de governança, com publicação versionada consumida pelos repositórios de implementação. A separação multi-repo é adequada para ownership e pipelines independentes, desde que contratos e versões aprovadas da governança sejam distribuídos de modo determinístico. A decisão conflita com o ADR-005 vigente e, portanto, exige novo ADR que o substitua; não deve ser aplicada silenciosamente.

A migração deve preservar o conteúdo atual, declarar conflitos, introduzir tipos documentais e IDs estáveis, separar fontes normativas de fontes operacionais e só então arquivar documentos superados. Este plano propõe uma taxonomia rasa, cinco níveis de governança e um harness de conformidade que usa uma referência remota aprovada e verificações determinísticas antes de análise por agente.

## 2. Current State

### Inventário

Foram analisados recursivamente 79 arquivos Markdown, totalizando aproximadamente 232 KB:

| Área atual | Quantidade | Classificação predominante | Observação |
| --- | ---: | --- | --- |
| `00-index` | 4 | Project Context, Glossary, Navigation | Índice manual e registro de conflitos misturam decisões aceitas e abertas. |
| `01-product` | 6 | Product, Requirements, Business Rules | Visão, escopo, personas, módulos e MVP contêm requisitos implícitos sem IDs. |
| `02-planning` | 9 | Planning, Product, Operations | Backlog e histórias são simultaneamente definição e estado operacional. |
| `03-architecture` | 12 | Architecture, Database, Security, ADR | Sete visões arquiteturais e cinco ADRs; DDL e detalhes comportamentais estão embutidos. |
| `04-development` | 9 | Engineering Standards, Development Process | Setup, Git, PR, API, banco e testes; parte é normativa. |
| `05-security` | 8 | Security, Architecture, Business Rules | Regras fortes existem apenas em prosa/checklists, sem Must Haves. |
| `06-infrastructure` | 7 | Infrastructure, Operations | Mistura arquitetura desejada, exemplos Terraform e detalhes operacionais. |
| `07-devops` | 6 | CI/CD, Observability, FinOps, Operations | Estratégias e procedimentos se sobrepõem aos runbooks. |
| `08-quality` | 7 | Quality, Testing | Metas divergentes de cobertura e latência. |
| `09-governance` | 7 | Squads, Responsibilities, Process | Estrutura de quatro squads e lideranças anteriores está obsoleta frente ao dado fornecido. |
| `10-runbooks` | 5 | Operations, Runbooks | Deploy, rollback e setup duplicam parcialmente documentos de engenharia. |

Todos os arquivos possuem conteúdo legível e nenhum link relativo quebrado foi encontrado. Não há arquivos idênticos por hash. Os cinco ADRs são os únicos documentos sem front matter. Quase todos os demais têm `status`, `owner` e `last_updated`, mas o vocabulário e a autoridade desses campos não estão formalizados.

Também foi analisado `new_teams.md`, localizado fora da `_KB`. Por decisão explícita do responsável pelo projeto em 2026-09-09, ele é a fonte de verdade vigente para composição e liderança das cinco equipes. Na migração, seu conteúdo normativo será promovido para `_KB/governance/squads.md`; contatos e justificativas continuarão classificados como dados complementares. A ausência atual de front matter e histórico formal deve ser corrigida sem alterar suas definições.

### Conteúdo relevante identificado

- Produto: plataforma integrada para extensão, projetos integradores, identidade e portal público; patrimônio, carreiras, iniciação científica e CPA/ouvidoria aparecem como fase futura.
- Arquitetura: monólito modular Node.js/TypeScript/NestJS, PostgreSQL 16 com schemas, SSO/OIDC/JWT RS256, AWS ECS Fargate e monorepo Turborepo/pnpm.
- Planejamento: épicos `EP01` a `EP08`, histórias `US01` a `US18`, sprints 0 a 6 e release acadêmica originalmente prevista para 2026.2.
- Contratos: DTOs TypeScript/Zod, OpenAPI gerado, Orval e DDL aparecem em prosa, mas não há catálogo de contratos versionados.
- Segurança: Argon2id, refresh tokens opacos, RBAC, Secrets Manager, Gitleaks, SAST/DAST e controles OWASP.
- Operações: AWS, Terraform, CI/CD, observabilidade, FinOps, deploy, rollback, incidentes e disaster recovery.
- Governança: DoR, DoD, RACI, cerimônias e papéis, atualmente vinculados à organização antiga.

## 3. Problems Found

### Duplicações semânticas

- Setup local: `04-development/setup.md` e `10-runbooks/local-development.md`.
- Deploy: `07-devops/deployment.md` e `10-runbooks/deployment.md`.
- Rollback: `07-devops/rollback.md` e `10-runbooks/rollback.md`.
- Estratégia de testes: `04-development/testing-guidelines.md` e arquivos de `08-quality/`.
- Arquitetura e controles de autenticação: `03-architecture/security-architecture.md`, `05-security/authentication.md`, `05-security/sso.md` e ADR-003.
- Arquitetura AWS/rede: `03-architecture/diagrams.md`, `06-infrastructure/overview.md`, `aws.md` e `networking.md`.
- Estado/escopo do produto: `01-product/mvp.md`, `02-planning/backlog.md`, `roadmap.md`, `release-plan.md` e `sprint-plan.md`.

### Documentos provavelmente obsoletos

- `09-governance/team-structure.md`, `responsibilities.md` e `raci.md`: atualizar após aprovação, mantendo a versão anterior arquivada.
- `02-planning/roadmap.md`, `release-plan.md` e `sprint-plan.md`: datas e sprints de 2026.2 devem ser verificadas; se encerradas, arquivar como baseline histórica.
- `03-architecture/adr/ADR-005-monorepo-tooling.md`: continua `Accepted`, mas conflita com a direção multi-repo; requer ADR substituto antes de mudar.
- Referências nominais antigas espalhadas por arquitetura, segurança, infraestrutura, DevOps, qualidade e runbooks: atualizar ownership após matriz oficial aprovada.

### Informações sem autoridade clara

- Regras de negócio de notas, horas, certificados, publicação e auditoria aparecem em histórias, DDL e testes sem Requirement/SPEC canônica.
- Valores como 15 minutos de token, 200 RPS, retenção de 7/14 dias e teto mensal de USD 120 estão marcados como aceitos sem evidência de aprovação identificável.
- DDL de `data-architecture.md` parece prescritivo, mas não é contrato versionado nem migration executável.
- OpenAPI é descrito como gerado pela implementação, o que pode inverter a autoridade do contrato.
- `open-issues.md` registra “decisões adotadas” sem mecanismo explícito de aprovação ou histórico.

### Mistura de conceitos

- `02-planning` mantém definição de produto, decomposição de trabalho e estado temporal no mesmo conjunto.
- `data-architecture.md` combina visão arquitetural, contrato de dados e SQL inicial.
- documentos de segurança combinam arquitetura, políticas obrigatórias e tutoriais de implementação.
- documentos de DevOps combinam estratégia declarativa e runbook executável.
- o README classifica planning como normativo/operacional, sem indicar qual seção tem precedência.

## 4. Contradictions

| ID provisório | Conflito | Evidência | Tratamento |
| --- | --- | --- | --- |
| CONFLICT-001 | Monorepo aceito vs. arquitetura multi-repo desejada | ADR-005 e `repository-structure.md` vs. novo contexto | `DECISION REQUIRED`: manter ADR-005 até ADR substituto ser aceito. |
| CONFLICT-002 | Quatro squads multifuncionais vs. cinco frentes funcionais fornecidas | `team-structure.md` vs. composição desta tarefa | Nova composição é a entrada mais recente; arquivar baseline antiga após aprovação. |
| CONFLICT-003 | Cobertura global mínima de 75% vs. 80% | `metrics.md`, `github-actions.md`, `unit-tests.md` vs. `strategy.md` e DoD | `DECISION REQUIRED`; CI deve ter uma única regra executável. |
| CONFLICT-004 | Meta p95 abaixo de 500 ms, 600 ms ou alarme acima de 800 ms | `metrics.md`, `performance.md`, `strategy.md`, `observability.md` | Separar SLO, critério de teste e limiar de alerta; PO/tech leads aprovam os valores. |
| CONFLICT-005 | ADR-001 `Accepted` usa NestJS, enquanto `open-issues.md` diz NestJS vs. Fastify `Proposed` | ADR-001 e open issues | Confirmar decisão; corrigir estado sem alterar a decisão silenciosamente. |
| CONFLICT-006 | Papéis/owners antigos vs. lideranças atuais fornecidas | vários arquivos citam Luciano Jr, Marco, Nicolas Leão, Fazano e Nicolle | Substituir somente após matriz de autoridade aprovada; preservar histórico. |
| CONFLICT-007 | “Todo código” com cobertura de 75%, domínio 80%, core 85% | documentos de qualidade e DoD | Criar política única com escopos explícitos. |
| CONFLICT-008 | GitHub Flow modificado vs. runbook de release com branch `release/*` e merge direto | `branching-strategy.md`, `git.md`, `10-runbooks/deployment.md` | Revisar fluxo e branch protection; o runbook não pode contrariar a política. |
| CONFLICT-009 | Frontend Next.js com SSR, mas deploy descrito como assets em S3/CloudFront | `application-architecture.md` vs. `07-devops/deployment.md` | `OPEN QUESTION`: definir runtime do SSR ou limitar o portal a export estático. |
| CONFLICT-010 | Um RDS para staging+produção estimado em FinOps vs. isolamento de ambientes descrito em infraestrutura | `finops.md`, `environments.md`, ADR-002 | Confirmar topologia e custo real antes de tornar normativo. |
| CONFLICT-012 | A KB vigente declara 25 integrantes; a nova composição lista 34 pessoas (9+7+6+6+6) | `09-governance/team-structure.md` vs. `new_teams.md` | Resolvido em favor de `new_teams.md`: 34 é a composição vigente; 25 permanece apenas como baseline histórica. |

CONFLICT-011 foi resolvido em 2026-09-09: **José Eduardo de Oliveira Junior é o Líder Técnico de Cloud & DevOps**. A indicação divergente de “referência técnica” na seção final de `new_teams.md` deve ser corrigida durante a migração.

## 5. Proposed Governance Model

O repositório de governança deve ser separado dos repositórios de implementação. Ele publica baselines imutáveis (tag ou commit SHA) e artefatos machine-readable. Cada PR de código declara a baseline usada. Mudanças normativas nunca são geradas a partir do código.

| Nível | Regra | Conteúdo |
| --- | --- | --- |
| Level 0 — Core protected | Mudança excepcional, PR, PO e revisão técnica quando aplicável | princípios de autoridade, política de não reescrita de specs, esquema global de IDs, processo de mudança normativa |
| Level 1 — Product authority | PR + aprovação explícita do PO | visão, escopo, requirements, specs aprovadas, regras de negócio, Must Haves de negócio/compliance |
| Level 2 — Technical authority | PR + owner técnico; PO também quando afetar produto/escopo | arquitetura, ADRs, contratos, segurança, qualidade e standards globais |
| Level 3 — Squad maintained | PR + líder/referência da área | guias técnicos, runbooks, exemplos, instruções específicas de repositório |
| Level 4 — Generated | CI gera; edição manual proibida | índices, mapa de repositórios/squads, rastreabilidade derivada, status de implementação, changelog |

O PO não deve aprovar cada ajuste técnico. Sua aprovação é obrigatória quando muda comportamento de produto, escopo, regra de negócio ou compromisso normativo. ADRs e contratos puramente técnicos ficam em Level 2; se alterarem comportamento observável ou requisito, exigem também PO.

## 6. Source of Truth Model

| Informação | Fonte de verdade | Observação |
| --- | --- | --- |
| Visão, escopo, Requirement, SPEC, regra de negócio e Must Have | governance repo `_KB` | somente baseline aprovada |
| ADR e arquitetura global | governance repo `_KB` | aprovação técnica; PO quando houver impacto de produto |
| API/event/data contract global | arquivo machine-readable em `_KB/contracts` | código gerado/validado contra ele |
| Estado e prioridade da task | GitHub Project | não replicar manualmente em Markdown |
| Descrição, owner e vínculos da task | GitHub Issue | contém IDs globais |
| Código e migrations | repositório de implementação | Git registra histórico |
| CI e evidência de testes | plataforma CI/CD | links derivados no índice de rastreabilidade |
| Discussão de implementação | PR/Issue | decisões duráveis viram ADR/SPEC por PR separado |
| Composição e liderança das equipes | `new_teams.md` durante a transição; depois `_KB/governance/squads.md` | decisão vigente; `squad-map.json` será derivado |
| Status de implementação/release | GitHub Projects/Releases | índices na KB são gerados |

## 7. Proposed Directory Tree

```text
_KB/
├── README.md
├── governance/
│   ├── governance-levels.md
│   ├── source-of-truth.md
│   ├── ownership.md
│   ├── squads.md
│   ├── responsibilities.md
│   ├── workflow.md
│   ├── definition-of-ready.md
│   └── definition-of-done.md
├── product/
│   ├── vision.md
│   ├── scope.md
│   ├── personas.md
│   ├── glossary.md
│   └── epics.md
├── requirements/
├── specs/
├── must-haves/
│   ├── security.md
│   ├── architecture.md
│   ├── data.md
│   ├── business.md
│   ├── quality.md
│   └── infrastructure.md
├── architecture/
│   ├── system-context.md
│   ├── containers.md
│   ├── components.md
│   ├── data-flow.md
│   ├── security.md
│   ├── deployment.md
│   └── adrs/
├── contracts/
│   ├── api/
│   ├── data/
│   └── events/
├── engineering/
│   ├── standards.md
│   ├── git-and-pr.md
│   ├── testing.md
│   ├── ci-cd.md
│   └── observability.md
├── security/
├── operations/
│   ├── infrastructure.md
│   ├── finops.md
│   └── runbooks/
├── agents/
│   ├── roles/
│   ├── skills/
│   ├── policies/
│   ├── workflows/
│   └── templates/
├── traceability/
│   └── generated/
└── archive/
```

A árvore é intencionalmente rasa. Pastas vazias só devem ser criadas quando receberem um artefato aprovado.

## 8. Document Types

| Tipo | ID | Função | Estado documental |
| --- | --- | --- | --- |
| Epic | `EPIC-<DOM>-NNN` | resultado amplo de produto; não representa estado de execução | Draft, Approved, Deprecated |
| Requirement | `REQ-<DOM>-NNN` | necessidade verificável e sua origem | Draft, Approved, Deprecated, Superseded |
| Specification | `SPEC-<DOM>-NNN` | comportamento esperado e critérios de aceite | Draft, Review, Approved, Deprecated, Superseded |
| Business Rule | `BR-<DOM>-NNN` | regra de negócio reutilizada por specs | Draft, Approved, Deprecated, Superseded |
| Must Have | `MH-<DOM>-NNN` | invariante que não pode ser violada | Draft, Approved, Deprecated, Superseded |
| ADR | `ADR-NNN` | contexto, decisão, alternativas e consequências | Proposed, Accepted, Deprecated, Superseded |
| Contract | `CONTRACT-<DOM>-NNN` | interface versionada entre produtores/consumidores | Draft, Approved, Deprecated, Superseded |
| Task | prefixo do repositório + número da Issue | unidade operacional no GitHub; não criar Markdown paralelo | estado no GitHub Project |
| Runbook | `RUNBOOK-<DOM>-NNN` quando necessário | procedimento operacional | Draft, Active, Deprecated |
| Policy | `POL-<DOM>-NNN` | regra organizacional/técnica obrigatória | Draft, Approved, Deprecated, Superseded |

## 9. ID Strategy

- IDs são globais, estáveis, maiúsculos e nunca reutilizados.
- Domínios iniciais: `AUTH`, `PI`, `EXT`, `PORTAL`, `SEC`, `DATA`, `ARCH`, `INFRA`, `QA`, `GOV`.
- Preservar `ADR-001` a `ADR-005`, `US01` a `US18` e `EP01` a `EP08` como aliases legados durante a migração.
- Novas Issues usam o identificador natural do repositório (`backend#43`) e um campo `Work ID` opcional (`BE-043`) somente se houver necessidade cross-board comprovada.
- Commits e PRs incluem pelo menos um ID de Issue e, quando aplicável, `SPEC-*`.
- Relações são declaradas no front matter dos documentos normativos e nos campos estruturados das Issues; `traceability.json` é derivado.

Fluxo: `EPIC → REQ → SPEC → {MH, ADR, CONTRACT} → Issue → Commit/PR → Test evidence`.

## 10. Squad Structure

A composição detalhada em `new_teams.md` é a fonte de verdade vigente e substitui a estrutura anterior. Durante a migração, essa autoridade será transferida para `_KB/governance/squads.md`, preservando `new_teams.md` como fonte de origem/histórico. José Eduardo de Oliveira Junior deve ser registrado como **Líder Técnico de Cloud & DevOps**.

A nova composição totaliza 34 pessoas: Backend 9, Frontend 7, Banco de Dados 6, Cloud & DevOps 6 e Qualidade/Testes/Segurança 6. Esse total substitui os 25 integrantes da baseline antiga, que será preservada somente como histórico.

| Frente | Líder | Referência técnica | Integrantes |
| --- | --- | --- | --- |
| Backend | VICTOR HUGO GEROTO TOLEDO | JOÃO VICTOR DE SOUZA SANTOS | PEDRO HENRIQUE DIAS DE PAULA SANTOS; ANA PAULA MAXIMO; CARLOS EDUARDO PEREIRA DE OLIVEIRA; JOHANN ARRUDA ANDRADE; LUCAS MIGUEL LEITE; MARCO ANTÔNIO DA COSTA SILVA; MATHEUS HENRIQUE KOOP BOFF |
| Frontend | FELIPE MARQUES | PAOLA DE OLIVEIRA | GIOVANI BERNARDO MIAMOTO SANTOS; SWELL GOMES NUNES; KAIQUE SILVA PRIMISSIA; NICOLAS RICARDO KOURANI LEÃO SILVA; JULIO CESAR BOTECCIO |
| Banco de Dados | ISABELLY CAROLINE MARTINS PARDIM | HENRIQUE MARCHETTI COUTINHO | DIOGO LOPES ANTUNES; ENZO GABRIEL TOMAS DE SOUZA; NICOLAS PUREZA DA SILVA; VINÍCIUS CÔRTE DA SILVA |
| Cloud & DevOps | JOSÉ EDUARDO DE OLIVEIRA JUNIOR (Líder Técnico) | O próprio líder técnico; referência adicional não definida | FELIPE NUNES RAMALHO; NICOLLE CAROLINA DA ROCHA; GABRIEL CAMARGO GONÇALVES SILVA; VITOR FAZANO; RYAN AMORIM CARVALHO |
| Qualidade, Testes & Segurança | GABRIEL RIBEIRO DE CAMARGO MIRANDA | GUSTAVO HENRIQUE GOUVEIA GOMES (Segurança/DevSecOps) | AHSLAM MENDES; BIANCA CIRILO; GUILHERME APARECIDO DE ARRUDA GARCIA; GUILHERME BUENO CAETANO |

### Dados complementares de `new_teams.md`

Os seguintes identificadores foram informados e devem ser confirmados antes de alimentar CODEOWNERS ou automações:

| Pessoa | Identificador informado | Grau de confiança no arquivo |
| --- | --- | --- |
| Victor Hugo Geroto Toledo | GitHub `victorgeroto` | informado |
| João Victor de Souza Santos | `joaovictorsz1230@gmail.com` | informado |
| Pedro Henrique Dias de Paula Santos | GitHub `PedroDias010` | informado |
| Ana Paula Maximo | GitHub `AnaPaulaMaximo` | informado |
| Carlos Eduardo Pereira de Oliveira | `c-eduardo94@hotmail.com` | informado |
| Johann Arruda Andrade | `johannarruda.dev2024@gmail.com` | informado |
| Matheus Henrique Koop Boff | GitHub `matheusboffz` | informado |
| Paola de Oliveira | `paola9liveira06@gmail.com` | informado |
| Giovani Bernardo Miamoto Santos | `giovanimiamoto24@gmail.com` | informado |
| Swell Gomes Nunes | `swellngsenai@gmail.com` | informado |
| Nicolas Ricardo Kourani Leão Silva | GitHub `Nicolas1xx` | informado |
| Julio Cesar Boteccio | provável GitHub `jwlioo` | não confirmado |
| Isabelly Caroline Martins Pardim | GitHub `Isabelly-Caroline` | informado |
| Henrique Marchetti Coutinho | `henriquemarchetticoutinho@gmail.com` | informado |
| Diogo Lopes Antunes | `diogolopesantunes@gmail.com` | informado |
| Nicolas Pureza da Silva | `nicolaspureza2005@gmail.com` | informado |
| Vinícius Côrte da Silva | `cortevinicius1@gmail.com` | informado |
| José Eduardo de Oliveira Junior | `jjeduardo.95@gmail.com` | informado |
| Felipe Nunes Ramalho | GitHub `FelipeNRamalho` | informado |
| Nicolle Carolina da Rocha | `nicollerocha.dev2024@gmail.com` | informado |
| Gabriel Camargo Gonçalves Silva | `gabrielcamargogsilva@gmail.com` | informado |
| Vitor Fazano | `vfazanodev@gmail.com`; GitHub `Vfazano` | informado |
| Ryan Amorim Carvalho | GitHub `Ry4nBR` | informado |
| Gustavo Henrique Gouveia Gomes | GitHub `GustavooGomess` | informado |
| Ahslam Mendes | GitHub `ahslammendes` | informado |
| Bianca Cirilo | GitHub `biancaciriloads` | informado |
| Guilherme Aparecido de Arruda Garcia | GitHub `GuilhermeAparecidoArruda` | informado |
| Guilherme Bueno Caetano | GitHub `guibuenoc` | informado |

Felipe Marques, Kaique Silva Primissia, Lucas Miguel Leite, Marco Antônio da Costa Silva, Enzo Gabriel Tomas de Souza e Gabriel Ribeiro de Camargo Miranda estão marcados no arquivo como não identificados com segurança. Esses dados ausentes não devem ser inferidos.

As justificativas de alocação de `new_teams.md` devem ser preservadas como contexto histórico de governança, com acesso compatível com dados pessoais, mas não incorporadas a `squads.md` como norma permanente. O documento canônico de squads deve registrar composição, papel, vigência e autoridade; preferências pessoais, experiência declarada e motivos de movimentação devem ficar em um registro de decisão/alocação arquivado ou de acesso restrito.

Movimentações explicitamente registradas: Victor Hugo (Frontend → líder Backend), Felipe Marques (Cloud → líder Frontend), Matheus Henrique Koop Boff (Frontend → Backend), Vitor Fazano (Backend → Cloud), Gabriel Camargo Gonçalves Silva (Qualidade → Cloud), Guilherme Bueno Caetano (Cloud → Qualidade) e Gustavo Henrique Gouveia Gomes (Cloud → Qualidade/Segurança).

`DECISION REQUIRED`: confirmar apenas se essas equipes atuarão como squads permanentes ou também como capítulos funcionais em iniciativas multifuncionais. Essa questão não altera composição ou liderança.

## 11. Spec Strategy

Cada SPEC deve ter front matter machine-readable com `id`, `status`, `owner`, `approval`, `epics`, `requirements`, `must_haves`, `contracts`, `affected_systems` e `supersedes`. O corpo usa somente seções aplicáveis: Context, Objective, Actors, Functional Requirements, Business Rules, Non-Functional Requirements, Acceptance Criteria numerados (`AC-01`), Dependencies, Security, Observability, Testing, Open Questions, Traceability e Change History.

Estados operacionais (`IMPLEMENTING`, `IMPLEMENTED`, `VERIFIED`) pertencem ao GitHub Project e aos índices gerados, não à SPEC. Apenas `Draft`, `Review`, `Approved`, `Deprecated` e `Superseded` ficam no documento.

As histórias atuais devem ser decompostas em specs candidatas sem promoção automática. Lacunas `US02`, `US03`, `US04`, `US06`, `US08`, `US09`, `US12` e `US13` aparecem no backlog/sprints mas não têm critérios detalhados em `user-stories.md`.

## 12. Must Have Strategy

Must Haves devem ser poucos, atômicos, testáveis e vinculados à evidência. A extração inicial deve produzir candidatos, não regras aprovadas. Candidatos encontrados:

- Security: senha nunca em texto puro; autorização server-side; refresh token seguro; nenhum segredo no Git.
- Architecture: frontend não acessa banco diretamente; módulos não fazem imports cruzados não autorizados; mudanças de arquitetura exigem ADR.
- Data: migrations destrutivas usam Expand and Contract; operações acadêmicas críticas mantêm auditoria; integridade é validada no banco quando aplicável.
- Quality: critérios de aceite possuem testes/evidências; falha de gate bloqueia conclusão.
- Infrastructure: workloads e banco não recebem exposição pública indevida; infraestrutura gerenciada deve ser declarativa.

Cada candidato precisa de origem, owner, método determinístico de validação e decisão de aprovação antes de receber status `Approved`.

## 13. ADR Strategy

- Normalizar ADR-001 a ADR-005 com front matter, owner, data, relações e status.
- Não alterar o conteúdo decisório existente durante a normalização.
- Criar candidatos para: governança multi-repo; repositório central de contratos; distribuição/versionamento da baseline da KB; runtime/deploy de Next.js SSR; estratégia de eventos; fonte contract-first de OpenAPI.
- O ADR de multi-repo deve, se aceito, marcar ADR-005 como `Superseded` e apontar `Superseded by`.
- Decisões somente propostas permanecem `Proposed`; não entram como arquitetura normativa.

## 14. Contract Strategy

| Integração | Formato canônico recomendado |
| --- | --- |
| Frontend ↔ Backend | OpenAPI 3.1 + JSON Schema; SDK gerado, nunca contrato inferido apenas do código |
| Backend ↔ Database | migrations SQL/ORM no repo de banco/serviço + schema exportado e checks de compatibilidade |
| Service ↔ Service | OpenAPI para síncrono; AsyncAPI + JSON Schema para eventos |
| Aplicação ↔ Identity Provider | OIDC discovery/JWKS e perfil OAuth/OIDC documentado |
| Aplicação ↔ Cloud | interfaces/configuração versionadas; Terraform é implementação, não requisito de produto |
| Producer ↔ Consumer | AsyncAPI e schemas de evento versionados com regras de compatibilidade |

O governance repo mantém contratos globais e sua política; contratos estritamente locais podem residir no repo produtor, referenciados por versão. A autoridade exata precisa ser decidida para evitar cópias divergentes.

## 15. GitHub Board Strategy

- Um Project de portfólio mostra Epics, dependências e milestones; não replica tarefas manualmente.
- Views por Backend, Frontend, Database, Cloud e Quality podem existir no mesmo Project quando a organização permitir. Boards separados só se necessários por permissões ou cadência.
- Issues ficam no repositório executor e são a unidade de trabalho.
- Campos mínimos: `Status`, `Squad/Area`, `Epic ID`, `Spec ID`, `Priority`, `Iteration`, `Blocked by`.
- Estados: `Backlog`, `Ready`, `In Progress`, `Review`, `Blocked`, `Done`.
- Markdown define comportamento; Project define estado; Issue define execução; PR propõe integração; Git registra implementação.

## 16. Agent Harness Strategy

```text
agents/
├── roles/       # backend, frontend, database, cloud, QA, architecture reviewer
├── skills/      # implement-task, review-pr, spec-compliance, contract-validation
├── policies/    # invariantes e limites de autoridade
├── workflows/   # sequências operacionais
└── templates/   # SPEC, ADR, Requirement, relatório de compliance
```

Agent define responsabilidade; Skill define capacidade reutilizável; Policy define obrigação; Workflow define sequência. O `AGENTS.md` raiz de cada repo será um mapa curto para a baseline oficial, comandos de validação e instruções locais. Não duplicará a KB.

## 17. Spec Compliance Strategy

A skill `spec-compliance` recebe Issue/Task, commit SHA da baseline oficial e diff local. Ela deve:

1. obter a tag/commit aprovado do governance repo por canal autenticado;
2. verificar assinatura/checksum e impedir uso de `_KB` local não aprovada;
3. resolver `Task → SPEC → AC/MH/ADR/CONTRACT` pelo índice gerado;
4. executar primeiro compiler, lint, testes, schema/contract checks, architecture tests e scanners;
5. mapear evidências por critério de aceite;
6. usar análise de agente somente para itens não determinísticos;
7. emitir relatório `PASS`, `WARN` ou `FAIL` com evidência e baseline;
8. retornar exit code não zero em `FAIL`; agente não pode declarar Done.

`WARN` exige justificativa ou revisão humana; `FAIL` bloqueia o check requerido do PR. O relatório não modifica documentos normativos.

## 18. Ownership / CODEOWNERS Strategy

O `CODEOWNERS` deve usar handles/equipes reais, ainda não fornecidos. Mapeamento conceitual:

```text
/_KB/governance/       @product-owner @governance-maintainers
/_KB/product/          @product-owner
/_KB/requirements/     @product-owner
/_KB/specs/            @product-owner @relevant-technical-owner
/_KB/must-haves/business.md @product-owner
/_KB/must-haves/security.md @security-reference @product-owner
/_KB/architecture/     @technical-leads
/_KB/architecture/adrs/ @technical-leads
/_KB/contracts/        @producer-owner @consumer-owner
/_KB/engineering/      @technical-leads
/_KB/operations/       @cloud-devops-reference
/_KB/agents/           @governance-maintainers @technical-leads
```

Branch protection recomendada: sem push direto à `main`; PR obrigatório; CODEOWNERS; conversas resolvidas; checks de links, schema, IDs, lint e traceability; uma aprovação mínima e duas apenas para Level 0/1 ou mudanças de alto impacto. Commits assinados são opcionais no contexto acadêmico; histórico linear é útil, mas não deve impedir rollback/recovery.

## 19. Migration Mapping

### Mapeamento principal — OLD PATH → NEW PATH

| OLD PATH | NEW PATH | Ação |
| --- | --- | --- |
| `_KB/00-index/README.md` | `_KB/README.md` | atualizar como mapa |
| `_KB/00-index/navigation.md` | `_KB/traceability/generated/document-index.md` | gerar automaticamente |
| `_KB/00-index/glossary.md` | `_KB/product/glossary.md` | mover e revisar autoridade |
| `_KB/00-index/open-issues.md` | `_KB/governance/open-questions.md` | separar conflitos, decisões e histórico |
| `_KB/01-product/vision.md` | `_KB/product/vision.md` | mover |
| `_KB/01-product/scope.md` | `_KB/product/scope.md` | mover; extrair REQs sem alterar sentido |
| `_KB/01-product/stakeholders.md` | `_KB/product/stakeholders.md` | mover |
| `_KB/01-product/personas.md` | `_KB/product/personas.md` | mover |
| `_KB/01-product/modules.md` | `_KB/product/modules.md` | mover; extrair specs candidatas |
| `_KB/01-product/mvp.md` | `_KB/product/mvp-baseline.md` | validar vigência ou arquivar |
| `_KB/02-planning/backlog.md` | GitHub Issues/Project + `_KB/archive/planning/` | migrar definição; não manter estado duplo |
| `_KB/02-planning/user-stories.md` | `_KB/specs/` | dividir em SPECs candidatas preservando aliases US |
| `_KB/02-planning/roadmap.md` | GitHub Project/Roadmap + archive | arquivar baseline temporal |
| `_KB/02-planning/release-plan.md` | GitHub Milestones/Releases + archive | arquivar baseline temporal |
| `_KB/02-planning/sprint-plan.md` | GitHub Project + archive | remover estado operacional da KB ativa |
| `_KB/02-planning/dependencies.md` | `_KB/traceability/generated/dependencies.md` | derivar de relações estruturadas |
| `_KB/02-planning/risks.md` | `_KB/governance/risks.md` | mover; definir owner/cadência |
| `_KB/02-planning/metrics.md` | `_KB/engineering/quality-policy.md` + dashboards | separar metas normativas de resultados |
| `_KB/03-architecture/overview.md` | `_KB/architecture/containers.md` | consolidar visão |
| `_KB/03-architecture/system-context.md` | `_KB/architecture/system-context.md` | mover |
| `_KB/03-architecture/application-architecture.md` | `_KB/architecture/components.md` | mover/revisar após decisão repo |
| `_KB/03-architecture/data-architecture.md` | `_KB/architecture/data-flow.md` + `_KB/contracts/data/` | separar arquitetura e schema |
| `_KB/03-architecture/security-architecture.md` | `_KB/architecture/security.md` | consolidar sem duplicar políticas |
| `_KB/03-architecture/integration-architecture.md` | `_KB/architecture/integrations.md` | mover; extrair contratos |
| `_KB/03-architecture/diagrams.md` | documentos arquiteturais correspondentes | distribuir diagramas junto da fonte |
| `_KB/03-architecture/adr/*` | `_KB/architecture/adrs/*` | mover e normalizar metadados |
| `_KB/04-development/setup.md` | `_KB/operations/runbooks/local-development.md` | mesclar com runbook local |
| `_KB/04-development/repository-structure.md` | `_KB/architecture/repository-map.md` | revisar após ADR multi-repo |
| `_KB/04-development/coding-standards.md` | `_KB/engineering/standards.md` | mover |
| `_KB/04-development/git.md` + `branching-strategy.md` + `pull-requests.md` | `_KB/engineering/git-and-pr.md` | consolidar e resolver conflito de release |
| `_KB/04-development/api-guidelines.md` | `_KB/engineering/api-guidelines.md` | mover; contratos ficam separados |
| `_KB/04-development/database-guidelines.md` | `_KB/engineering/database-guidelines.md` | mover |
| `_KB/04-development/testing-guidelines.md` | `_KB/engineering/testing.md` | consolidar com qualidade prática |
| `_KB/05-security/*` | `_KB/security/*` + `_KB/must-haves/security.md` | separar arquitetura, policy e guia |
| `_KB/06-infrastructure/*` | `_KB/operations/infrastructure.md` + runbooks/architecture | consolidar por responsabilidade |
| `_KB/07-devops/ci-cd.md` + `github-actions.md` | `_KB/engineering/ci-cd.md` | consolidar estratégia e implementação |
| `_KB/07-devops/deployment.md` | `_KB/architecture/deployment.md` | manter estratégia, não passos |
| `_KB/07-devops/rollback.md` | `_KB/operations/runbooks/rollback.md` | mesclar com runbook |
| `_KB/07-devops/observability.md` | `_KB/engineering/observability.md` | mover e separar SLOs |
| `_KB/07-devops/finops.md` | `_KB/operations/finops.md` | mover; validar valores temporais |
| `_KB/08-quality/*` | `_KB/engineering/testing.md` + policies/runbooks específicos | consolidar política; preservar detalhes úteis |
| `_KB/09-governance/team-structure.md` | archive + `_KB/governance/squads.md` | arquivar composição antiga; criar a nova |
| `_KB/09-governance/responsibilities.md` + `raci.md` | archive + `_KB/governance/responsibilities.md` | recriar após autoridade confirmada |
| `_KB/09-governance/scrum.md` + `ceremonies.md` | `_KB/governance/delivery-process.md` | consolidar |
| `_KB/09-governance/definition-of-ready.md` | `_KB/governance/definition-of-ready.md` | atualizar para SPEC/contracts/MH |
| `_KB/09-governance/definition-of-done.md` | `_KB/governance/definition-of-done.md` | atualizar com spec-compliance |
| `_KB/10-runbooks/*` | `_KB/operations/runbooks/*` | mover; mesclar duplicatas citadas |

Fonte externa complementar:

| OLD PATH | NEW PATH | Ação |
| --- | --- | --- |
| `new_teams.md` | `_KB/governance/squads.md` + `_KB/archive/governance/team-allocation-source.md` | promover composição e lideranças como norma; registrar José Eduardo como Líder Técnico de Cloud & DevOps; preservar contatos, justificativas e movimentações como fonte histórica |

## 20. Documents to Create

- governance levels, source-of-truth, ownership, normative-change workflow e squads oficiais;
- templates de Requirement, SPEC, Must Have, ADR, Contract e compliance report;
- catálogo de conflitos e decisões requeridas;
- catálogo inicial de requirements/specs/must-haves como `Draft` até aprovação;
- políticas de IDs, metadados, lifecycle e versionamento de contratos;
- agent roles, policies, workflows e skill `spec-compliance`;
- schemas para front matter e índices gerados;
- `AGENTS.md` raiz como mapa;
- `CODEOWNERS` quando handles reais forem informados;
- `spec-index.json`, `traceability.json`, `repository-map.json` e `squad-map.json`, todos com `GENERATED FILE — DO NOT EDIT`.

## 21. Documents to Merge

- setup + runbook de desenvolvimento local;
- estratégia + runbook de rollback, preservando separação entre política e passos;
- três documentos de Git/branch/PR;
- estratégia de testes e guidelines, com páginas especializadas somente quando necessárias;
- arquitetura de autenticação/SSO e políticas de segurança, eliminando repetição mas não evidência;
- overview AWS/rede/diagramas, mantendo runbooks separados;
- Scrum + ceremonies;
- responsabilidades + RACI depois da confirmação de autoridade.

## 22. Documents to Archive

- baseline de quatro squads e RACI/lideranças antigas;
- roadmap, release e sprint plan encerrados de 2026.2, se confirmados como históricos;
- versões consolidadas de documentos duplicados;
- ADR-005 somente após ADR substituto aceito;
- qualquer documento cuja vigência não possa ser demonstrada.

Cada arquivo arquivado terá `Status: Archived`, `Reason`, `Superseded by` e `Date` quando conhecidos. Nada será removido antes de validação do histórico Git e aprovação.

## 23. Open Questions

1. Quem é o Product Owner oficial e qual é seu handle GitHub?
2. As cinco equipes vigentes atuarão somente como squads, como capítulos funcionais ou em modelo híbrido?
3. Qual organização e quais repositórios/Projects GitHub existem hoje?
4. O sistema já possui código que confirme NestJS, Prisma, Next.js, AWS e Terraform?
5. Quais decisões e requisitos tiveram aprovação formal e onde está a evidência?
6. Qual baseline remota/tag da governança será usada pelo CI?
7. Contratos globais residirão no governance repo ou em um registry/repo dedicado?
8. O portal precisa de SSR em runtime ou pode ser exportado estaticamente?
9. Quais metas de cobertura, desempenho, retenção e orçamento continuam vigentes?
10. O cronograma 2026.2 ainda é ativo ou já é histórico?
11. Os e-mails e usuários GitHub de `new_teams.md` foram verificados e podem constar no repositório de governança considerando privacidade e finalidade?
12. As justificativas e movimentações históricas de `new_teams.md` podem ser publicadas integralmente ou devem ter acesso restrito?

## 24. Decisions Required

- Aprovar a taxonomia, os níveis de governança e a matriz de fontes de verdade.
- Decidir monorepo vs. multi-repo por ADR, incluindo estratégia de contratos e releases coordenadas.
- Confirmar o modelo operacional das cinco equipes (squads, capítulos ou híbrido), sem reabrir sua composição e liderança.
- Nomear PO, technical approvers e handles para CODEOWNERS.
- Resolver CONFLICT-003 a CONFLICT-010 antes de promover políticas/specs.
- Escolher convenção definitiva entre IDs legados e novos IDs globais.
- Definir se OpenAPI é contract-first ou derivado, e qual artefato bloqueia CI.
- Aprovar quais Must Haves candidatos tornam-se invariantes normativos.

## 25. Risks

| Risco | Impacto | Mitigação |
| --- | --- | --- |
| Reorganizar antes de decidir monorepo/multi-repo | arquitetura documental errada | ADR antes da migração arquitetural |
| Converter prosa em regra sem autoridade | invenção normativa | tudo nasce Draft com fonte explícita |
| Quebrar links externos durante movimentos | perda de navegação | redirects/stubs temporários e checker CI |
| Três fontes de estado | divergência operacional | remover status manual da KB ativa |
| PO como gargalo | baixa vazão | níveis 2/3 com aprovação técnica delegada |
| Automação alterar norma | corrupção da fonte de verdade | CI só escreve em `generated/` |
| Índices desatualizados | compliance falso | geração e verificação obrigatórias em CI |
| Owners nominais mudarem | CODEOWNERS inválido | usar equipes GitHub, não nomes em texto |
| Arquivar evidência útil | perda histórica | inventário, Git e headers de supersessão |

## 26. Migration Steps

1. Congelar uma baseline da `_KB` atual e registrar hashes.
2. Aprovar este plano e responder decisões bloqueantes.
3. Criar schemas de metadados, taxonomia, níveis e source-of-truth.
4. Registrar conflitos sem resolvê-los implicitamente.
5. Criar templates e convenção de IDs; preservar aliases existentes.
6. Atualizar squads/ownership e arquivar a baseline organizacional antiga.
7. Extrair Requirements, SPECs e Must Haves como Draft com fonte por linha/seção.
8. Normalizar ADRs e decidir multi-repo por novo ADR.
9. Extrair contratos machine-readable e definir compatibilidade/versionamento.
10. Consolidar documentos duplicados e separar estratégia de runbook.
11. Migrar estado de tarefas para GitHub Issues/Projects e arquivar planos temporais.
12. Criar harness, `AGENTS.md`, skill `spec-compliance` e validadores determinísticos.
13. Gerar índices e rastreabilidade exclusivamente a partir de fontes autoritativas.
14. Executar validação completa: links, IDs, owners, ACs, órfãos, referências e duplicações.
15. Publicar relatório `_KB_MIGRATION_REPORT.md` e submeter PR para aprovação.

---

## Critério para iniciar a execução

A reorganização só deve começar após aprovação humana explícita deste plano. A aprovação do plano autoriza a migração estrutural, mas não resolve automaticamente os itens marcados `DECISION REQUIRED` nem promove candidatos a requisitos, Must Haves ou ADRs aceitos.
