---
title: "Glossário"
type: guide
normative: false
owner: Cloud & DevOps
last_updated: 2026-10-07
---

# Glossário

**Objetivo.** Reunir, em ordem alfabética, as definições dos termos técnicos usados neste material de apoio, com indicação de onde cada assunto é aprofundado.

**Pré-requisitos de leitura:** nenhum. Este documento serve de consulta para todos os demais, a começar por [README.md](README.md).

> Este glossário cobre os termos de infraestrutura, nuvem e entrega de software. O glossário de termos de negócio da plataforma está em `_KB/product/glossary.md`. Em caso de divergência, prevalecem os documentos normativos da `_KB`.

**Índice:** [A](#a) · [B](#b) · [C](#c) · [D](#d) · [E](#e) · [F](#f) · [G](#g) · [H](#h) · [I](#i) · [J](#j) · [K](#k) · [L](#l) · [M](#m) · [N](#n) · [O](#o) · [P](#p) · [R](#r) · [S](#s) · [T](#t) · [U](#u) · [V](#v) · [W](#w) · [Z](#z)

---

## A

**AC (Acceptance Criteria, critério de aceite).** Condição objetiva e verificável que uma entrega precisa cumprir para ser considerada concluída. No projeto, os critérios de aceite são numerados na issue e exigem evidência. Veja: [06-backlog-de-infraestrutura.md](06-backlog-de-infraestrutura.md).

**Access key (chave de acesso).** Par de identificador e segredo que permite chamar a API da AWS como um usuário IAM. É uma credencial de longa duração; por isso o projeto não a utiliza em pipelines, preferindo OIDC. Veja: [07-oidc-github-actions-aws.md](07-oidc-github-actions-aws.md).

**ADR (Architecture Decision Record).** Documento curto que registra uma decisão de arquitetura, seu contexto, as alternativas consideradas e as consequências. Os ADRs do projeto ficam em `_KB/architecture/adrs/`.

**ALB (Application Load Balancer).** Balanceador de carga da AWS para tráfego HTTP e HTTPS, que distribui requisições entre destinos saudáveis e permite roteamento por caminho ou nome de host. Veja: [02-conceitos-fundamentais-de-nuvem.md](02-conceitos-fundamentais-de-nuvem.md).

**Alarme.** Regra do CloudWatch que monitora uma métrica e dispara uma notificação quando um limite é ultrapassado, por exemplo, latência acima de 500 ms.

**Alta disponibilidade.** Capacidade de um sistema continuar operando diante da falha de um componente, normalmente obtida por redundância entre zonas de disponibilidade. Veja: [09-custos-e-finops.md](09-custos-e-finops.md).

**Ambiente de validação efêmera.** Ambiente criado dentro do job do GitHub Actions e destruído ao final dele, com a imagem recém-construída, um PostgreSQL 16, o MiniStack (S3 e Secrets Manager) e dados sintéticos. Executa smoke, E2E, DAST e carga reduzida, cumprindo o papel de staging no projeto, sem custo na AWS. Veja: [01-visao-geral-da-plataforma.md](01-visao-geral-da-plataforma.md#7-ambientes).

**ANPD (Autoridade Nacional de Proteção de Dados).** Órgão federal que fiscaliza o cumprimento da LGPD. Em um incidente com dados pessoais, a organização avalia a comunicação à ANPD e aos titulares afetados. Veja: [13-seguranca-da-infraestrutura.md](13-seguranca-da-infraestrutura.md).

**API (Application Programming Interface).** Interface pela qual programas se comunicam. Toda operação na AWS, inclusive as feitas pelo console web, é uma chamada à API da AWS.

**Apply (`terraform apply`).** Comando do Terraform que executa as alterações calculadas pelo plan, criando, modificando ou removendo recursos. Veja: [03-terraform-fundamentos.md](03-terraform-fundamentos.md).

**Artefato.** Resultado de um processo de build destinado a ser implantado, como uma imagem de container. No projeto, o artefato é construído uma vez e promovido entre ambientes.

**ARN (Amazon Resource Name).** Identificador único de um recurso na AWS, no formato `arn:aws:<serviço>:<região>:<conta>:<recurso>`. É usado em policies para indicar a quais recursos uma permissão se aplica.

**aud (claim).** Campo de um token JWT que indica para qual destinatário o token foi emitido. Nos tokens do GitHub para a AWS, o valor esperado é `sts.amazonaws.com`. Veja: [07-oidc-github-actions-aws.md](07-oidc-github-actions-aws.md).

**Autoscaling.** Ajuste automático da quantidade de recursos (por exemplo, número de tasks do ECS) conforme uma métrica, como uso de CPU ou número de requisições.

**AWS CLI.** Ferramenta de linha de comando para interagir com a API da AWS. No laboratório, ela é configurada para o emulador. Veja: [05-laboratorio-local-ministack.md](05-laboratorio-local-ministack.md).

**AZ (Availability Zone, zona de disponibilidade).** Um ou mais data centers independentes dentro de uma região da AWS. Distribuir recursos em duas ou mais zonas aumenta a disponibilidade.

## B

**Backend (Terraform).** Configuração que define onde o Terraform guarda o state. O projeto usa o backend `s3`, com cifragem e lock nativo. Não confundir com o backend da aplicação (a API). Veja: [03-terraform-fundamentos.md](03-terraform-fundamentos.md).

**Backup.** Cópia de dados mantida para permitir recuperação. No RDS, há backups automáticos diários com retenção configurável e snapshots manuais. A POL-INFRA-003 exige retenção inicial de 14 dias em produção.

**Baseline de governança.** Versão aprovada e imutável dos documentos normativos, identificada por uma tag `governance-vMAJOR.MINOR.PATCH` e um SHA de commit. Cada repositório declara a baseline que segue no arquivo `.governance-baseline` (ADR-008).

**Bootstrap.** Etapa inicial que cria os recursos necessários para o próprio Terraform funcionar, como o bucket que guardará o state. É executada uma vez, com state local. Veja: [03-terraform-fundamentos.md](03-terraform-fundamentos.md).

**Branch.** Linha de desenvolvimento independente em um repositório Git. No GitHub Flow, cada alteração é feita em uma branch curta e incorporada à `main` por pull request.

**Branch protection.** Recurso do GitHub que impõe regras a uma branch, como exigir pull request, aprovação e checks aprovados antes do merge. Não está disponível para repositórios privados no plano Free. Veja: [08-cicd-no-plano-free-do-github.md](08-cicd-no-plano-free-do-github.md).

**Bucket.** Contêiner de objetos no Amazon S3. O nome de um bucket é único em toda a AWS.

**Budget (orçamento).** Limite de gasto acompanhado pelo AWS Budgets, que envia alertas ao atingir percentuais definidos. O projeto adota US$ 120 por mês (POL-INFRA-004).

**Burstable (instância com créditos de CPU).** Classe de instância (famílias `t`, como `db.t4g.micro`) que opera abaixo de uma linha de base de CPU e acumula créditos para picos curtos. Uso prolongado acima da linha de base consome créditos ou gera cobrança adicional. Veja: [09-custos-e-finops.md](09-custos-e-finops.md).

## C

**CDN (Content Delivery Network).** Rede de servidores distribuídos que armazenam cópias de conteúdo próximas aos usuários. Na AWS, o serviço é o CloudFront.

**Checkov.** Ferramenta de código aberto que analisa código de infraestrutura em busca de configurações inseguras. É uma das opções de scanner de IaC no pipeline. Veja: [04-padroes-e-fluxo-de-trabalho.md](04-padroes-e-fluxo-de-trabalho.md).

**CI/CD (Integração e Entrega Contínuas).** Prática de validar automaticamente cada alteração (CI) e automatizar sua publicação em ambientes (CD). No projeto, é executada pelo GitHub Actions (POL-INFRA-001).

**CIDR (Classless Inter-Domain Routing).** Notação `endereço/prefixo` que descreve um bloco de endereços IP. Um `/16` contém 65.536 endereços; um `/24`, 256. Veja: [02-conceitos-fundamentais-de-nuvem.md](02-conceitos-fundamentais-de-nuvem.md).

**Circuit breaker (ECS).** Mecanismo do ECS que detecta um deploy cujas novas tasks não ficam saudáveis e, se configurado, executa rollback automático para a versão anterior.

**Claim.** Cada informação contida em um token JWT, como `sub` (sujeito), `aud` (destinatário) e `exp` (expiração).

**CloudFront.** CDN da AWS, usada para servir arquivos estáticos do frontend com cache.

**CloudTrail.** Serviço de auditoria que registra as chamadas à API da AWS: identidade, ação, horário e origem.

**CloudWatch.** Serviço de observabilidade da AWS, com logs, métricas, painéis e alarmes.

**CODEOWNERS.** Arquivo do GitHub que associa caminhos do repositório a pessoas ou times responsáveis pela revisão. Com branch protection, a aprovação desses responsáveis pode ser exigida.

**Container.** Processo isolado que executa uma aplicação com todas as suas dependências, criado a partir de uma imagem. Veja: [02-conceitos-fundamentais-de-nuvem.md](02-conceitos-fundamentais-de-nuvem.md).

**Credencial temporária.** Credencial emitida pelo STS com validade limitada (tipicamente uma hora), que expira sem ação manual.

## D

**Data source (bloco `data`).** Bloco do Terraform que lê informações de algo que já existe, sem gerenciá-lo. Veja: [03-terraform-fundamentos.md](03-terraform-fundamentos.md).

**Default tags.** Configuração do provider AWS no Terraform que aplica automaticamente um conjunto de tags a todos os recursos criados.

**Definition of Done (DoD).** Lista de condições que uma issue precisa cumprir para ser considerada concluída: critérios de aceite com evidência, checks aprovados, revisão, documentação e rollback atualizados. Definida em `_KB/governance/definition-of-done.md`.

**Definition of Ready (DoR).** Lista de condições que uma issue precisa cumprir antes de ser iniciada: critérios de aceite numerados e verificáveis, dependências resolvidas, responsável e revisor definidos. Definida em `_KB/governance/definition-of-ready.md`.

**Deploy (implantação).** Publicação de uma versão do software em um ambiente.

**Destroy (`terraform destroy`).** Comando que remove todos os recursos registrados no state. Usado em laboratório e em ambientes temporários.

**Digest.** Hash SHA-256 do conteúdo de uma imagem de container (`@sha256:...`). Identifica a imagem de forma inequívoca; por isso o deploy referencia o digest, e não a tag.

**DNS (Domain Name System).** Sistema que traduz nomes de domínio em endereços de rede. Na AWS, o serviço é o Route 53.

**Dockerfile.** Arquivo com as instruções para construir uma imagem de container.

**Drift (divergência de configuração).** Diferença entre o que o código descreve e o que existe de fato na nuvem, normalmente causada por alterações manuais. O `terraform plan` detecta o drift e o `apply` o desfaz. Veja: [03-terraform-fundamentos.md](03-terraform-fundamentos.md).

## E

**ECR (Elastic Container Registry).** Registry de imagens de container da AWS. Veja: [02-conceitos-fundamentais-de-nuvem.md](02-conceitos-fundamentais-de-nuvem.md).

**ECS (Elastic Container Service).** Orquestrador de containers da AWS, que mantém o número desejado de tasks em execução.

**Emulador.** Programa que reproduz localmente o comportamento da API de um serviço, permitindo testes sem acesso ao serviço real. No projeto, o emulador da AWS é o MiniStack. Veja: [05-laboratorio-local-ministack.md](05-laboratorio-local-ministack.md).

**Endpoint.** Endereço de rede de um serviço. No provider do Terraform, o bloco `endpoints` redireciona chamadas para o emulador.

**Environment (GitHub).** Recurso do GitHub Actions que agrupa variáveis e segredos por ambiente e permite regras como aprovação obrigatória e restrição de branches. Indisponível em repositórios privados no plano Free. Veja: [07-oidc-github-actions-aws.md](07-oidc-github-actions-aws.md).

**Ephemeral resource (recurso efêmero, Terraform).** Bloco `ephemeral`, disponível a partir do Terraform 1.10, cujo valor existe apenas durante a execução e nunca é gravado no state nem no plan. Usado, por exemplo, para gerar uma senha (`ephemeral "random_password"`) e entregá-la a um atributo write-only. Veja: [13-seguranca-da-infraestrutura.md](13-seguranca-da-infraestrutura.md).

**Execution role.** Role usada pelo ECS para preparar uma task: baixar a imagem, ler segredos e enviar logs. É distinta da task role.

## F

**Fargate.** Modo de execução do ECS em que a AWS provê a capacidade computacional, sem servidores a administrar (ADR-004).

**fck-nat.** Projeto de código aberto que configura uma pequena instância EC2 para funcionar como NAT, com custo muito inferior ao do NAT Gateway, porém sem redundância gerenciada. Veja: [09-custos-e-finops.md](09-custos-e-finops.md).

**FinOps.** Disciplina de gestão financeira da nuvem: estimar, acompanhar e otimizar custos com participação de engenharia e produto. Veja: [09-custos-e-finops.md](09-custos-e-finops.md).

**`for_each` e `count`.** Argumentos do Terraform que criam várias instâncias de um recurso a partir de um mapa, conjunto ou número.

## G

**GitHub Actions.** Serviço de automação do GitHub que executa workflows em resposta a eventos, como abertura de pull request ou push na `main`.

**GitHub Flow.** Modelo de trabalho em que a `main` está sempre implantável e toda alteração é feita em uma branch curta, revisada em pull request e incorporada por merge. Veja: [04-padroes-e-fluxo-de-trabalho.md](04-padroes-e-fluxo-de-trabalho.md).

**gitleaks.** Ferramenta de código aberto que procura segredos (chaves, senhas, tokens) em arquivos e no histórico do Git. Usada em pre-commit e no CI para compensar a ausência de secret scanning em repositórios privados no plano Free do GitHub. Veja: [13-seguranca-da-infraestrutura.md](13-seguranca-da-infraestrutura.md).

**Go/no-go.** Decisão formal, registrada, de liberar ou não uma versão para produção, com base nas evidências reunidas (no projeto, as da validação efêmera no CI e dos testes feitos em produção antes do go-live). Veja: [08-cicd-no-plano-free-do-github.md](08-cicd-no-plano-free-do-github.md).

**Graviton.** Família de processadores ARM (arm64) projetados pela AWS, com custo inferior ao de processadores x86 equivalentes. Exige imagens compatíveis com arm64.

## H

**Health check (verificação de saúde).** Requisição periódica a um endereço da aplicação para verificar se ela está apta a receber tráfego. No backend, o endereço é `/actuator/health/readiness`.

**HCL (HashiCorp Configuration Language).** Linguagem declarativa em que o código Terraform é escrito (arquivos `.tf`).

## I

**IaC (Infraestrutura como Código).** Prática de descrever a infraestrutura em arquivos versionados e aplicá-la por ferramenta automatizada, em vez de configurá-la manualmente (MH-INFRA-002).

**IAM (Identity and Access Management).** Serviço da AWS que controla identidades e permissões. Veja: [02-conceitos-fundamentais-de-nuvem.md](02-conceitos-fundamentais-de-nuvem.md).

**Idempotência.** Propriedade de uma operação que produz o mesmo resultado quando executada várias vezes. No Terraform, aplicar o mesmo código duas vezes não duplica recursos; o segundo plan informa "No changes".

**Imagem (de container).** Pacote imutável com o sistema de arquivos e as instruções de inicialização de uma aplicação.

**IMDSv2 (Instance Metadata Service, versão 2).** Versão do serviço de metadados das instâncias EC2 que exige um token de sessão obtido por requisição `PUT`, o que dificulta o roubo de credenciais da instância por ataques de falsificação de requisição (SSRF). No projeto, deve ser obrigatória na instância do fck-nat.

**Import.** Operação que associa ao state do Terraform um recurso criado fora dele, para que passe a ser gerenciado pelo código.

**Internet Gateway (IGW).** Componente que conecta uma VPC à internet nos dois sentidos. Sub-redes cuja rota padrão aponta para ele são públicas.

**Issue.** Unidade de trabalho registrada no GitHub. O estado de cada issue (prioridade, sprint, status) é mantido no GitHub Project, e não em documentos.

## J

**JWT (JSON Web Token).** Formato de token assinado digitalmente que transporta claims sobre uma identidade. O GitHub emite um JWT para cada job que solicita identidade OIDC.

## K

**KMS (Key Management Service).** Serviço da AWS para criar e controlar chaves criptográficas usadas na cifragem de dados.

## L

**Latência p95.** Valor abaixo do qual estão 95% dos tempos de resposta medidos. É mais representativo da experiência do usuário do que a média.

**LCU (Load Balancer Capacity Unit).** Unidade de cobrança do ALB que considera novas conexões, conexões ativas, volume de dados e avaliação de regras. O custo do ALB é a soma de uma parcela por hora e de uma parcela por LCU-hora.

**Least privilege.** Veja **Menor privilégio**.

**LGPD (Lei Geral de Proteção de Dados Pessoais).** Lei nº 13.709/2018, que regula o tratamento de dados pessoais no Brasil. A plataforma trata dados de estudantes; por isso dados de produção nunca são copiados para máquinas locais nem para o CI, e logs não contêm dados pessoais desnecessários. Veja: [13-seguranca-da-infraestrutura.md](13-seguranca-da-infraestrutura.md).

**Lifecycle (ciclo de vida).** No S3 e no ECR, regras que expiram ou movem objetos e imagens antigos. No Terraform, o bloco `lifecycle` altera o comportamento de criação, alteração e remoção de um recurso.

**Listener.** Componente do ALB que escuta uma porta e um protocolo e aplica regras de roteamento.

**Lock (trava do state).** Mecanismo que impede duas execuções simultâneas do Terraform sobre o mesmo state. Com `use_lockfile = true`, o lock é um arquivo `.tflock` no próprio bucket S3. Veja: [03-terraform-fundamentos.md](03-terraform-fundamentos.md).

**Locals (bloco `locals`).** Valores internos de um módulo Terraform, calculados a partir de variáveis ou outros valores, para evitar repetição.

## M

**`main` (branch).** Branch principal dos repositórios, que representa o estado aprovado do código.

**Menor privilégio (princípio do).** Princípio segundo o qual cada identidade recebe apenas as permissões estritamente necessárias para sua função.

**Merge.** Incorporação das alterações de uma branch em outra. O projeto adota squash merge, que condensa os commits do pull request em um só.

**Métrica.** Série numérica medida ao longo do tempo, como uso de CPU ou quantidade de erros HTTP 5xx.

**MFA (autenticação multifator).** Exigência de um segundo fator, além da senha, para autenticar uma identidade.

**Migration.** Script versionado que altera a estrutura do banco de dados de forma controlada. No projeto, as migrations pertencem ao repositório de banco de dados e são executadas por uma task pontual do ECS.

**MiniStack.** Emulador de código aberto da API da AWS, executado em container, usado no laboratório local. Veja: [05-laboratorio-local-ministack.md](05-laboratorio-local-ministack.md).

**Módulo (Terraform).** Conjunto reutilizável de recursos que recebe variáveis e devolve outputs. Veja: [03-terraform-fundamentos.md](03-terraform-fundamentos.md).

**Multi-AZ.** Configuração do RDS que mantém uma réplica em outra zona de disponibilidade, com troca automática em caso de falha.

## N

**NACL (Network ACL).** Firewall sem estado aplicado a uma sub-rede inteira, com regras de permissão e de negação.

**NAT (Network Address Translation).** Componente que permite a recursos em sub-rede privada iniciar conexões para a internet sem serem alcançáveis a partir dela. Na AWS, o serviço gerenciado é o NAT Gateway.

## O

**Observabilidade.** Capacidade de entender o comportamento de um sistema a partir de seus logs, métricas e traces (POL-INFRA-002).

**OIDC (OpenID Connect).** Protocolo de identidade em que um emissor confiável (o GitHub) assina tokens que comprovam a identidade de quem os apresenta. A AWS aceita esses tokens para emitir credenciais temporárias. Veja: [07-oidc-github-actions-aws.md](07-oidc-github-actions-aws.md).

**OIDC provider (IAM).** Registro, em uma conta AWS, de um emissor de tokens OIDC confiável. É necessário um por conta.

**On-demand.** Modalidade de preço sem compromisso de uso, cobrada por hora ou segundo. É a referência das estimativas do projeto.

**Output (bloco `output`).** Valor que um módulo Terraform expõe para outros módulos ou para quem o executa. Valores sensíveis devem usar `sensitive = true`.

## P

**Parameter group.** Conjunto de parâmetros de configuração de um banco RDS, como `rds.force_ssl = 1`.

**Período pré-go-live.** Intervalo entre a criação do ambiente de produção e o go-live (INF-019). Nele, a conta de produção ainda não tem usuários nem dados reais e recebe os testes que exigem a AWS real, como carga, rollback e restore. Veja: [01-visao-geral-da-plataforma.md](01-visao-geral-da-plataforma.md#7-ambientes).

**Permissions boundary (limite de permissões).** Policy IAM associada a uma role que define o máximo de permissões que ela pode ter, independentemente das policies anexadas. No projeto, a role de apply do Terraform só pode criar roles com o boundary `plataforma-workload-boundary`, o que impede a criação de uma role mais poderosa que ela própria. Veja: [07-oidc-github-actions-aws.md](07-oidc-github-actions-aws.md).

**PITR (Point-in-Time Recovery).** Restauração de um banco RDS para qualquer instante dentro do período de retenção de backups.

**Plan (`terraform plan`).** Comando que compara o código com o state e com a nuvem e mostra o que será criado (`+`), alterado (`~`), removido (`-`) ou recriado (`-/+`), sem executar nada. Veja: [03-terraform-fundamentos.md](03-terraform-fundamentos.md).

**Policy.** Documento JSON que define permissões no IAM, com efeito, ações, recursos e condições.

**Prefix list.** Lista nomeada de blocos CIDR que pode ser usada em regras de security group. A AWS mantém a prefix list `com.amazonaws.global.cloudfront.origin-facing`, com os endereços do CloudFront, usada para que o ALB aceite tráfego somente vindo do CloudFront.

**Promoção de artefato.** Implantação, em um ambiente posterior, do mesmo artefato já validado no ambiente anterior, sem reconstruí-lo.

**Provider (Terraform).** Plugin que permite ao Terraform conversar com a API de uma plataforma, como `hashicorp/aws`.

**Pull request (PR).** Solicitação, no GitHub, para incorporar as alterações de uma branch em outra, com revisão e execução de checks. Veja: [04-padroes-e-fluxo-de-trabalho.md](04-padroes-e-fluxo-de-trabalho.md).

## R

**RDS (Relational Database Service).** Serviço gerenciado de banco de dados relacional da AWS. O projeto usa PostgreSQL 16 (ADR-002).

**Região.** Área geográfica da AWS com várias zonas de disponibilidade, como `us-east-1`.

**Registry.** Repositório de imagens de container. Na AWS, o ECR.

**Release manager.** Pessoa autorizada a disparar a implantação em produção. Veja: [08-cicd-no-plano-free-do-github.md](08-cicd-no-plano-free-do-github.md).

**Repository dispatch.** Evento do GitHub Actions disparado por uma chamada externa à API, que inicia um workflow.

**Resource (bloco `resource`).** Bloco do Terraform que descreve um objeto de infraestrutura que o Terraform cria e gerencia.

**Role (função IAM).** Identidade sem credencial fixa, assumida temporariamente por pessoas, serviços ou pipelines por meio do STS.

**Rollback.** Retorno de um sistema a uma versão anterior conhecida e estável após uma falha. No projeto, o rollback de aplicação reimplanta o digest anterior (INF-018).

**Root module.** Diretório onde o Terraform é executado, que chama os módulos e possui seu próprio state. No projeto, cada pasta em `environments/` é um root module.

**Rota padrão (`0.0.0.0/0`).** Entrada de uma tabela de rotas que representa qualquer destino, ou seja, a internet.

**Route 53.** Serviço de DNS da AWS.

**RPO (Recovery Point Objective).** Perda máxima aceitável de dados após uma falha, medida em tempo.

**RTO (Recovery Time Objective).** Tempo máximo aceitável para restabelecer o serviço após uma falha.

**Ruleset.** Recurso do GitHub que aplica regras a branches e tags de um ou vários repositórios. Indisponível em repositórios privados no plano Free.

**Runbook.** Procedimento operacional passo a passo para uma tarefa, como deploy, rollback ou resposta a incidente. Os runbooks do projeto ficam em `_KB/operations/runbooks/`.

## S

**S3 (Simple Storage Service).** Serviço de armazenamento de objetos da AWS.

**SBOM (Software Bill of Materials).** Inventário dos componentes e dependências, com versões, contidos em um artefato, como uma imagem de container. Gerado por ferramentas como Trivy ou Syft e anexado ao release, permite saber rapidamente se uma vulnerabilidade recém-publicada afeta a versão em produção.

**Scan on push.** Varredura automática de vulnerabilidades em cada imagem enviada ao ECR.

**Secrets Manager.** Serviço da AWS para armazenar e controlar o acesso a segredos.

**Security Group (SG).** Firewall com estado aplicado a cada recurso, com regras apenas de permissão. Pode usar outro security group como origem, o que permite encadear camadas.

**Sensitive.** Marcação de variáveis e outputs do Terraform que impede a exibição do valor nas saídas do terminal. O valor continua gravado no state.

**SHA.** Hash criptográfico. No Git, identifica um commit de forma única; no projeto, actions de terceiros são fixadas por SHA de commit (POL-INFRA-001).

**Smoke test.** Conjunto mínimo e rápido de verificações executado logo após um deploy para confirmar que as funções essenciais respondem.

**Snapshot.** Cópia completa de um volume ou banco de dados em um instante, usada para restauração.

**SNS (Simple Notification Service).** Serviço de envio de mensagens para assinantes, usado para alertas.

**SSE (Server-Side Encryption).** Cifragem dos dados pelo serviço no momento da gravação. No S3, pode usar chaves gerenciadas pela AWS (`AES256`) ou pelo KMS.

**SSR (Server-Side Rendering).** Geração do HTML de uma página no servidor, a cada requisição. O frontend Next.js exige um runtime capaz de SSR (ADR-010).

**Staging.** Ambiente de validação, próximo ao de produção, onde tradicionalmente ocorrem os testes ponta a ponta, de carga e de segurança. Na Plataforma Digital não há staging na AWS (decisão de 2026-10-07): o papel é cumprido pelo **ambiente de validação efêmera** e, até o go-live, pela própria conta de produção. A faixa `10.20.0.0/16` fica reservada caso ele volte a existir. Veja: [01-visao-geral-da-plataforma.md](01-visao-geral-da-plataforma.md#7-ambientes).

**State (Terraform).** Arquivo que registra a correspondência entre os recursos do código e os recursos reais. Pode conter segredos; por isso é armazenado remotamente, cifrado e com acesso restrito (MH-INFRA-001). Veja: [03-terraform-fundamentos.md](03-terraform-fundamentos.md).

**STS (Security Token Service).** Serviço da AWS que emite credenciais temporárias ao validar a trust policy de uma role.

**sub (claim).** Campo de um token JWT que identifica o sujeito. Nos tokens do GitHub, descreve o repositório e o contexto do job (branch, environment ou pull request), e é o principal elemento conferido pela trust policy. Veja: [07-oidc-github-actions-aws.md](07-oidc-github-actions-aws.md).

**Sub-rede (subnet).** Fatia do bloco CIDR de uma VPC, localizada em uma zona de disponibilidade. É pública ou privada conforme sua tabela de rotas.

## T

**Tabela de rotas (route table).** Conjunto de regras que define para onde o tráfego de uma sub-rede é encaminhado.

**Tag (AWS).** Par chave e valor associado a um recurso, usado para organização e para separar custos (por exemplo, `Environment=production`).

**Tag (imagem de container).** Rótulo legível de uma imagem, como `1.4.0`. Pode ser configurada como imutável no ECR.

**Target group.** Conjunto de destinos para os quais o ALB encaminha o tráfego de uma regra, com seu próprio health check.

**Task (ECS).** Execução de uma task definition, composta de um ou mais containers.

**Task definition.** Especificação versionada de como executar uma aplicação no ECS: imagem, CPU, memória, portas, segredos, logs e roles.

**Task role.** Role assumida pela aplicação em execução para acessar outros serviços da AWS.

**Terraform.** Ferramenta de Infraestrutura como Código adotada pelo projeto. Veja: [03-terraform-fundamentos.md](03-terraform-fundamentos.md).

**tflint.** Ferramenta de análise estática de código Terraform que aponta erros e más práticas não detectados pelo `validate`.

**TLS (Transport Layer Security).** Protocolo que cifra a comunicação em rede. HTTPS é HTTP sobre TLS.

**Trivy.** Ferramenta de código aberto que, entre outras funções, verifica configurações inseguras em código de infraestrutura (`trivy config`).

**Trust policy (política de confiança).** Documento de uma role IAM que define quem pode assumi-la e sob quais condições.

## U

**URL pré-assinada.** Endereço temporário, gerado por quem tem permissão, que autoriza uma operação específica em um objeto do S3 por tempo limitado, sem expor credenciais.

## V

**Validate (`terraform validate`).** Comando que verifica sintaxe e tipos do código Terraform, sem acessar a nuvem.

**Variable (bloco `variable`).** Parâmetro de entrada de um módulo Terraform, com tipo, valor padrão opcional e regras de validação.

**VPC (Virtual Private Cloud).** Rede privada e isolada dentro de uma conta AWS. Veja: [02-conceitos-fundamentais-de-nuvem.md](02-conceitos-fundamentais-de-nuvem.md).

**VPC Endpoint.** Conexão privada entre uma VPC e um serviço AWS, sem passar pela internet. O endpoint do tipo gateway para S3 é gratuito; os do tipo interface são cobrados por hora e por zona.

## W

**Workflow.** Arquivo YAML em `.github/workflows/` que define as tarefas automatizadas executadas pelo GitHub Actions.

**Workflow reutilizável.** Workflow declarado com `on: workflow_call`, que pode ser chamado por workflows de outros repositórios para padronizar verificações.

**Write-only attribute (atributo somente de escrita, Terraform).** Atributo de recurso, disponível a partir do Terraform 1.11, cujo valor é enviado ao provedor mas nunca gravado no state nem exibido no plan, como `password_wo` em `aws_db_instance` e `secret_string_wo` em `aws_secretsmanager_secret_version`. Uma mudança de valor é sinalizada por um atributo de versão (por exemplo, `password_wo_version`).

## Z

**Zona de disponibilidade.** Veja **AZ**.

---

## Referências

- HashiCorp: [Glossário do Terraform](https://developer.hashicorp.com/terraform/docs/glossary)
- AWS: [Glossário da AWS](https://docs.aws.amazon.com/glossary/latest/reference/glos-chap.html)
- AWS: [Guia do usuário do IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
- GitHub: [Documentação do GitHub Actions](https://docs.github.com/en/actions)
- GitHub: [Sobre a segurança com OpenID Connect](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
- Governança do projeto: `_KB/product/glossary.md` (termos de negócio), `_KB/governance/definition-of-ready.md`, `_KB/governance/definition-of-done.md`, ADR-008 (`_KB/architecture/adrs/ADR-008-governance-baseline.md`).
