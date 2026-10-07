---
title: "Material de apoio: Infraestrutura e Cloud & DevOps"
type: guide
normative: false
owner: Cloud & DevOps
last_updated: 2026-10-07
---

# Material de apoio: Infraestrutura e Cloud & DevOps

**Objetivo.** Este material reúne, em um só lugar, o conhecimento necessário para entender, construir e operar a infraestrutura da Plataforma Digital na AWS: os conceitos de nuvem, o Terraform, o fluxo de trabalho, a segurança do pipeline, os custos e um laboratório local para praticar sem gastar nada. Ele foi escrito para consulta contínua, tanto por quem está começando quanto por quem precisa relembrar um detalhe.

## Natureza deste material

Este é um material **didático e não normativo**. Ele explica e exemplifica o que está decidido nos documentos oficiais da governança, mas não os substitui.

| Se a dúvida for sobre... | A fonte oficial é... |
| --- | --- |
| Decisões de arquitetura | ADRs em `_KB/architecture/adrs/` |
| Regras obrigatórias de infraestrutura | `_KB/must-haves/infrastructure.md` (MH-INFRA-001 a 003) |
| Políticas de CI/CD, observabilidade, infraestrutura e custos | POL-INFRA-001 a 004 (`_KB/engineering/ci-cd.md`, `_KB/engineering/observability.md`, `_KB/operations/infrastructure.md`, `_KB/operations/finops.md`) |
| Procedimentos operacionais | Runbooks em `_KB/operations/runbooks/` |
| Processo de trabalho, Definition of Ready e Definition of Done | `_KB/governance/` |
| Escopo, critérios de aceite e estado de cada tarefa | A issue no GitHub e o GitHub Project |

Em caso de conflito entre este material e um documento normativo da `_KB`, **prevalece o documento normativo**. Se encontrar uma divergência, abra uma issue ou um PR corrigindo este material.

## Decisão de ambientes

Em 2026-10-07, o projeto decidiu que **apenas o ambiente de produção existe na AWS**, para manter o orçamento de US$ 120 por mês (POL-INFRA-004). O desenvolvimento acontece na máquina de cada pessoa, com Docker Compose e o emulador MiniStack, e a validação que caberia a um ambiente de staging é feita em um ambiente efêmero criado dentro do pipeline do GitHub Actions. Até o go-live, a conta de produção, ainda sem usuários nem dados reais, recebe os testes que exigem a AWS real. A decisão está registrada no ADR-012 (`_KB/architecture/adrs/ADR-012-production-only-aws.md`). Os detalhes estão em [01 Visão geral](01-visao-geral-da-plataforma.md#7-ambientes).

## Como usar

O material pode ser lido em sequência, como um curso, ou consultado por tema. A tabela abaixo indica o conteúdo de cada documento e o momento em que ele é mais útil.

| Nº | Documento | Conteúdo | Quando consultar |
| --- | --- | --- | --- |
| 01 | [Visão geral da plataforma](01-visao-geral-da-plataforma.md) | O que é a Plataforma Digital, os repositórios, a arquitetura na AWS e as decisões que a definem | Primeiro contato com o projeto |
| 02 | [Conceitos fundamentais de nuvem](02-conceitos-fundamentais-de-nuvem.md) | Conta, região, IAM, redes, containers e cada serviço AWS usado | Antes de qualquer trabalho técnico |
| 03 | [Terraform: fundamentos](03-terraform-fundamentos.md) | Linguagem, state, plan, módulos, drift e erros comuns | Antes de escrever ou revisar código de infraestrutura |
| 04 | [Padrões e fluxo de trabalho](04-padroes-e-fluxo-de-trabalho.md) | Issue, branch, PR, revisão, convenções e checagens | Antes de abrir o primeiro PR |
| 05 | [Laboratório local com MiniStack](05-laboratorio-local-ministack.md) | Emulador da AWS no próprio computador, comandos e exercícios | Para praticar sem custo e sem conta AWS |
| 06 | [Backlog de infraestrutura](06-backlog-de-infraestrutura.md) | As 21 issues INF explicadas, critérios de aceite de referência e dependências | Ao refinar ou iniciar uma issue |
| 07 | [OIDC: GitHub Actions na AWS](07-oidc-github-actions-aws.md) | Autenticação do pipeline sem chaves de acesso fixas | Ao trabalhar com CI/CD ou IAM |
| 08 | [CI/CD no plano Free do GitHub](08-cicd-no-plano-free-do-github.md) | Como manter o deploy seguro sem os recursos pagos do GitHub | Ao desenhar pipelines de deploy |
| 09 | [Custos e FinOps](09-custos-e-finops.md) | Como a AWS cobra, estimativas, alavancas de economia e controles | Antes de decisões de arquitetura |
| 10 | [Diagramas](10-diagramas.md) | Todos os diagramas do material reunidos | Consulta visual rápida |
| 11 | [Glossário](11-glossario.md) | Definição dos termos técnicos usados | Sempre que encontrar um termo desconhecido |
| 12 | [Perguntas frequentes](12-perguntas-frequentes.md) | Respostas curtas às dúvidas mais comuns | Dúvidas pontuais |
| 13 | [Segurança da infraestrutura](13-seguranca-da-infraestrutura.md) | Linha de base de segurança da conta AWS, do GitHub, do pipeline, da rede, dos containers e dos dados, com prioridades e custos | Antes de implementar ou revisar qualquer recurso exposto, IAM ou com dados |

O laboratório prático está em [`exemplos/lab-terraform-local/`](exemplos/lab-terraform-local/).

## Trilhas de estudo sugeridas

**Trilha 1: primeiro contato (cerca de 4 horas)**

1. Ler [01 Visão geral](01-visao-geral-da-plataforma.md) e [02 Conceitos fundamentais](02-conceitos-fundamentais-de-nuvem.md).
2. Instalar os pré-requisitos e executar o exemplo do primeiro bucket no [05 Laboratório](05-laboratorio-local-ministack.md).
3. Ler as seções 1 a 6 de [03 Terraform](03-terraform-fundamentos.md).

**Trilha 2: pronto para contribuir (cerca de 6 horas)**

1. Concluir a trilha 1.
2. Ler o restante de [03 Terraform](03-terraform-fundamentos.md) e todo o [04 Padrões e fluxo de trabalho](04-padroes-e-fluxo-de-trabalho.md).
3. Subir o ambiente `development` completo no laboratório e fazer os exercícios de drift, lock e novo ambiente.
4. Ler, no [06 Backlog](06-backlog-de-infraestrutura.md), a issue em que vai trabalhar e as issues das quais ela depende.

**Trilha 3: pipeline, segurança e custos (cerca de 6 horas)**

1. Ler [07 OIDC](07-oidc-github-actions-aws.md) e [08 CI/CD no plano Free](08-cicd-no-plano-free-do-github.md).
2. Executar o módulo de OIDC no laboratório.
3. Ler [13 Segurança da infraestrutura](13-seguranca-da-infraestrutura.md) e conferir, no código do laboratório, quais controles já estão implementados.
4. Ler [09 Custos e FinOps](09-custos-e-finops.md) e refazer uma das estimativas na AWS Pricing Calculator.

## Pré-requisitos técnicos

| Ferramenta | Uso | Obrigatória |
| --- | --- | --- |
| Git | Clonar os repositórios e versionar mudanças | Sim |
| Docker (Docker Desktop no macOS e no Windows com WSL2) | Executar o laboratório local | Sim |
| `make` | Atalhos de comandos do laboratório | Sim |
| Terraform 1.10 ou superior | Executar o Terraform fora de container | Não (o laboratório usa um container quando ele não está instalado) |
| AWS CLI v2 | Consultar recursos | Não (o laboratório inclui um container com a CLI) |
| Editor com suporte a HCL e Markdown (por exemplo, VS Code com as extensões HashiCorp Terraform e Markdown Preview Mermaid) | Editar código e visualizar diagramas | Recomendado |

Conhecimentos prévios desejáveis: uso básico de terminal, Git (clone, branch, commit, push) e noções de HTTP. Nenhum conhecimento prévio de AWS ou Terraform é necessário.

## Convenções deste material

- **Comandos** aparecem em blocos de código e devem ser executados a partir do diretório indicado no texto.
- **Códigos de issue** (por exemplo, INF-001) servem para rastreabilidade com o backlog em `backlogs/cloud-devops.md` e com as issues do repositório `plataforma-infrastructure`.
- **Valores de preço e versões** trazem a data em que foram consultados. Confira sempre a fonte oficial antes de tomar uma decisão baseada neles.
- **Diagramas** usam Mermaid, que é renderizado pelo GitHub, pelo VS Code (pré-visualização de Markdown) e pelo Obsidian. Para exportar como imagem, use o editor em [mermaid.live](https://mermaid.live).

## Manutenção

Este material evolui junto com o projeto. Ao alterar uma decisão de arquitetura, uma política ou o código do laboratório, atualize o documento correspondente no mesmo PR ou abra uma issue para isso. Mudanças seguem o fluxo normal de PR do repositório de governança.
