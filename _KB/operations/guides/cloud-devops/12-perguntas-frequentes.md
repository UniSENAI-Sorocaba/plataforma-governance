---
title: "Perguntas frequentes"
type: guide
normative: false
owner: Cloud & DevOps
last_updated: 2026-10-07
---

# Perguntas frequentes

**Objetivo.** Responder de forma direta às dúvidas mais comuns sobre a infraestrutura da Plataforma Digital. Cada resposta indica onde o assunto é tratado em profundidade.

**Pré-requisitos de leitura:** nenhum. Para termos desconhecidos, consulte o [11 Glossário](11-glossario.md).

## Sumário

1. [Arquitetura e decisões](#1-arquitetura-e-decisões)
2. [Terraform](#2-terraform)
3. [Laboratório local](#3-laboratório-local)
4. [Segurança e pipeline](#4-segurança-e-pipeline)
5. [Custos](#5-custos)
6. [Segurança](#6-segurança)
7. [Processo de trabalho](#7-processo-de-trabalho)

---

## 1. Arquitetura e decisões

**Por que AWS e Terraform, e não CloudFormation?**
A escolha da AWS e da infraestrutura como código está registrada nas políticas do projeto (MH-INFRA-002, POL-INFRA-003). O Terraform foi adotado por ser amplamente usado no mercado, funcionar com vários provedores de nuvem e ter uma linguagem declarativa legível. O CloudFormation é exclusivo da AWS.

**Por que ECS Fargate, e não servidores EC2 ou Kubernetes?**
O ADR-004 escolheu o Fargate porque ele executa containers sem que a equipe precise administrar servidores, sistemas operacionais ou atualizações de segurança. O EKS (Kubernetes gerenciado) foi descartado pela curva de aprendizado e pelo custo fixo de cerca de US$ 73 por mês apenas para o plano de controle. Instâncias EC2 exigiriam manutenção contínua do sistema operacional.

**Por que um único banco de dados para todos os módulos?**
O ADR-002 definiu uma instância RDS PostgreSQL 16 com um schema por domínio (`auth`, `academic_pi`, `extension` etc.). Várias instâncias custariam mais de US$ 150 por mês e multiplicariam o trabalho de backup. Os schemas mantêm a separação lógica entre os domínios.

**Por que o frontend não pode ficar apenas em um bucket S3?**
O Next.js da plataforma usa renderização no servidor (SSR): parte das páginas é montada no momento da requisição, o que exige um processo em execução. Um bucket S3 só entrega arquivos prontos. Por isso o ADR-010 exige um runtime SSR, e o S3 com CloudFront fica responsável apenas por arquivos estáticos e cache. Veja [01 Visão geral](01-visao-geral-da-plataforma.md#6-decisões-oficiais-que-definem-a-infraestrutura).

**Por que não há staging na AWS?**
Para caber no orçamento de US$ 120 por mês (POL-INFRA-004). Um staging permanente na AWS custaria de US$ 20 a US$ 150 por mês, conforme o desenho, e reduziria a margem para produção e para os reforços de segurança. Em 2026-10-07, o projeto decidiu manter na AWS apenas produção; a decisão está registrada no ADR-012. O papel do staging passa a ser cumprido pelo ambiente de validação efêmera no CI e, até o go-live, pela própria conta de produção, que ainda não tem usuários nem dados reais. Veja [01 Visão geral](01-visao-geral-da-plataforma.md#7-ambientes).

**Onde a equipe de qualidade executa E2E, carga e DAST?**
No ambiente de validação efêmera, criado dentro do job do GitHub Actions: a imagem recém-construída, um PostgreSQL 16 e o MiniStack sobem com Docker Compose, recebem dados sintéticos e são descartados ao final. Ali rodam smoke, contrato, E2E (Playwright), DAST (ZAP baseline) e k6 em escala reduzida. O teste de carga completo, a 200 RPS, precisa da infraestrutura real e é executado na conta de produção antes do go-live (INF-017). Depois do go-live, só em janela controlada e comunicada.

**Como testar restore e carga sem staging?**
Até o go-live, diretamente na conta de produção, que ainda não tem usuários nem dados reais: o ensaio de restore (INF-016), o teste de carga (INF-017) e o ensaio de rollback (INF-018) acontecem nesse período. Depois do go-live, o restore é ensaiado em uma instância temporária criada a partir de um snapshot **dentro da conta de produção** e destruída ao final, para que dados pessoais nunca saiam da conta (LGPD).

**Por que produção fica em uma conta AWS dedicada?**
O ADR-011 e o MH-INFRA-003 exigem o isolamento de produção. Como a conta AWS do projeto contém apenas produção, esse isolamento é garantido por construção: não existe nenhum recurso de non-production na mesma conta, e os ambientes de desenvolvimento e de validação executam fora da AWS, sem credenciais de produção.

**O banco fica acessível pela internet?**
Não. O RDS fica em sub-rede privada, com `publicly_accessible = false`, e o security group dele aceita conexões apenas do security group da aplicação. Veja [02 Conceitos fundamentais](02-conceitos-fundamentais-de-nuvem.md) e o diagrama de rede em [10 Diagramas](10-diagramas.md#3-rede-sub-redes-e-security-groups).

## 2. Terraform

**Por que não criar os recursos pelo console da AWS?**
Uma mudança feita no console não é reproduzível, não passa por revisão e não deixa histórico no Git. Além disso, ela cria uma divergência (drift) entre o código e a realidade: no próximo `apply`, o Terraform desfaz a alteração manual. O exercício de drift do laboratório demonstra esse comportamento. Veja [03 Terraform: fundamentos](03-terraform-fundamentos.md).

**O que é o state e por que ele precisa ser remoto?**
O state é o arquivo em que o Terraform registra a correspondência entre cada recurso do código e o recurso real na AWS. Sem ele, o Terraform não sabe o que já criou. O state pode conter segredos em texto puro, por isso precisa ficar em um bucket cifrado, versionado e com acesso restrito, e nunca no Git. Ficar em um local compartilhado também permite o lock, que impede duas execuções simultâneas (INF-001).

**Se eu executar o `apply` duas vezes, os recursos são criados em dobro?**
Não. O Terraform é declarativo e idempotente: na segunda execução, ele compara o código com o state, não encontra diferença e responde `No changes`.

**O que significa `-/+` no plan?**
Que o recurso será destruído e criado novamente, porque um atributo que não pode ser alterado no lugar foi modificado. Em um banco de dados, isso significa perda de dados se não houver backup. Todo `-/+` precisa ser entendido antes da aprovação. Veja a seção sobre leitura do plan em [03 Terraform: fundamentos](03-terraform-fundamentos.md).

**Renomeei um recurso no código e o plan quer apagá-lo. O que fazer?**
Para o Terraform, um novo nome é um novo recurso. Use um bloco `moved { from = ..., to = ... }` para informar que se trata do mesmo recurso. Veja [03 Terraform: fundamentos](03-terraform-fundamentos.md).

**Por que existe a pasta `bootstrap/`?**
O bucket que guarda o state não pode guardar o próprio state, pois precisa existir antes dele. O `bootstrap/` cria esse bucket uma única vez, com state local. Depois disso, os ambientes guardam seus states nesse bucket.

## 3. Laboratório local

**Preciso de uma conta AWS ou de um cartão de crédito para praticar?**
Não. O laboratório usa o MiniStack, um emulador da AWS que executa em container no seu computador, sem cadastro e sem custo. Veja [05 Laboratório local com MiniStack](05-laboratorio-local-ministack.md).

**Preciso instalar o Terraform?**
Não é obrigatório. O Makefile do laboratório executa o Terraform em um container quando ele não está instalado. Instalar localmente deixa os comandos mais rápidos e permite usar a extensão do editor.

**O emulador é igual à AWS?**
Não. Ele reproduz a API da AWS, mas, na configuração padrão, não aplica permissões IAM, não verifica a assinatura de tokens OIDC, não cria redes reais e ignora alguns atributos. Ele serve para aprender e validar a estrutura do código. O comportamento real, especialmente o de segurança, só é comprovado na AWS, na conta de produção, preferencialmente no período anterior ao go-live.

**Reiniciei o computador e tudo sumiu. É normal?**
Sim. Na configuração padrão, o MiniStack guarda os recursos em memória. Execute `make reset` para limpar os states locais desatualizados, ligar o emulador e recriar o bucket do state.

**E se eu quebrar algo no laboratório?**
Nada é afetado fora do seu computador. Execute `make down` (ou `make reset`) e comece novamente.

## 4. Segurança e pipeline

**Por que não usar uma chave de acesso da AWS nos secrets do GitHub?**
Uma chave de acesso é uma credencial de longa duração: se vazar, ela continua válida até ser revogada manualmente. Com OIDC, cada execução do pipeline recebe uma credencial temporária, que expira em cerca de uma hora e só vale para uma role com permissões mínimas. A POL-INFRA-001 exige esse modelo. Veja [07 OIDC](07-oidc-github-actions-aws.md).

**Onde ficam as senhas do banco e outros segredos?**
No AWS Secrets Manager. O Terraform cria o segredo, e a aplicação o recebe no momento da execução, pela task definition do ECS. Segredos nunca aparecem no código, em outputs do Terraform ou em logs (MH-INFRA-001, INF-008).

**Por que fixar as actions do GitHub pelo SHA do commit, e não pela versão?**
Uma tag como `v4` pode ser movida para outro commit pelo autor da action, inclusive por alguém que comprometeu a conta dele. O SHA identifica exatamente um conteúdo e não pode ser alterado (POL-INFRA-001).

**O que muda por a organização estar no plano Free do GitHub com repositórios privados?**
Nesse cenário, environments, regras de proteção de branch e rulesets não estão disponíveis. As travas de segurança precisam ser deslocadas para as trust policies da AWS e para as permissões dos repositórios. O desenho completo está em [08 CI/CD no plano Free](08-cicd-no-plano-free-do-github.md).

**Por que a imagem validada no CI deve ser a mesma implantada em produção?**
Porque o que foi testado precisa ser exatamente o que chega a produção. Recompilar gera um artefato diferente, que não passou pelos testes. A imagem é construída uma vez, validada no ambiente efêmero, publicada no ECR e implantada pelo digest (`sha256:...`), que é único para cada conteúdo.

## 5. Custos

**Testar no laboratório gera cobrança?**
Não. O laboratório executa localmente. Recursos reais só são criados na AWS pelo pipeline.

**Quanto custa a infraestrutura da plataforma?**
Como apenas produção existe na AWS, o orçamento de US$ 120 por mês cobre só esse ambiente. A estimativa de [09 Custos e FinOps](09-custos-e-finops.md) varia de US$ 77,06 (variante P1: instância fck-nat e RDS em uma zona) a US$ 120,66 (variante P4: NAT Gateway e RDS Multi-AZ, que estoura o orçamento). A variante recomendada, P3 (RDS Multi-AZ e fck-nat com recuperação automática), custa cerca de US$ 91 por mês, ou cerca de US$ 95 com os reforços de segurança essenciais.

**Por que um recurso parado gera custo?**
Na AWS, vários recursos são cobrados por hora de existência, e não por uso: um NAT Gateway custa cerca de US$ 33 por mês mesmo sem tráfego, e cada endereço IPv4 público custa cerca de US$ 3,65 por mês. Por isso ambientes que não estão em uso devem ser destruídos ou desligados.

**O orçamento de US$ 120 desliga a infraestrutura quando é atingido?**
Não. A POL-INFRA-004 define alertas em 50%, 80% e 100% do valor, sem nenhuma ação destrutiva automática. Quando um alerta dispara, a equipe investiga o desvio e propõe uma correção.

## 6. Segurança

**Quais são as medidas de segurança mais importantes da conta AWS?**
MFA no usuário root e nenhuma chave de acesso dele; poucos administradores humanos, todos com MFA; bloqueio de acesso público ao S3 no nível da conta; CloudTrail registrando todas as chamadas à API; GuardDuty para detecção de ameaças; e IAM Access Analyzer para encontrar recursos expostos. A lista completa, com prioridades e custos, está em [13 Segurança da infraestrutura](13-seguranca-da-infraestrutura.md).

**O pipeline pode criar uma role mais poderosa que ele próprio?**
Não deveria. A role de apply do Terraform só pode criar roles com o permissions boundary `plataforma-workload-boundary` e não pode alterar as roles de CI, o provedor OIDC nem o próprio boundary. Veja [07 OIDC](07-oidc-github-actions-aws.md).

**Como a senha do banco fica fora do state do Terraform?**
A forma preferida é `manage_master_user_password = true`, em que a própria AWS gera e guarda a senha no Secrets Manager. Uma alternativa, a partir do Terraform 1.11, é gerar a senha com um recurso efêmero e entregá-la por atributos write-only (`password_wo`, `secret_string_wo`), que nunca são gravados no state. Veja [13 Segurança da infraestrutura](13-seguranca-da-infraestrutura.md).

**O GitHub detecta segredos e vulnerabilidades no código automaticamente?**
Não nos repositórios privados do plano Free: secret scanning e code scanning (CodeQL) são recursos pagos nesse cenário. O projeto compensa com gitleaks (pre-commit e CI), Semgrep CE ou equivalente, Trivy para dependências e imagens, e Dependabot. Veja [13 Segurança da infraestrutura](13-seguranca-da-infraestrutura.md).

**Posso copiar dados de produção para testar um problema localmente?**
Não. A plataforma trata dados pessoais de estudantes (LGPD). Dados de produção não saem da conta de produção; testes locais e no CI usam seeds sintéticos. Se um problema só se reproduz com dados reais, a investigação acontece dentro da conta de produção, com acesso registrado.

## 7. Processo de trabalho

**Posso começar a trabalhar em qualquer issue?**
A issue precisa estar em `Ready`: critérios de aceite numerados e verificáveis, dependências resolvidas e responsável e revisor de acordo (Definition of Ready, em `_KB/governance/definition-of-ready.md`). Veja [04 Padrões e fluxo de trabalho](04-padroes-e-fluxo-de-trabalho.md).

**O que um PR de infraestrutura precisa conter?**
A referência à issue (`Closes #N`), a descrição da mudança, a saída do `terraform plan`, os riscos, o procedimento de rollback e as evidências dos critérios de aceite. As checagens `fmt`, `validate`, `tflint` e a análise de segurança do IaC precisam passar. Veja o modelo em [04 Padrões e fluxo de trabalho](04-padroes-e-fluxo-de-trabalho.md).

**Onde fica o status de uma tarefa?**
No GitHub Project. Documentos em Markdown, incluindo este material, não registram o estado das tarefas.

**Encontrei um erro ou algo desatualizado neste material. O que faço?**
Abra uma issue ou um PR no repositório de governança corrigindo o documento. Se o erro envolver uma regra ou decisão, a correção deve ser feita primeiro no documento normativo da `_KB`.

**Fiquei bloqueado em um problema técnico. O que fazer?**
Consulte primeiro a seção de solução de problemas do documento relacionado (por exemplo, [05 Laboratório](05-laboratorio-local-ministack.md) ou [07 OIDC](07-oidc-github-actions-aws.md)). Se o bloqueio persistir, registre-o na issue, descrevendo o que foi tentado e a mensagem de erro, e mova a issue para `Blocked` se ela não puder avançar.
