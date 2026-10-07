---
title: "Segurança da infraestrutura"
type: guide
normative: false
owner: Cloud & DevOps
last_updated: 2026-10-07
---

# Segurança da infraestrutura

**Objetivo.** Reunir, em um único documento de referência, os controles de segurança da infraestrutura da Plataforma Digital: o que proteger, contra quais ameaças, quais controles adotar em cada camada (conta AWS, identidade, GitHub e pipeline, rede, containers, dados, detecção e resposta) e em que ordem de prioridade. O documento também registra a situação verificada em 2026-10-07, os achados no laboratório com as correções aplicadas e um checklist de segurança para o go-live.

**Pré-requisitos de leitura:** [02-conceitos-fundamentais-de-nuvem.md](02-conceitos-fundamentais-de-nuvem.md), [03-terraform-fundamentos.md](03-terraform-fundamentos.md), [07-oidc-github-actions-aws.md](07-oidc-github-actions-aws.md) e [08-cicd-no-plano-free-do-github.md](08-cicd-no-plano-free-do-github.md).

> Este documento é material de apoio e não normativo. As regras obrigatórias estão em MH-INFRA-001 a 003 (`_KB/must-haves/infrastructure.md`), na política de segurança (`_KB/security/policy.md`), na arquitetura de segurança (`_KB/architecture/security.md`) e nas políticas POL-INFRA-001 a 004. Em caso de conflito, prevalecem os documentos normativos da `_KB`. O contexto de ambientes considerado aqui é o da decisão do projeto de 2026-10-07: somente produção na AWS (ADR-012).

## Sumário

1. [Princípios](#1-princípios)
2. [Situação verificada em 2026-10-07](#2-situação-verificada-em-2026-10-07)
3. [Modelo de ameaças simplificado](#3-modelo-de-ameaças-simplificado)
4. [Como ler as tabelas de controles](#4-como-ler-as-tabelas-de-controles)
5. [Conta AWS](#5-conta-aws)
6. [Identidade e acesso](#6-identidade-e-acesso)
7. [Organização GitHub e pipeline](#7-organização-github-e-pipeline)
8. [Rede](#8-rede)
9. [Containers e ECS](#9-containers-e-ecs)
10. [Dados: banco, arquivos, state e segredos](#10-dados-banco-arquivos-state-e-segredos)
11. [Observabilidade e detecção](#11-observabilidade-e-detecção)
12. [LGPD e resposta a incidentes](#12-lgpd-e-resposta-a-incidentes)
13. [Ambiente local e validação efêmera](#13-ambiente-local-e-validação-efêmera)
14. [Achados no laboratório e correções aplicadas](#14-achados-no-laboratório-e-correções-aplicadas)
15. [Issues propostas](#15-issues-propostas)
16. [Checklist de segurança para o go-live](#16-checklist-de-segurança-para-o-go-live)
17. [Referências](#referências)

---

## 1. Princípios

| Princípio | Significado | Exemplo na plataforma |
| --- | --- | --- |
| **Defesa em profundidade** | Nenhum controle isolado é suficiente; cada camada assume que a anterior pode falhar. | O banco está em sub-rede privada **e** o Security Group só aceita a aplicação **e** a conexão exige TLS **e** os dados são cifrados em repouso. |
| **Menor privilégio** | Cada identidade recebe apenas as permissões necessárias para a sua função, e nada mais. | A role que executa `terraform plan` em PR só lê; a role que publica imagens só faz push no próprio repositório ECR. |
| **Nada fixo, segredos efêmeros** | Credenciais de longa duração são evitadas; segredos são gerados, guardados e entregues por serviços próprios, sem passar pelo código. | OIDC no lugar de chaves de acesso; senha do banco gerada e guardada pela AWS no Secrets Manager. |
| **Tudo auditável** | Toda ação relevante deixa registro que não pode ser alterado por quem a executou. | CloudTrail com validação de integridade; mudanças de infraestrutura só por PR. |
| **Segurança como código** | Controles de segurança são escritos em Terraform e em workflows, revisados por PR e verificados automaticamente. | Bucket policy de TLS, parameter group do RDS e permissions boundary no código; análise de IaC no CI. |

## 2. Situação verificada em 2026-10-07

Verificações feitas com consultas somente de leitura à API do GitHub (`gh api`), com credencial de membro, sem permissão de administrador da organização.

| Item | Situação | Consequência |
| --- | --- | --- |
| Plano da organização UniSENAI-Sorocaba | Free | Environments, required reviewers, branch protection e rulesets indisponíveis em repositórios privados (ver [08-cicd-no-plano-free-do-github.md](08-cicd-no-plano-free-do-github.md)). |
| Visibilidade dos repositórios | Privados | Recursos de segurança gratuitos apenas para repositórios públicos não se aplicam. |
| Criação de repositórios por membros | Permitida (`members_can_create_repositories: true`) | Qualquer membro pode criar repositórios na organização, inclusive públicos se a configuração permitir. Recomenda-se restringir. |
| Exigência de 2FA, permissão base dos membros, políticas de Actions | **Não verificáveis** sem permissão de administrador (a API retorna valores nulos ou `403`) | Devem ser conferidos por um administrador da organização (seção 7). |
| Secret scanning em repositórios privados | Indisponível no Free | É um recurso do **GitHub Secret Protection**, pago. |
| Code scanning (CodeQL) em repositórios privados | Indisponível no Free | É um recurso do **GitHub Code Security**, pago. |
| Dependabot alerts e atualizações de versão | Disponíveis em repositórios privados em todos os planos | Devem ser ativados (seção 7). |

**Relação com a POL-INFRA-001.** A política de CI/CD (`_KB/engineering/ci-cd.md`) exige análise estática e de secrets nos pipelines. Com repositórios privados no plano Free (e também no plano Team, que não inclui Code Security), o CodeQL hospedado no GitHub não está disponível, e a política admite ferramenta equivalente. As alternativas descritas na seção 7 (Semgrep Community Edition, Trivy, gitleaks) cumprem esse papel.

## 3. Modelo de ameaças simplificado

Um **modelo de ameaças** responde a três perguntas: o que precisa ser protegido, o que pode dar errado e o que está sendo feito a respeito.

### Ativos

| Ativo | Por que é valioso | Onde está |
| --- | --- | --- |
| Dados pessoais de estudantes, docentes e parceiros | Protegidos pela LGPD; vazamento gera dano às pessoas e responsabilidade para a instituição | RDS (schemas `auth`, `academic_pi`, `extension` etc.), bucket de uploads, logs |
| Credenciais | Dão acesso aos demais ativos | Secrets Manager, roles IAM, tokens do GitHub, contas de administradores |
| State do Terraform | Mapeia toda a infraestrutura e pode conter valores sensíveis | Bucket S3 de state |
| Imagens de container | O que executa em produção | ECR |
| Pipeline e repositórios | Quem controla o pipeline controla o que chega a produção | GitHub Actions, repositórios da organização |
| Orçamento | Abuso de recursos esgota o orçamento de US$ 120 | Conta AWS |

### Ameaças e controles

| Ameaça | Exemplo concreto | Controles principais | Onde está |
| --- | --- | --- | --- |
| Vazamento de credencial | Chave de acesso da AWS commitada em um repositório ou exposta em log do CI | OIDC sem chaves fixas; gitleaks em pre-commit e no CI; segredos fora de outputs e logs; GuardDuty detecta uso anômalo | Seções 6, 7 e 11; [07](07-oidc-github-actions-aws.md); INF-004, INF-008 |
| PR malicioso ou descuidado | Um PR altera o workflow para usar a role de plan e tentar ler segredos ou escrever recursos | Role de plan somente leitura e sem `GetSecretValue`; nunca `pull_request_target` com código do PR; revisão obrigatória por acordo | Seção 7; [07](07-oidc-github-actions-aws.md); INF-003, INF-004 |
| Escalada de privilégio via pipeline | O apply cria uma role com `AdministratorAccess` que confia na própria role do pipeline | Permissions boundary obrigatório para roles criadas pelo pipeline; Deny para editar roles de CI e o boundary | Seção 6; INF-004 |
| Exposição de bucket ou banco | Bucket de uploads tornado público; Security Group do banco aberto para `0.0.0.0/0` | Bloqueio de acesso público na conta e no bucket; banco em sub-rede privada; análise de IaC no CI; drift detectado pelo plan | Seções 5, 8 e 10; INF-002, INF-005, INF-010 |
| Dependência ou action comprometida | Uma action de terceiro tem a tag movida para código malicioso; imagem base com vulnerabilidade crítica | Actions fixadas por SHA; lista de actions permitidas; Dependabot; Trivy nas imagens; scan no push do ECR | Seções 7 e 9; INF-003, INF-006 |
| Abuso de custo | Credencial vazada usada para minerar criptomoeda; teste esquecido ligado | Budgets e Cost Anomaly Detection; GuardDuty; roles restritas à região us-east-1; teto de autoscaling | Seção 11; [09](09-custos-e-finops.md); INF-014 |
| Perda de dados | Exclusão acidental do banco; corrupção por migration; ransomware | `deletion_protection`; backups e PITR com 14 dias; Multi-AZ; restore ensaiado; versionamento no S3 | Seção 10; INF-005, INF-015, INF-016 |
| Ataque à aplicação web | Injeção, força bruta no login, volume abusivo de requisições | TLS na borda; WAF com regras gerenciadas e limite de taxa (opcional); DAST com ZAP; logs correlacionados | Seções 8 e 11; QA-026, INF-012 |

## 4. Como ler as tabelas de controles

Cada camada a seguir apresenta seus controles em tabela, com estas colunas:

- **Controle**: o que é.
- **Por que importa**: o risco que reduz.
- **Como implementar**: recurso Terraform, configuração ou ferramenta.
- **Custo**: estimativa mensal em us-east-1 (detalhes em [09-custos-e-finops.md](09-custos-e-finops.md#7-custo-dos-reforços-de-segurança)).
- **Prioridade**:
  - **Essencial**: deve estar implementado antes do go-live (INF-019).
  - **Recomendado**: deve ser implementado assim que possível, de preferência antes do go-live.
  - **Opcional**: melhora a postura de segurança; adotar conforme orçamento e tempo.
- **Issue**: issue INF existente ou "proposta" (ver seção 15).

## 5. Conta AWS

Com somente produção na AWS, existe uma única conta, e ela contém dados reais a partir do go-live. A configuração da conta é feita uma vez, por um administrador, e deve ser documentada em runbook.

| Controle | Por que importa | Como implementar | Custo | Prioridade | Issue |
| --- | --- | --- | --- | --- | --- |
| MFA no usuário root e nenhuma chave de acesso do root | O root tem poder irrestrito e não pode ser limitado por policies | Console: Security credentials do root → MFA (preferir chave física ou app autenticador); confirmar que não há access keys. Guardar a recuperação em local controlado pela instituição | Gratuito | Essencial | Proposta: baseline da conta |
| Contatos alternativos da conta | A AWS avisa sobre abuso e segurança por esses contatos | Console: Account → Alternate contacts (segurança, operações, cobrança) com e-mail institucional da equipe | Gratuito | Essencial | Proposta: baseline da conta |
| Poucos administradores humanos, com MFA | Cada acesso humano administrativo é um ponto de entrada | Preferir IAM Identity Center com MFA; na falta dele, usuários IAM individuais, sem chaves de acesso, com MFA obrigatório por policy | Gratuito | Essencial | Proposta: baseline da conta |
| Procedimento de acesso de emergência | Se o pipeline ou o Identity Center falhar, é preciso um caminho controlado | Runbook com quem pode usar o acesso de emergência, como registrar o uso e como revisar depois | Gratuito | Recomendado | INF-021 |
| Bloqueio de acesso público ao S3 no nível da conta | Impede que qualquer bucket da conta se torne público por engano | `aws_s3_account_public_access_block` com os quatro parâmetros `true` | Gratuito | Essencial | INF-010 |
| Criptografia padrão de EBS | Volumes de instâncias (por exemplo, a instância NAT) ficam cifrados sem depender de cada recurso | `aws_ebs_encryption_by_default { enabled = true }` | Gratuito | Recomendado | INF-002 |
| IAM Access Analyzer (acesso externo) | Aponta recursos compartilhados com contas ou entidades externas | `aws_accessanalyzer_analyzer` do tipo `ACCOUNT` | Gratuito | Essencial | Proposta: baseline da conta |
| Restrição de região | Recursos criados fora de us-east-1 escapam da revisão e do orçamento | Condição `aws:RequestedRegion` nas policies do pipeline (já no laboratório); alertas de recursos fora da região | Gratuito | Recomendado | INF-004 |

## 6. Identidade e acesso

### Controles

| Controle | Por que importa | Como implementar | Custo | Prioridade | Issue |
| --- | --- | --- | --- | --- | --- |
| OIDC no lugar de chaves de acesso | Credenciais temporárias expiram em cerca de uma hora; não há segredo fixo para vazar | `modules/github-oidc` e `global/github-oidc` do laboratório | Gratuito | Essencial | INF-004 |
| Roles separadas por função | Um comprometimento fica restrito à função da role | `gha-infra-plan`, `gha-infra-apply`, `gha-backend-publish`, `gha-frontend-publish`, `gha-release-deploy` ([07](07-oidc-github-actions-aws.md)) | Gratuito | Essencial | INF-004 |
| Trust policy exata | Curingas no `sub` permitem que outros repositórios ou branches assumam a role | `StringEquals` em `sub` e `aud`; curinga proibido pela validação do módulo | Gratuito | Essencial | INF-004 |
| Permissions boundary para roles criadas pelo pipeline | Sem limite, o apply pode criar uma role administrativa e assumi-la | Ver exemplo abaixo; boundary `plataforma-workload-boundary` no path `/github-actions/` | Gratuito | Essencial | INF-004 |
| Deny para editar identidades de CI | Um PR aprovado não pode "abrir a porta" de forma permanente | Statement `Deny` para alterar roles em `/github-actions/`, o provider OIDC e o boundary | Gratuito | Essencial | INF-004 |
| Task role e execution role separadas | A execution role (puxar imagem, ler segredo de inicialização) não deve ser usada pela aplicação | Duas roles por serviço no módulo de runtime, cada uma com policy mínima | Gratuito | Essencial | INF-007 |
| Revisão periódica de acesso | Permissões acumulam com o tempo | Revisar, a cada sprint de ensaio, as roles, usuários e membros dos times do GitHub; usar o "último acesso" do IAM | Gratuito | Recomendado | Proposta: baseline da conta |

### Exemplo: criação de roles apenas com permissions boundary

Um **permissions boundary** é uma policy que funciona como teto: a role só consegue fazer o que estiver permitido **ao mesmo tempo** na própria policy e no boundary. A role de apply pode criar roles para a aplicação, mas apenas se anexar o boundary:

```hcl
locals {
  boundary_arn = "arn:aws:iam::${local.account}:policy/github-actions/plataforma-workload-boundary"
}

data "aws_iam_policy_document" "infra_apply_iam" {
  # Criar ou alterar roles da aplicação SOMENTE com o boundary anexado.
  statement {
    sid       = "ManageAppRolesWithBoundary"
    actions   = ["iam:CreateRole", "iam:PutRolePermissionsBoundary", "iam:AttachRolePolicy", "iam:PutRolePolicy"]
    resources = ["arn:aws:iam::${local.account}:role/plataforma/*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PermissionsBoundary"
      values   = [local.boundary_arn]
    }
  }

  # O boundary não pode ser removido nem alterado pelo pipeline.
  statement {
    sid     = "ProtectBoundary"
    effect  = "Deny"
    actions = ["iam:DeleteRolePermissionsBoundary", "iam:CreatePolicyVersion", "iam:DeletePolicy", "iam:SetDefaultPolicyVersion"]
    resources = [
      "arn:aws:iam::${local.account}:role/plataforma/*",
      local.boundary_arn,
    ]
  }
}
```

A implementação completa, testada no MiniStack, está em `exemplos/lab-terraform-local/global/github-oidc/main.tf`. Lembre que o MiniStack, na configuração padrão, não avalia policies IAM; a eficácia do boundary só é comprovada na AWS (teste negativo: tentar criar uma role sem o boundary deve resultar em `AccessDenied`).

## 7. Organização GitHub e pipeline

### Configurações da organização

Estas configurações exigem um administrador da organização e não puderam ser verificadas em 2026-10-07.

| Controle | Por que importa | Como implementar | Custo | Prioridade | Issue |
| --- | --- | --- | --- | --- | --- |
| 2FA obrigatório | Senha vazada de um membro dá acesso ao código e ao pipeline | Settings → Authentication security → Require two-factor authentication | Gratuito | Essencial | Proposta: hardening do GitHub |
| Permissão base mínima | Membros devem ter acesso aos repositórios pelos times, não por padrão | Settings → Member privileges → Base permissions: `No permission` ou `Read` | Gratuito | Essencial | Proposta: hardening do GitHub |
| Restringir criação de repositórios | Hoje membros podem criar repositórios; um repositório público criado por engano pode expor código | Settings → Member privileges → Repository creation: desmarcar público (e, idealmente, privado) | Gratuito | Recomendado | Proposta: hardening do GitHub |
| Lista de actions permitidas | Reduz a superfície de ataque por actions de terceiros | Settings → Actions → General → Allow select actions: `actions/*`, `aws-actions/*`, `hashicorp/*`, `docker/*` e outras aprovadas | Gratuito | Essencial | INF-003 |
| `GITHUB_TOKEN` somente leitura por padrão | Workflows recebem só o que pedem explicitamente | Settings → Actions → Workflow permissions: Read repository contents | Gratuito | Essencial | INF-003 |
| Dependabot alerts e version updates | Avisa sobre dependências vulneráveis e atualiza versões fixadas (inclusive SHAs de actions) | Ativar alerts nos repositórios; arquivo `.github/dependabot.yml` (exemplo abaixo) | Gratuito | Essencial | INF-003 |

### Compensação para os recursos pagos indisponíveis

| Recurso indisponível | Alternativa gratuita | Como usar | Prioridade |
| --- | --- | --- | --- |
| Secret scanning e push protection | **gitleaks** | Hook de pre-commit local e job no CI executando o binário ou a imagem oficial do gitleaks sobre o diff do PR. A action oficial do gitleaks exige licença para organizações; executar a ferramenta diretamente evita essa dependência | Essencial |
| Code scanning (CodeQL) | **Semgrep Community Edition** e análise específica de linguagem | Job no CI com conjuntos de regras públicos de Java e TypeScript; falha em achados de severidade alta | Recomendado |
| Dependency review em PR | **Trivy** (`trivy fs`) e Dependabot alerts | Job no CI que falha em vulnerabilidades altas ou críticas com correção disponível | Essencial |
| Análise de IaC | **Trivy** (`trivy config`) ou **Checkov**, e **tflint** | Job no PR de infraestrutura; sem achados High/Critical (exigência do QA-025) | Essencial |

### Boas práticas nos workflows

| Controle | Por que importa | Como implementar | Prioridade | Issue |
| --- | --- | --- | --- | --- |
| Actions fixadas por SHA | Uma tag pode ser movida para outro código | `uses: actions/checkout@<SHA completo> # v4.x.y`; Dependabot mantém os SHAs atualizados | Essencial | INF-003 (POL-INFRA-001) |
| `permissions` mínimo por job | Limita o que um passo comprometido pode fazer | `permissions: {}` no topo do workflow e concessão explícita por job (`contents: read`, `id-token: write` só onde há OIDC) | Essencial | INF-003 |
| Nunca `pull_request_target` com checkout do código do PR | Esse evento roda com permissões do repositório base; executar código do PR nele entrega essas permissões ao autor do PR | Usar `pull_request` para validar código de PR | Essencial | INF-003 |
| Sem interpolação de dados do evento em `run:` | Títulos e nomes de branch controlados pelo autor podem injetar comandos no shell | Passar por variável de ambiente (exemplo abaixo) | Essencial | INF-003 |
| Role de plan sem `GetSecretValue` | O workflow de PR é editável pelo autor do PR | Policy somente leitura ([07](07-oidc-github-actions-aws.md)) | Essencial | INF-004 |
| SBOM das imagens | Permite responder rapidamente "estamos afetados?" quando surge uma vulnerabilidade | `trivy image --format cyclonedx` ou Syft; anexar ao registro do release | Recomendado | INF-006 |
| `concurrency` em deploys e applies | Evita duas alterações simultâneas em produção | `concurrency: { group: deploy-production, cancel-in-progress: false }` | Essencial | INF-009 |

**Injeção de comandos em workflows:**

```yaml
# Inseguro: o título do PR é inserido no script antes de o shell executá-lo.
- run: echo "Título: ${{ github.event.pull_request.title }}"

# Seguro: o valor chega como variável de ambiente e é tratado como texto.
- env:
    PR_TITLE: ${{ github.event.pull_request.title }}
  run: echo "Título: $PR_TITLE"
```

**Dependabot para todos os ecossistemas do projeto:**

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: github-actions   # atualiza os SHAs fixados das actions
    directory: /
    schedule: { interval: weekly }
  - package-ecosystem: terraform        # providers e módulos (repositório de infraestrutura)
    directory: /environments/production
    schedule: { interval: weekly }
  - package-ecosystem: docker           # imagens base dos Dockerfiles
    directory: /
    schedule: { interval: weekly }
  # Backend: package-ecosystem: maven. Frontend: package-ecosystem: npm.
```

## 8. Rede

| Controle | Por que importa | Como implementar | Custo | Prioridade | Issue |
| --- | --- | --- | --- | --- | --- |
| Camadas encadeadas por Security Group | Cada camada só aceita a anterior; o banco nunca é alcançável da internet | SG do ALB (443), SG da aplicação (8080 só do SG do ALB), SG do banco (5432 só do SG da aplicação) | Gratuito | Essencial | INF-002 |
| ALB somente com HTTPS e TLS moderno | Impede tráfego em texto claro e protocolos fracos | Certificado do ACM (gratuito); listener HTTPS com `ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"`; listener 80 apenas redirecionando para 443 | Gratuito | Essencial | INF-007, INF-011 |
| Descartar cabeçalhos HTTP inválidos | Reduz o risco de ataques de *request smuggling* | `drop_invalid_header_fields = true` no `aws_lb` | Gratuito | Recomendado | INF-007 |
| ALB acessível apenas pelo CloudFront | Sem isso, quem descobrir o endereço do ALB contorna o cache e o WAF da borda | SG do ALB aceitando a prefix list gerenciada `com.amazonaws.global.cloudfront.origin-facing` (`data "aws_ec2_managed_prefix_list"`) e regra no listener exigindo um cabeçalho secreto enviado pelo CloudFront. A prefix list consome boa parte da cota de regras do SG; confira a cota | Gratuito | Recomendado | INF-011 |
| Instância NAT endurecida | É a única instância EC2 do ambiente e tem acesso à internet | IMDSv2 obrigatório (`metadata_options { http_tokens = "required" }`); sem par de chaves SSH; acesso administrativo por SSM Session Manager; SG sem nenhuma entrada vinda da internet, apenas das sub-redes privadas; Auto Scaling Group para substituição automática | Gratuito | Essencial | INF-002 |
| VPC Flow Logs | Permitem investigar tentativas de conexão bloqueadas | Flow Logs apenas de tráfego `REJECT`, com retenção curta, para controlar custo | Centavos | Recomendado | INF-002 |
| AWS WAF na borda | Bloqueia padrões comuns de ataque web e permite limitar taxa por IP (por exemplo, no login) | Web ACL com regras gerenciadas da AWS (conjunto básico e de entradas conhecidamente maliciosas) e uma regra de limite de taxa | cerca de US$ 9,60 | Opcional | Proposta: WAF |

## 9. Containers e ECS

| Controle | Por que importa | Como implementar | Custo | Prioridade | Issue |
| --- | --- | --- | --- | --- | --- |
| Usuário não root | Um processo comprometido como root tem mais poder dentro do container | `USER 10001` no Dockerfile (o backend já usa); `user` na task definition | Gratuito | Essencial | INF-007, INF-011 |
| Sistema de arquivos raiz somente leitura | Impede que um invasor altere binários ou grave ferramentas no container | `readonlyRootFilesystem = true`; montar um volume temporário para `/tmp` (o Spring Boot e o Next.js precisam de diretório gravável) | Gratuito | Recomendado | INF-007, INF-011 |
| Remover capabilities do Linux | Reduz o que o processo pode fazer no kernel | `linuxParameters = { capabilities = { drop = ["ALL"] } }` | Gratuito | Recomendado | INF-007 |
| Segredos pelo campo `secrets` | Valores em `environment` aparecem em texto claro na task definition e em consultas à API | `secrets = [{ name = "DB_PASSWORD", valueFrom = "<ARN do segredo>:password::" }]` | Gratuito | Essencial | INF-007, INF-008 |
| ECS Exec desligado | Abre um shell interativo dentro do container em produção | `enable_execute_command = false` no service; se for necessário, ligar temporariamente, com registro no CloudTrail | Gratuito | Recomendado | INF-007 |
| Imagens base fixadas por digest | Uma tag como `21-jre` muda com o tempo; o build deixa de ser reproduzível | `FROM eclipse-temurin:21-jre@sha256:...`; Dependabot atualiza | Gratuito | Recomendado | INF-006 |
| Tags imutáveis e scan no push | Uma imagem publicada não pode ser substituída; vulnerabilidades conhecidas são apontadas | `image_tag_mutability = "IMMUTABLE"`, `scan_on_push = true` | Gratuito (scan básico) | Essencial | INF-006 |
| Deploy por digest | Garante que a imagem em produção é a que passou na validação | Task definition referenciando `@sha256:` | Gratuito | Essencial | INF-009, INF-019 |

## 10. Dados: banco, arquivos, state e segredos

### Controles

| Controle | Por que importa | Como implementar | Custo | Prioridade | Issue |
| --- | --- | --- | --- | --- | --- |
| Banco sem acesso público, em sub-rede privada | Ninguém da internet alcança o banco | `publicly_accessible = false`; subnet group privado | Gratuito | Essencial | INF-005 |
| TLS obrigatório no banco | Impede que credenciais e dados trafeguem sem criptografia, mesmo dentro da VPC | Parameter group com `rds.force_ssl = 1`. Nas versões 15 e posteriores do RDS PostgreSQL, esse já é o valor padrão; declarar explicitamente documenta a intenção e protege contra mudança acidental | Gratuito | Essencial | INF-005 |
| Criptografia em repouso com KMS | Protege discos, snapshots e réplicas | `storage_encrypted = true` com `kms_key_id` de chave gerenciada pelo cliente | US$ 1 por chave | Essencial | INF-005 |
| Proteção contra exclusão e backups | Evita perda por erro humano ou por um `-/+` no plan | `deletion_protection = true`, `backup_retention_period = 14`, `copy_tags_to_snapshot = true`, snapshot final | Armazenamento de backup até o tamanho do banco é gratuito | Essencial | INF-005, INF-015 |
| Senha do master fora do state | O state pode ser lido por quem tem acesso ao bucket | `manage_master_user_password = true` (recomendado) ou atributos write-only (exemplos abaixo) | Segredo: US$ 0,40 | Essencial | INF-005, INF-008 |
| Usuário da aplicação separado do master | A aplicação não deve conseguir alterar a estrutura de todos os schemas | Usuário criado por migration, com privilégios por schema conforme ADR-002; segredo próprio | Gratuito | Essencial | INF-005, DB-002 |
| Bucket de uploads privado e só com TLS | Arquivos enviados podem conter dados pessoais | Bloqueio de acesso público, SSE, versionamento, `BucketOwnerEnforced`, bucket policy negando `aws:SecureTransport = false` | Gratuito | Essencial | INF-010 |
| URLs pré-assinadas curtas e restritas | Uma URL vazada vale até expirar | Validade de cerca de 5 minutos; limite de tamanho e de tipo de conteúdo definidos no backend; CORS apenas para o domínio do frontend | Gratuito | Essencial | INF-010, BE-012 |
| Bucket de state restrito | O state descreve toda a infraestrutura | Bucket dedicado, versionado, com KMS, bucket policy negando requisições sem TLS e permitindo acesso apenas às roles de CI e de administração | US$ 1 (KMS) | Essencial | INF-001 |

### Senha do banco fora do state: duas abordagens

**Abordagem 1 (recomendada para produção): a AWS gera e guarda a senha.**

```hcl
resource "aws_db_instance" "this" {
  # ...
  username                      = "plataforma_admin"
  manage_master_user_password   = true                  # a senha nunca passa pelo Terraform
  master_user_secret_kms_key_id = aws_kms_key.data.arn  # o segredo é cifrado com a chave do projeto
}

# O ARN do segredo criado pela AWS fica disponível para a task definition:
#   aws_db_instance.this.master_user_secret[0].secret_arn
```

- **Prós:** a senha não aparece no código, no plan nem no state; a AWS faz a rotação automática; o Terraform não precisa de `GetSecretValue`.
- **Contras:** o formato do segredo é fixo (apenas usuário e senha; o endereço do banco vem de outra configuração); a rotação exige que a aplicação leia o segredo novamente quando a conexão falhar. Como a aplicação deve usar um usuário próprio, e não o master, o impacto da rotação recai sobretudo nas migrations.

**Abordagem 2 (didática): senha gerada pelo Terraform sem ser gravada no state.**

A partir do Terraform 1.11, valores **efêmeros** e atributos **write-only** permitem passar um segredo para a AWS sem que ele seja salvo no state nem no plan.

```hcl
# Gerada a cada execução, existe só na memória do Terraform (random >= 3.7).
ephemeral "random_password" "db" {
  length  = 32
  special = false
}

resource "aws_db_instance" "this" {
  # ...
  username            = "plataforma_admin"
  password_wo         = ephemeral.random_password.db.result  # write-only: enviado, nunca gravado
  password_wo_version = 1                                    # incrementar para trocar a senha
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string_wo = jsonencode({
    username = "plataforma_admin"
    password = ephemeral.random_password.db.result
    host     = aws_db_instance.this.address
    port     = aws_db_instance.this.port
    dbname   = "plataforma"
  })
  secret_string_wo_version = 1  # incrementar junto com password_wo_version
}
```

- **Prós:** a senha não fica no state; o fluxo é inteiramente controlado pelo código; útil para entender valores efêmeros.
- **Contras:** como o valor é gerado de novo a cada execução, ele só é enviado quando a versão muda; as duas versões (`password_wo_version` e `secret_string_wo_version`) precisam ser incrementadas **juntas**, ou o banco e o segredo ficam com senhas diferentes; o plan não mostra diferença de valor; exige Terraform 1.11 ou superior e versões recentes dos providers.

O laboratório usa a abordagem 2 em `exemplos/lab-terraform-local/modules/database/main.tf`, testada no MiniStack em 2026-10-07: o state não contém a senha, e o Secrets Manager contém. Para trocar a senha, incremente a variável `password_version`, que alimenta as duas versões ao mesmo tempo. Em produção, prefira a abordagem 1.

## 11. Observabilidade e detecção

| Controle | Por que importa | Como implementar | Custo | Prioridade | Issue |
| --- | --- | --- | --- | --- | --- |
| CloudTrail multi-região com validação de integridade | Registro de todas as chamadas de API; base de qualquer investigação | `aws_cloudtrail` com `is_multi_region_trail = true`, `enable_log_file_validation = true`, bucket S3 dedicado, privado e com acesso restrito; retenção conforme POL-INFRA-002 (auditoria: 180 dias) | cerca de US$ 0,20 | Essencial | Proposta: baseline da conta |
| GuardDuty | Detecta comportamento suspeito: credenciais usadas de locais incomuns, mineração, acesso anômalo ao S3, comunicação com endereços maliciosos | `aws_guardduty_detector`; achados de severidade média ou alta enviados por EventBridge e SNS ao canal da equipe | cerca de US$ 3 | Essencial | Proposta: baseline da conta |
| Alerta de uso do root | O root não deve ser usado no dia a dia; qualquer uso precisa ser explicado | Regra do EventBridge sobre eventos de login do root registrados pelo CloudTrail, com notificação por SNS | Centavos | Recomendado | Proposta: baseline da conta |
| Alerta de mudanças em IAM e no CloudTrail | Mudanças em identidades ou o desligamento da trilha são sinais de comprometimento | Regras do EventBridge para `CreateUser`, `CreateAccessKey`, `AttachRolePolicy`, `StopLogging`, `DeleteTrail` | Centavos | Recomendado | Proposta: baseline da conta |
| Logs da aplicação sem segredos e sem dados pessoais desnecessários | Logs são lidos por mais pessoas e retidos por mais tempo do que o banco | Logs JSON estruturados; mascaramento de campos sensíveis; correlação por request id (POL-INFRA-002) | Incluído | Essencial | INF-012 |
| Alarmes operacionais | Indisponibilidade e erros também são incidentes | Alarmes do INF-013 (p95, 5xx, hosts não saudáveis, CPU e conexões do RDS) | US$ 0,10 por alarme | Essencial | INF-013 |
| Budgets e Cost Anomaly Detection | Gasto anormal é frequentemente o primeiro sinal de credencial vazada | INF-014 | Gratuito | Essencial | INF-014 |

## 12. LGPD e resposta a incidentes

A plataforma trata dados pessoais de estudantes, docentes e parceiros, o que a submete à Lei Geral de Proteção de Dados Pessoais (Lei nº 13.709/2018). A instituição é a **controladora** dos dados; a equipe técnica implementa as medidas de segurança e apoia a resposta a incidentes, mas a comunicação formal cabe ao **encarregado** (DPO) da instituição.

| Controle | Por que importa | Como implementar | Prioridade | Issue |
| --- | --- | --- | --- | --- |
| Dados de produção nunca saem da conta | Cópias em máquinas pessoais ou no CI são o caminho mais comum de vazamento | Proibir dumps de produção fora da conta; o ensaio de restore (INF-016) cria uma instância temporária **dentro** da conta de produção e a remove ao final | Essencial | INF-016 |
| Dados sintéticos em desenvolvimento e validação | Testes não precisam de pessoas reais | Seeds sintéticos no `plataforma-database`; nenhum dado real na validação efêmera | Essencial | DB (seeds) |
| Minimização em logs | Logs retidos por 30 a 180 dias multiplicam a exposição | Não registrar documentos, e-mails completos, tokens ou conteúdo de arquivos (POL-INFRA-002) | Essencial | INF-012 |
| Plano de resposta a incidentes com etapa de LGPD | A LGPD exige comunicação à ANPD e aos titulares quando o incidente pode gerar risco ou dano relevante | O RUNBOOK-INFRA-003 (`_KB/operations/runbooks/incident-response.md`) deve incluir: contenção, preservação de evidências (CloudTrail, logs), avaliação de risco aos titulares e acionamento do encarregado. Conferir o prazo de comunicação vigente no regulamento da ANPD (Resolução CD/ANPD nº 15/2024) | Essencial | INF-021 |
| Rotação após incidente | Uma credencial possivelmente exposta deve ser considerada comprometida | Procedimento no runbook para rotacionar segredos do Secrets Manager, revogar sessões e redeployar | Essencial | INF-021 |

**Primeiros passos diante de suspeita de credencial vazada:**

1. Registrar a hora da descoberta e abrir o registro de incidente.
2. Revogar ou desativar a credencial (chave de acesso, token do GitHub, segredo) e, no caso de roles, revogar as sessões ativas (`Revoke active sessions` no console do IAM).
3. Consultar o CloudTrail para identificar o que foi feito com a credencial desde a exposição.
4. Verificar recursos criados fora do padrão (outras regiões, instâncias, usuários IAM) e o Cost Explorer.
5. Rotacionar segredos relacionados e redeployar os serviços.
6. Acionar o encarregado da instituição se houver possibilidade de acesso a dados pessoais.
7. Registrar causa, impacto e ações na revisão pós-incidente.

## 13. Ambiente local e validação efêmera

| Controle | Por que importa | Como implementar | Prioridade |
| --- | --- | --- | --- |
| Credenciais do emulador sempre fictícias | Evita misturar o laboratório com uma conta real | O provider do laboratório usa `test`/`test` e `endpoints` explícitos; um perfil `ministack` separado na AWS CLI ([05](05-laboratorio-local-ministack.md)) | Essencial |
| Emulador acessível apenas na própria máquina | Sem autenticação na configuração padrão, o MiniStack aceita qualquer requisição; publicado em todas as interfaces, outras máquinas da rede podem usá-lo | Publicar a porta como `127.0.0.1:4566:4566` no `compose.yaml` | Recomendado |
| Atenção ao `docker.sock` | O MiniStack monta o socket do Docker para criar containers (por exemplo, o PostgreSQL do RDS), o que equivale a controle total do Docker da máquina | Usar apenas em máquina pessoal ou no runner efêmero do CI; nunca em máquina compartilhada | Recomendado |
| Nenhum arquivo sensível versionado | `.tfstate`, `.tfplan`, `.env` e chaves podem conter segredos | `.gitignore` do laboratório e dos repositórios; gitleaks em pre-commit | Essencial |
| Validação efêmera sem segredos reais | O ambiente de CI não precisa de credenciais de produção para testar | Docker Compose com PostgreSQL 16, MiniStack e segredos fictícios gerados no próprio job; a role de produção só é assumida no passo de publicação, depois que a validação passou | Essencial |

## 14. Achados no laboratório e correções aplicadas

A revisão de segurança do código de `exemplos/lab-terraform-local/` em 2026-10-07 encontrou os pontos abaixo. As correções servem de referência para o repositório `plataforma-infrastructure`.

| # | Achado | Risco | Correção | Situação |
| --- | --- | --- | --- | --- |
| 1 | Bucket de state sem política exigindo TLS | Leitura ou escrita do state por conexão sem criptografia | Bucket policy com `Deny` para `aws:SecureTransport = false` em `bootstrap/main.tf` | Corrigido |
| 2 | Bucket de uploads sem política exigindo TLS | Arquivos com dados pessoais trafegando sem criptografia | Mesma bucket policy em `modules/storage/main.tf` | Corrigido |
| 3 | Senha do banco gerada por `random_password` e, portanto, gravada no state | Quem lê o state obtém a senha do master | Substituída pelo padrão write-only (abordagem 2 da seção 10) em `modules/database/main.tf` | Corrigido |
| 4 | Ausência de parameter group com `rds.force_ssl` | Conexões ao banco sem TLS, caso o padrão da versão mude | `aws_db_parameter_group` da família `postgres16` com `rds.force_ssl = 1` em `modules/database/main.tf` | Corrigido |
| 5 | Role de apply podendo criar roles em `/plataforma/` sem limite | Escalada de privilégio: criar uma role administrativa que confia no pipeline | Permissions boundary `plataforma-workload-boundary` obrigatório na criação de roles e `Deny` para alterá-lo, em `global/github-oidc/main.tf` (seção 6) | Corrigido |
| 6 | Porta do emulador publicada em todas as interfaces (`4566:4566`) | Outras máquinas da rede local podem usar o emulador | Publicar como `127.0.0.1:4566:4566` em `compose.yaml` | Corrigido |

## 15. Issues propostas

Alguns controles essenciais não se encaixam em nenhuma issue INF existente. Propõe-se criá-los no backlog de infraestrutura, com os critérios abaixo como referência. Os códigos provisórios são os mesmos de [06 Backlog de infraestrutura](06-backlog-de-infraestrutura.md), seção 11, que detalha também a INF-024 (varredura de segredos e análise estática sem recursos pagos).

**INF-022 (proposta): baseline de segurança da conta AWS (antes do go-live)**

1. MFA no root, sem chaves de acesso do root, contatos alternativos preenchidos.
2. Acesso humano administrativo com MFA e lista nominal de administradores registrada.
3. `aws_s3_account_public_access_block`, criptografia padrão de EBS e IAM Access Analyzer criados por Terraform.
4. CloudTrail multi-região com validação de integridade, em bucket dedicado.
5. GuardDuty ativo, com achados médios e altos notificados ao canal da equipe.
6. Alertas de uso do root e de mudanças em IAM e no CloudTrail.
7. Evidência: saída do `terraform plan`/`apply`, captura das configurações do console e teste de notificação.

**INF-023 (proposta): endurecimento da organização GitHub e do pipeline**

1. 2FA obrigatório, permissão base mínima e criação de repositórios restrita (executado por administrador).
2. Lista de actions permitidas e `GITHUB_TOKEN` somente leitura por padrão.
3. `dependabot.yml` em todos os repositórios.
4. gitleaks, Trivy (`fs`, `config`, `image`) e Semgrep CE nos workflows reutilizáveis do INF-003.
5. Ferramentas equivalentes ao CodeQL registradas nos workflows reutilizáveis, conforme a POL-INFRA-001 (seção 2).

**INF-025 (proposta): AWS WAF na borda (opcional, conforme orçamento)**

1. Web ACL associada ao CloudFront com regras gerenciadas básicas e limite de taxa no caminho de login.
2. Custo medido no primeiro mês e registrado.
3. Teste: requisições acima do limite recebem bloqueio; tráfego normal não é afetado.

## 16. Checklist de segurança para o go-live

Itens a confirmar antes da aprovação de produção (INF-019). Cada item deve ter evidência vinculada.

**Conta AWS**

- [ ] MFA no root, sem chaves de acesso do root, contatos alternativos configurados
- [ ] Administradores humanos com MFA, lista registrada
- [ ] Bloqueio de acesso público ao S3 no nível da conta
- [ ] IAM Access Analyzer sem achados de acesso externo não justificados
- [ ] CloudTrail multi-região ativo, com validação de integridade
- [ ] GuardDuty ativo e notificando
- [ ] Budget de US$ 120 com alertas testados e Cost Anomaly Detection ativo

**Identidade e pipeline**

- [ ] Nenhuma chave de acesso usada por CI; todas as integrações por OIDC
- [ ] Testes negativos de OIDC executados (outro repositório, outra branch, role de plan tentando escrever)
- [ ] Permissions boundary obrigatório comprovado (criar role sem boundary resulta em `AccessDenied`)
- [ ] Actions fixadas por SHA e lista de actions permitidas ativa
- [ ] 2FA obrigatório na organização GitHub
- [ ] gitleaks, Trivy e análise de IaC sem achados High/Critical pendentes

**Rede e runtime**

- [ ] ALB somente HTTPS, com política TLS 1.2/1.3 e redirecionamento de 80 para 443
- [ ] Banco e tasks sem IP público; Security Groups encadeados conferidos
- [ ] Instância NAT com IMDSv2 obrigatório e sem SSH
- [ ] Containers como usuário não root; segredos apenas pelo campo `secrets`
- [ ] Imagens com tag imutável, scan sem críticas pendentes, deploy por digest

**Dados**

- [ ] RDS cifrado com KMS, `rds.force_ssl = 1`, `deletion_protection` ativo, backups de 14 dias
- [ ] Senha do master fora do state (`manage_master_user_password`)
- [ ] Aplicação usando usuário próprio, sem privilégios de master
- [ ] Restore ensaiado dentro da conta de produção, instância temporária removida
- [ ] Buckets privados, com TLS obrigatório; URLs pré-assinadas com validade curta

**Processo**

- [ ] Runbook de incidentes com etapa de LGPD e contato do encarregado
- [ ] Procedimento de rotação de segredos testado
- [ ] Nenhum dado de produção fora da conta AWS

## Referências

**Documentos da governança**

- MH-INFRA-001 a 003: `_KB/must-haves/infrastructure.md`
- Política de segurança: `_KB/security/policy.md`
- Arquitetura de segurança: `_KB/architecture/security.md`
- POL-INFRA-001, CI/CD: `_KB/engineering/ci-cd.md`
- POL-INFRA-002, Observabilidade: `_KB/engineering/observability.md`
- RUNBOOK-INFRA-003, Resposta a incidentes: `_KB/operations/runbooks/incident-response.md`
- ADR-002 `_KB/architecture/adrs/ADR-002-postgresql-schema-isolation.md`
- ADR-011 `_KB/architecture/adrs/ADR-011-environment-isolation.md`

**AWS**

- [Security best practices in IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Permissions boundaries for IAM entities](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html)
- [AWS Security Reference Architecture](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/welcome.html)
- [CIS AWS Foundations Benchmark no AWS Security Hub](https://docs.aws.amazon.com/securityhub/latest/userguide/cis-aws-foundations-benchmark.html)
- [Amazon RDS: password management with Secrets Manager](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-secrets-manager.html)
- [Using SSL with a PostgreSQL DB instance](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL.Concepts.General.SSL.html)
- [Amazon ECS task definition parameters](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html)

**Terraform**

- [Ephemeral values and write-only arguments](https://developer.hashicorp.com/terraform/language/resources/ephemeral)

**GitHub**

- [Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions)
- [About GitHub Advanced Security (Secret Protection e Code Security)](https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security)
- [About secret scanning](https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning)
- [About code scanning](https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning)
- [Configuring Dependabot version updates](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuring-dependabot-version-updates)

**Aplicação e legislação**

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Docker Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
- [Lei nº 13.709/2018 (LGPD)](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm)

**Documentos relacionados deste material:** [07-oidc-github-actions-aws.md](07-oidc-github-actions-aws.md), [08-cicd-no-plano-free-do-github.md](08-cicd-no-plano-free-do-github.md), [09-custos-e-finops.md](09-custos-e-finops.md), [11-glossario.md](11-glossario.md).
