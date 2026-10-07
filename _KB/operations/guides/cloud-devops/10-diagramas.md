---
title: "Diagramas"
type: guide
normative: false
owner: Cloud & DevOps
last_updated: 2026-10-07
---

# Diagramas

**Objetivo.** Reunir em um único documento os diagramas da infraestrutura da Plataforma Digital, para consulta visual rápida. Cada diagrama tem uma breve explicação e indica o documento em que o assunto é aprofundado.

**Pré-requisitos de leitura:** [01 Visão geral da plataforma](01-visao-geral-da-plataforma.md). Os termos usados estão no [11 Glossário](11-glossario.md).

Os diagramas usam Mermaid e são renderizados pelo GitHub, pelo VS Code (pré-visualização de Markdown) e pelo Obsidian. Para exportar um diagrama como imagem, copie o bloco para [mermaid.live](https://mermaid.live).

Todos os diagramas refletem a decisão do projeto de 2026-10-07: **apenas o ambiente de produção existe na AWS**. A decisão está registrada no ADR-012.

## Sumário

1. [Repositórios e suas relações](#1-repositórios-e-suas-relações)
2. [Arquitetura na AWS](#2-arquitetura-na-aws)
3. [Rede: sub-redes e security groups](#3-rede-sub-redes-e-security-groups)
4. [Ambientes](#4-ambientes)
5. [Ambiente de validação efêmera](#5-ambiente-de-validação-efêmera)
6. [Pipeline de entrega](#6-pipeline-de-entrega)
7. [OIDC: autenticação do pipeline na AWS](#7-oidc-autenticação-do-pipeline-na-aws)
8. [Ciclo de trabalho do Terraform](#8-ciclo-de-trabalho-do-terraform)
9. [State remoto, lock e bootstrap](#9-state-remoto-lock-e-bootstrap)
10. [Estrutura do repositório de infraestrutura](#10-estrutura-do-repositório-de-infraestrutura)
11. [Estados de uma issue](#11-estados-de-uma-issue)
12. [Fluxo de um PR de infraestrutura](#12-fluxo-de-um-pr-de-infraestrutura)
13. [Dependências entre as issues de infraestrutura](#13-dependências-entre-as-issues-de-infraestrutura)
14. [Sequência das sprints](#14-sequência-das-sprints)
15. [Integração com as outras equipes](#15-integração-com-as-outras-equipes)
16. [Custos](#16-custos)
17. [Laboratório local](#17-laboratório-local)

---

## 1. Repositórios e suas relações

O repositório de governança define as regras. Os demais as seguem, fixando a versão por tag e SHA (ADR-006, ADR-008). A infraestrutura recebe as imagens e as migrations dos outros repositórios e fornece à equipe de qualidade o ambiente de validação efêmera e, até o go-live, a conta de produção para os testes que exigem a AWS real. O repositório `plataforma-release`, ainda não criado, concentra o deploy em produção.

```mermaid
flowchart LR
  GOV["plataforma-governance<br/>regras, ADRs, backlogs"]
  BE["plataforma-backend<br/>Java 21 + Spring Boot 3"]
  FE["plataforma-frontend<br/>Next.js SSR"]
  DB["plataforma-database<br/>migrations PostgreSQL 16"]
  INF["plataforma-infrastructure<br/>Terraform + CI/CD"]
  QA["plataforma-quality<br/>E2E, carga, segurança"]
  REL["plataforma-release<br/>deploy em produção"]

  GOV -. "baseline tag + SHA" .-> BE
  GOV -.-> FE
  GOV -.-> DB
  GOV -.-> INF
  GOV -.-> QA
  BE -- "imagem de container" --> INF
  FE -- "imagem de container" --> INF
  DB -- "migrations" --> INF
  INF -- "validação efêmera no CI" --> QA
  INF -- "workflows e roles" --> REL

  style INF fill:#1f6feb,color:#fff
```

Aprofundamento: [01 Visão geral](01-visao-geral-da-plataforma.md#2-os-repositórios).

## 2. Arquitetura na AWS

A arquitetura alvo, conforme ADR-002, ADR-004, ADR-010 e a arquitetura de segurança. Ela existe em uma única conta AWS, dedicada à produção.

```mermaid
flowchart TB
  U["Usuário"] -->|HTTPS| CF["CloudFront<br/>cache e arquivos estáticos"]
  CF --> ALB["Application Load Balancer<br/>aceita apenas o CloudFront"]

  subgraph ACC["Conta AWS de produção (única), us-east-1"]
    subgraph VPC["VPC 10.30.0.0/16, 2 zonas de disponibilidade"]
      ALB -->|"/"| FE["Frontend Next.js SSR<br/>ECS Fargate"]
      ALB -->|"/api"| BE["API Spring Boot<br/>ECS Fargate"]
      FE --> BE
      BE --> RDS[("RDS PostgreSQL 16<br/>um schema por domínio")]
      BE --> NAT["NAT<br/>saída para a internet"]
    end
    BE --> S3[("S3: arquivos enviados<br/>URL pré-assinada")]
    BE --> SM["Secrets Manager"]
    BE --> CW["CloudWatch<br/>logs e métricas"]
    IAM["IAM Roles do pipeline"] --> ECR["ECR<br/>imagens imutáveis"]
  end

  NAT --> EXT["Provedor de login<br/>e serviço de e-mail"]
  GH["GitHub Actions"] -->|OIDC| IAM
  ECR -.-> FE
  ECR -.-> BE
```

O serviço que executa o SSR do frontend ainda está em detalhamento (INF-011, ADR-010). O diagrama mostra a alternativa ECS Fargate, que segue o mesmo padrão da API. A restrição do ALB ao CloudFront é um dos reforços descritos em [13 Segurança da infraestrutura](13-seguranca-da-infraestrutura.md).

Aprofundamento: [01 Visão geral](01-visao-geral-da-plataforma.md#4-arquitetura-alvo-na-aws) e [02 Conceitos fundamentais](02-conceitos-fundamentais-de-nuvem.md).

## 3. Rede: sub-redes e security groups

Cada camada só aceita tráfego da camada imediatamente anterior (INF-002). O módulo `modules/network` do laboratório implementa este desenho.

```mermaid
flowchart LR
  NET(("Internet"))

  subgraph PUB["Sub-redes públicas: 10.30.0.0/24 e 10.30.1.0/24"]
    ALB["SG alb<br/>entrada: 443 da prefix list<br/>do CloudFront"]
  end

  subgraph PRIV["Sub-redes privadas: 10.30.10.0/24 e 10.30.11.0/24"]
    APP["SG app<br/>entrada: 8080 somente do SG alb"]
    DB[("SG db<br/>entrada: 5432 somente do SG app")]
  end

  NET -->|"443 via CloudFront"| ALB
  ALB -->|8080| APP
  APP -->|5432| DB
  NET x-.-x|bloqueado| DB
```

Os endereços mostrados são os de produção. No laboratório, o mesmo módulo usa `10.10.x.x` (development). A faixa `10.20.0.0/16` fica reservada para um eventual staging na AWS.

Aprofundamento: [02 Conceitos fundamentais](02-conceitos-fundamentais-de-nuvem.md) e [13 Segurança da infraestrutura](13-seguranca-da-infraestrutura.md).

## 4. Ambientes

Apenas produção existe na AWS. O desenvolvimento acontece na máquina de cada pessoa, e a validação que caberia a um staging acontece em um ambiente efêmero dentro do CI.

```mermaid
flowchart TB
  subgraph LOCAL["Máquina do desenvolvedor"]
    DEV["development<br/>Docker Compose + MiniStack<br/>sem custo"]
  end

  subgraph CI["GitHub Actions"]
    VAL["Validação efêmera<br/>criada e destruída a cada job"]
  end

  subgraph PROD["Conta AWS de produção (única)"]
    PRD["production: VPC 10.30.0.0/16"]
    PRS[("state: plataforma-tfstate-production")]
  end

  DEV -- "PR" --> VAL
  VAL -- "imagem aprovada no ECR<br/>+ go/no-go" --> PRD
  PRD --- PRS
```

**Período pré-go-live.** Até o go-live (INF-019), a conta de produção ainda não tem usuários nem dados reais e recebe os testes que exigem a AWS real: carga a 200 RPS (INF-017), ensaio de rollback (INF-018) e primeiro ensaio de restore (INF-016). Depois do go-live, esses testes só acontecem em janela controlada, e o restore é feito em instância temporária dentro da própria conta.

Aprofundamento: [01 Visão geral](01-visao-geral-da-plataforma.md#7-ambientes).

## 5. Ambiente de validação efêmera

O ambiente é montado com Docker Compose dentro do runner do GitHub Actions e descartado ao final do job. Não usa dados reais nem credenciais da AWS.

```mermaid
flowchart LR
  subgraph RUNNER["Runner do GitHub Actions (descartado ao final do job)"]
    direction LR
    subgraph APPS["Aplicação"]
      IMG["Imagem recém-construída<br/>mesmo digest que será publicado"]
    end
    subgraph DEPS["Dependências"]
      PG[("postgres:16<br/>migrations + seeds sintéticos")]
      MS["MiniStack<br/>S3 e Secrets Manager"]
    end
    subgraph TESTS["Testes"]
      T1["Smoke e contrato"]
      T2["E2E (Playwright)"]
      T3["DAST (ZAP baseline)"]
      T4["Carga (k6 reduzido)"]
    end
    IMG --> PG
    IMG --> MS
    T1 --> IMG
    T2 --> IMG
    T3 --> IMG
    T4 --> IMG
  end
  RUNNER -->|"todos aprovados"| ECR["Push no ECR de produção<br/>role gha-&lt;app&gt;-publish"]
```

Nos PRs de infraestrutura, o mesmo runner também executa um `terraform apply` completo contra o MiniStack antes do `plan` contra produção.

Aprofundamento: [05 Laboratório local](05-laboratorio-local-ministack.md#15-o-laboratório-no-modelo-somente-produção-na-aws).

## 6. Pipeline de entrega

A mesma imagem, identificada pelo mesmo digest, vai da validação efêmera até produção (POL-INFRA-001). O deploy em produção é disparado no repositório `plataforma-release`.

```mermaid
flowchart LR
  PR["PR aberto"] --> CI["CI<br/>lint, testes, análises,<br/>validação efêmera"]
  CI -->|merge na main| BUILD["Build da imagem<br/>linux/arm64"]
  BUILD --> VAL["Validação efêmera<br/>com a imagem construída"]
  VAL --> ECR["Push no ECR<br/>tag imutável + digest"]
  ECR --> GATE{"Go/no-go<br/>(obrigatório após o go-live)"}
  GATE -->|aprovado| REL["deploy-production<br/>workflow_dispatch no plataforma-release"]
  GATE -->|reprovado| FIX["Volta para correção"]
  REL --> MIG["Migration<br/>task avulsa no ECS"]
  MIG --> PRD["Atualização do service<br/>mesmo digest"]
  PRD --> PSMOKE{"Smoke em produção"}
  PSMOKE -->|sucesso| DONE["Monitoramento"]
  PSMOKE -->|falha| RB["Rollback para<br/>o digest anterior"]
```

Aprofundamento: [08 CI/CD no plano Free](08-cicd-no-plano-free-do-github.md).

## 7. OIDC: autenticação do pipeline na AWS

Nenhuma chave de acesso fica guardada no GitHub. Cada credencial é temporária e vale apenas para a role autorizada (INF-004). Todas as roles ficam na conta de produção: `gha-infra-plan`, `gha-infra-apply`, `gha-backend-publish`, `gha-frontend-publish` e `gha-release-deploy`.

```mermaid
sequenceDiagram
  autonumber
  participant GA as Job do GitHub Actions
  participant GH as Emissor OIDC do GitHub
  participant STS as AWS STS
  participant AWS as Recursos AWS

  GA->>GH: Solicita token de identidade (id-token: write)
  GH-->>GA: JWT assinado (repositório, branch, environment)
  GA->>STS: AssumeRoleWithWebIdentity(ARN da role, JWT)
  STS->>STS: Confere assinatura, audiência<br/>e se o sub corresponde à trust policy
  STS-->>GA: Credencial temporária (cerca de 1 hora)
  GA->>AWS: terraform apply, docker push, deploy no ECS
  Note over GA,AWS: Nenhuma chave de acesso fica salva no GitHub
```

Aprofundamento: [07 OIDC](07-oidc-github-actions-aws.md).

## 8. Ciclo de trabalho do Terraform

O código descreve o estado desejado. O `plan` compara esse estado com o state e com a infraestrutura real, e uma pessoa revisa a diferença antes do `apply`.

```mermaid
flowchart LR
  CODE["Código .tf<br/>(estado desejado)"] --> PLAN["terraform plan"]
  STATE[("State<br/>(estado registrado)")] --> PLAN
  REAL["Infraestrutura real"] -. "refresh" .-> PLAN
  PLAN -->|"+ cria, ~ altera, - remove"| REVIEW{"Diferença revisada<br/>e aprovada?"}
  REVIEW -->|sim| APPLY["terraform apply"]
  REVIEW -->|não| CODE
  APPLY --> REAL
  APPLY --> STATE
```

Sequência de comandos: `init`, `fmt`, `validate`, `plan`, `apply` e, no laboratório, `destroy`.

Aprofundamento: [03 Terraform: fundamentos](03-terraform-fundamentos.md).

## 9. State remoto, lock e bootstrap

Duas execuções não conseguem alterar o mesmo state ao mesmo tempo (INF-001). O comportamento foi testado no laboratório.

```mermaid
sequenceDiagram
  autonumber
  participant A as Execução A
  participant B as Execução B
  participant S3 as Bucket S3 do state

  A->>S3: Cria o arquivo .tflock (use_lockfile)
  S3-->>A: Lock concedido à execução A
  B->>S3: Tenta criar o .tflock
  S3-->>B: O arquivo já existe
  Note over B: Error acquiring the state lock
  A->>S3: Lê o state, aplica e grava a nova versão
  A->>S3: Remove o .tflock
  B->>S3: Tenta novamente
  S3-->>B: Lock concedido à execução B
```

O bucket que guarda o state não pode guardar o próprio state. Por isso ele é criado uma única vez por um diretório separado, o `bootstrap/`, que usa state local. Na AWS existe um único bucket de state, o de produção; no laboratório, o bucket equivalente é `plataforma-tfstate-development`.

```mermaid
flowchart LR
  BOOT["bootstrap/<br/>state local"] -->|"cria uma vez"| BUCKET[("plataforma-tfstate-production<br/>versionado, cifrado, privado")]
  ENV["environments/production<br/>backend s3"] -->|"guarda o state em"| BUCKET
  GLB["global/github-oidc<br/>backend s3"] -->|"guarda o state em"| BUCKET
```

## 10. Estrutura do repositório de infraestrutura

```mermaid
flowchart TB
  ROOT["plataforma-infrastructure/"]
  ROOT --> BOOT["bootstrap/<br/>INF-001"]
  ROOT --> GLOBAL["global/github-oidc/<br/>INF-004"]
  ROOT --> MOD["modules/"]
  ROOT --> ENVS["environments/"]
  ROOT --> GHA[".github/workflows/<br/>INF-003"]

  MOD --> MN["network<br/>INF-002"]
  MOD --> MD["database<br/>INF-005"]
  MOD --> MB["backend<br/>INF-007"]
  MOD --> MF["frontend<br/>INF-011"]

  ENVS --> ED["development<br/>somente laboratório e CI"]
  ENVS --> EP["production<br/>único ambiente na AWS"]

  EP -. "chama" .-> MN
  EP -.-> MD
  EP -.-> MB
  EP -.-> MF
  ED -. "chama os mesmos módulos" .-> MOD
```

Os módulos funcionam como funções reutilizáveis; cada diretório em `environments/` é um ponto de entrada (root module) que chama os módulos com os valores daquele ambiente. Não existe `environments/staging/`.

Aprofundamento: [03 Terraform: fundamentos](03-terraform-fundamentos.md) e [04 Padrões e fluxo de trabalho](04-padroes-e-fluxo-de-trabalho.md).

## 11. Estados de uma issue

Os estados do GitHub Project (POL-GOV-007).

```mermaid
stateDiagram-v2
  [*] --> Backlog
  Backlog --> Refinement: entra em refinamento
  Refinement --> Ready: atende ao Definition of Ready
  Ready --> InProgress: trabalho iniciado
  InProgress --> InReview: PR aberto
  InReview --> InProgress: mudanças solicitadas
  InReview --> Validation: PR aprovado e integrado
  Validation --> Done: atende ao Definition of Done
  InProgress --> Blocked: dependência impede o avanço
  Blocked --> InProgress: impedimento resolvido
  Done --> [*]
```

Aprofundamento: [04 Padrões e fluxo de trabalho](04-padroes-e-fluxo-de-trabalho.md).

## 12. Fluxo de um PR de infraestrutura

No PR, o código é aplicado no emulador e comparado com produção. O `apply` em produção só acontece depois do merge.

```mermaid
sequenceDiagram
  autonumber
  actor Dev as Autor
  participant GH as GitHub
  participant CI as CI (INF-003)
  actor Rev as Revisor

  Dev->>GH: Branch inf-00X/descricao e commits
  Dev->>GH: Abre PR "[INF-00X] ..." com Closes #35;X
  GH->>CI: Dispara o workflow
  CI->>CI: fmt, validate, tflint, trivy
  CI->>CI: apply completo contra o MiniStack
  CI->>CI: plan contra produção (gha-infra-plan, somente leitura)
  CI-->>GH: Publica o plan como comentário
  Rev->>GH: Lê o plan e revisa o código
  alt mudanças solicitadas
    Rev-->>Dev: Comentários
    Dev->>GH: Novos commits
  else aprovado
    Rev->>GH: Aprovação (CODEOWNERS)
    Dev->>GH: Squash merge na main
    GH->>CI: Apply em produção (gha-infra-apply)
  end
```

Depois do go-live, recomenda-se que o apply em produção seja disparado manualmente (`workflow_dispatch` na `main`) logo após o merge, para que alguém acompanhe a execução.

## 13. Dependências entre as issues de infraestrutura

Cada seta indica que a issue de destino depende da issue de origem. O caminho crítico vai da conta AWS de produção até o INF-009 (validação efêmera e publicação de imagens), destacado em azul.

```mermaid
flowchart LR
  AWS{{"Conta AWS<br/>de produção"}} --> I1

  I1["INF-001<br/>state remoto"] --> I2["INF-002<br/>rede"]
  I1 --> I4["INF-004<br/>OIDC"]
  I4 --> I6["INF-006<br/>ECR"]
  I4 --> I8["INF-008<br/>Secrets"]
  I4 --> I14["INF-014<br/>orçamento"]
  I4 --> I10["INF-010<br/>S3"]
  I2 --> I10
  I2 --> I5["INF-005<br/>RDS"]
  I2 --> I7["INF-007<br/>runtime da API"]
  I6 --> I7
  PG14["PG-014<br/>Project"] --> I3["INF-003<br/>workflows de CI"]

  I5 --> I9["INF-009<br/>validação efêmera e<br/>publicação de imagens"]
  I6 --> I9
  I7 --> I9
  I8 --> I9
  I3 -.-> I9

  FE1["FE-001"] --> I11["INF-011<br/>runtime SSR"]
  I9 --> I12["INF-012<br/>observabilidade"]
  I11 --> I12
  I12 --> I13["INF-013<br/>alarmes"]
  I5 --> I15["INF-015<br/>backup"]
  I15 --> I16["INF-016<br/>restore"]
  QA24["QA-024<br/>teste de carga"] --> I17["INF-017<br/>autoscaling"]
  I9 --> I18["INF-018<br/>rollback"]
  PG18["PG-018 + QA-028"] --> I19["INF-019<br/>go-live"]
  I19 --> I20["INF-020<br/>smoke pós-deploy"]
  I18 --> I21["INF-021<br/>runbooks"]
  I20 --> I21

  style AWS fill:#d73a49,color:#fff
  style I1 fill:#1f6feb,color:#fff
  style I9 fill:#1f6feb,color:#fff
  style I19 fill:#1f6feb,color:#fff
```

Aprofundamento: [06 Backlog de infraestrutura](06-backlog-de-infraestrutura.md).

## 14. Sequência das sprints

As sprints têm cadência quinzenal. O diagrama mostra apenas a ordem; as datas oficiais ficam no GitHub Project. A sprint S4 não contém issues de infraestrutura. Todas as sprints anteriores à S6 pertencem ao período pré-go-live.

```mermaid
flowchart LR
  S0["S0 Fundação<br/>INF-001 a 008, INF-014"] --> S1["S1<br/>INF-009 validação efêmera<br/>INF-010 S3"]
  S1 --> S2["S2<br/>INF-011 SSR"]
  S2 --> S3["S3<br/>INF-012, 013, 015"]
  S3 --> S4["S4<br/>sem issues INF"]
  S4 --> S5["S5 Ensaios em produção<br/>pré-go-live<br/>INF-016, 017, 018"]
  S5 --> S6["S6 Go-live<br/>INF-019, 020, 021"]

  style S1 fill:#1f6feb,color:#fff
  style S6 fill:#1f6feb,color:#fff
```

## 15. Integração com as outras equipes

À esquerda, o que a infraestrutura recebe de cada equipe; à direita, o que entrega.

```mermaid
flowchart LR
  subgraph REC["Recebe"]
    rBE["Backend<br/>imagem e healthcheck (BE-001)"]
    rFE["Frontend<br/>aplicação SSR (FE-001)"]
    rDB["Banco de dados<br/>migrations e pool (DB-002, DB-019)"]
    rQA["Qualidade<br/>análise de IaC, carga, DAST (QA-024 a 026)"]
    rPO["Produto<br/>Project, escopo, go/no-go (PG-014, PG-018)"]
  end

  INF(("Cloud &<br/>DevOps"))

  subgraph ENT["Entrega"]
    eBE["Backend<br/>runtime, segredos, S3 (INF-007, 008, 010)"]
    eFE["Frontend<br/>runtime SSR e CDN (INF-011)"]
    eDB["Banco de dados<br/>RDS, backup, restore (INF-005, 015, 016)"]
    eQA["Qualidade<br/>validação efêmera no CI e janelas<br/>de teste em produção pré-go-live (INF-009)"]
    ePO["Produto<br/>produção com go-live (INF-019)"]
  end

  rBE --> INF
  rFE --> INF
  rDB --> INF
  rQA --> INF
  rPO --> INF
  INF --> eBE
  INF --> eFE
  INF --> eDB
  INF --> eQA
  INF --> ePO

  style INF fill:#1f6feb,color:#fff
```

## 16. Custos

Valores mensais estimados em us-east-1, preços on-demand consultados em 2026-10-05. Como apenas produção existe na AWS, todo o orçamento de US$ 120 cobre esse ambiente. As variantes estão descritas em [09 Custos e FinOps](09-custos-e-finops.md).

**Custo mensal de produção por variante comparado ao orçamento de US$ 120:**

```mermaid
xychart-beta
  title "Produção por variante (US$ por mês), orçamento de US$ 120"
  x-axis ["P1: fck-nat, single-AZ", "P2: NAT Gateway", "P3: Multi-AZ", "P4: NAT GW + Multi-AZ"]
  y-axis "US$ por mês" 0 --> 140
  bar [77.06, 106.68, 91.04, 120.66]
  line [120, 120, 120, 120]
```

**Composição do custo da variante P3 (recomendada, US$ 91,04 por mês):**

```mermaid
pie showData
  title Produção na variante P3 (US$ por mês)
  "ALB + 2 IPv4" : 29.57
  "RDS Multi-AZ + armazenamento" : 27.96
  "API em Fargate ARM" : 14.42
  "Frontend em Fargate ARM" : 7.21
  "fck-nat" : 6.88
  "Secrets, logs, KMS, S3, ECR" : 5.00
```

Somando os reforços de segurança essenciais, a estimativa da P3 fica em cerca de US$ 95 por mês, ou cerca de US$ 105 com AWS WAF ([13 Segurança da infraestrutura](13-seguranca-da-infraestrutura.md)).

**Escolha da saída para a internet das sub-redes privadas de produção:**

```mermaid
flowchart TB
  Q{"A sub-rede privada precisa<br/>acessar a internet?"}
  Q -->|"não, apenas serviços AWS"| EP["Gateway endpoint S3 (gratuito)<br/>+ interface endpoints<br/>cerca de US$ 7,30 cada por AZ"]
  Q -->|"sim: login institucional, e-mail"| HA{"Uma única instância NAT,<br/>com recuperação automática,<br/>é aceitável?"}
  HA -->|sim| FCK["fck-nat em Auto Scaling Group<br/>P1 (US$ 77) ou P3 (US$ 91)"]
  HA -->|não| NGW["NAT Gateway<br/>P2 (US$ 107) ou P4 (US$ 121, estoura)"]
```

## 17. Laboratório local

O laboratório substitui a AWS por um emulador que executa em container no computador do desenvolvedor. A mesma base é usada no ambiente de validação efêmera do CI.

```mermaid
flowchart LR
  subgraph PC["Computador do desenvolvedor ou runner do CI"]
    MK["make plan / apply"] --> TF["Terraform<br/>(local ou em container)"]
    TF -->|"API AWS em localhost:4566"| MS["Container MiniStack"]
    CLI["make aws CMD=..."] --> MS
    MS --> PG[("PostgreSQL 16 real<br/>container ministack-rds")]
    MS --> SIM["S3, EC2/VPC, ECR,<br/>Secrets Manager etc.<br/>simulados em memória"]
  end
```

Limites do emulador: as permissões IAM só são avaliadas com `AUTH=true` e, mesmo assim, sem verificar a chave secreta nem a assinatura de tokens; alguns atributos não são guardados; não há custo real. O emulador valida a estrutura do código; o comportamento real só é comprovado na conta de produção, preferencialmente no período pré-go-live.

Aprofundamento: [05 Laboratório local com MiniStack](05-laboratorio-local-ministack.md).
