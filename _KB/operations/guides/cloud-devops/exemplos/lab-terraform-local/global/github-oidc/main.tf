# Matriz de roles do GitHub Actions na conta AWS de PRODUÇÃO.
#
# Decisão do projeto (2026-10-07, proposta como ADR-012): somente produção existe na AWS.
# Development roda na máquina de cada pessoa (Docker Compose + MiniStack) e a validação
# que antes era feita em staging acontece num ambiente efêmero dentro do próprio job de CI.
# Por isso existe uma única conta AWS e um único conjunto de roles:
#
#   gha-infra-plan        infrastructure  pull_request          somente leitura
#   gha-infra-apply       infrastructure  main (ou environment) terraform apply em produção
#   gha-backend-publish   backend         main                  push no ECR do backend
#   gha-frontend-publish  frontend        main                  push no ECR do frontend
#   gha-release-deploy    release         main (ou environment) deploy das aplicações em produção
#
# Este root é aplicado por uma pessoa com credencial administrativa, uma única vez por conta.

variable "environment" {
  description = "Ambiente da conta. Com a decisão atual, só existe production na AWS."
  type        = string
  default     = "production"
}

variable "state_bucket" {
  description = "Bucket do state do Terraform. Na AWS real: plataforma-tfstate-production."
  type        = string
  default     = "plataforma-tfstate-development" # o laboratório só tem este bucket
}

variable "use_github_environments" {
  description = <<-EOT
    Afeta as roles que alteram produção (infra-apply e release-deploy).
    true  = plano Team (ou repositório público): trust por "environment:production",
            com required reviewers configurados no environment.
    false = plano Free com repositórios privados (situação atual): environments não existem,
            então o trust é pela branch "ref:refs/heads/main".
    As roles de publish sempre usam a branch main.
  EOT
  type        = bool
  default     = false
}

variable "release_repository_id" {
  description = <<-EOT
    ID numérico do repositório plataforma-release, que ainda não foi criado.
    Enquanto for null, a role gha-release-deploy não é criada.
    Depois de criar o repositório: gh api repos/UniSENAI-Sorocaba/plataforma-release --jq .id
  EOT
  type        = number
  default     = null
}

data "aws_caller_identity" "current" {}

locals {
  # IDs reais (gh api repos/UniSENAI-Sorocaba/<repo>/actions/oidc/customization/sub).
  # Os repositórios da organização usam o formato IMUTÁVEL do sub: repo:org@id/repo@id:...
  github_org_id = 321832374
  repo_ids = {
    "plataforma-infrastructure" = 1364613694
    "plataforma-backend"        = 1364613500
    "plataforma-frontend"       = 1364613558
  }

  account = data.aws_caller_identity.current.account_id
  region  = "us-east-1"
  env     = var.environment
  apps    = ["backend", "frontend"]
  cluster = "plataforma-${local.env}"

  # Contexto aceito no sub pelas roles que alteram produção.
  production_subject = var.use_github_environments ? "environment:${var.environment}" : "ref:refs/heads/main"

  boundary_name = "plataforma-workload-boundary"
  boundary_arn  = "arn:aws:iam::${local.account}:policy/github-actions/${local.boundary_name}"

  ecr_repo_arns = {
    for app in local.apps : app => "arn:aws:ecr:${local.region}:${local.account}:repository/plataforma-${app}-${local.env}"
  }
}

# ---------------------------------------------------------------------------
# 0) Permissions boundary das roles de workload (task roles do ECS, instância NAT etc.).
#
# Um boundary é um TETO: a role só pode fazer o que estiver ao mesmo tempo na própria
# policy E no boundary. O infra-apply só consegue criar roles em /plataforma/ se anexar
# este boundary (statement ManageAppRolesWithBoundary). Assim, mesmo que um PR aprovado
# anexe AdministratorAccess a uma role da aplicação, ela continua limitada a esta lista.
#
# O boundary fica no path /github-actions/, que o infra-apply não pode alterar.
# ---------------------------------------------------------------------------
data "aws_iam_policy_document" "workload_boundary" {
  statement {
    sid = "AppObjects"
    actions = [
      "s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket",
      "s3:GetObjectVersion", "s3:AbortMultipartUpload",
    ]
    resources = ["arn:aws:s3:::plataforma-*", "arn:aws:s3:::plataforma-*/*"]
  }

  statement {
    sid       = "AppSecrets"
    actions   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
    resources = ["arn:aws:secretsmanager:${local.region}:${local.account}:secret:plataforma/*"]
  }

  statement {
    sid       = "Logs"
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogStreams"]
    resources = ["arn:aws:logs:${local.region}:${local.account}:log-group:*"]
  }

  statement {
    sid = "PullImages"
    actions = [
      "ecr:GetAuthorizationToken", "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer", "ecr:BatchCheckLayerAvailability",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "Crypto"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey", "kms:DescribeKey"]
    resources = ["arn:aws:kms:${local.region}:${local.account}:key/*"] # a key policy restringe por chave
  }

  statement {
    sid = "Telemetry"
    actions = [
      "cloudwatch:PutMetricData",
      "xray:PutTraceSegments", "xray:PutTelemetryRecords",
      "xray:GetSamplingRules", "xray:GetSamplingTargets",
    ]
    resources = ["*"]
  }

  # Canal usado pelo SSM (acesso sem SSH à instância NAT; ECS Exec, se um dia for habilitado).
  statement {
    sid = "SessionManager"
    actions = [
      "ssmmessages:CreateControlChannel", "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel", "ssmmessages:OpenDataChannel",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "workload_boundary" {
  name        = local.boundary_name
  path        = "/github-actions/"
  description = "Teto de permissões para roles de workload criadas pelo pipeline (path /plataforma/)."
  policy      = data.aws_iam_policy_document.workload_boundary.json
}

# ---------------------------------------------------------------------------
# 1) Plan em pull request: SOMENTE LEITURA.
# O workflow que roda num PR é a versão DO PR: quem abre o PR pode editá-lo e usar
# esta role como quiser. Por isso ela não escreve nada e não lê valores de segredo.
# ---------------------------------------------------------------------------
data "aws_iam_policy_document" "infra_plan" {
  statement {
    sid = "ReadInfra"
    actions = [
      "ec2:Describe*",
      "autoscaling:Describe*",
      "rds:Describe*", "rds:ListTagsForResource",
      "s3:GetBucket*", "s3:GetEncryptionConfiguration", "s3:GetLifecycleConfiguration",
      "s3:GetAccelerateConfiguration", "s3:GetReplicationConfiguration", "s3:ListAllMyBuckets",
      "ecr:Describe*", "ecr:GetLifecyclePolicy", "ecr:GetRepositoryPolicy", "ecr:ListTagsForResource",
      "ecs:Describe*", "ecs:List*",
      "elasticloadbalancing:Describe*",
      "application-autoscaling:Describe*",
      "secretsmanager:DescribeSecret", "secretsmanager:GetResourcePolicy", "secretsmanager:ListSecrets",
      "iam:Get*", "iam:List*",
      "logs:Describe*", "logs:ListTagsForResource",
      "cloudwatch:Describe*", "cloudwatch:List*",
      "kms:Describe*", "kms:List*", "kms:GetKeyPolicy", "kms:GetKeyRotationStatus",
      "cloudfront:Get*", "cloudfront:List*",
      "acm:Describe*", "acm:List*",
      "route53:Get*", "route53:List*",
      "wafv2:Get*", "wafv2:List*",
      "sns:Get*", "sns:List*",
      "budgets:View*",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "ReadState"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.state_bucket}"]
  }

  statement {
    sid       = "ReadStateObjects"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.state_bucket}/*"]
  }

  # use_lockfile grava e apaga "<key>.tflock" até no plan.
  statement {
    sid       = "StateLock"
    actions   = ["s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${var.state_bucket}/*.tflock"]
  }

  # Defesa em profundidade: mesmo que alguém acrescente uma permissão ampla acima,
  # o valor dos segredos continua inacessível a partir de um PR.
  statement {
    sid       = "NeverReadSecretValues"
    effect    = "Deny"
    actions   = ["secretsmanager:GetSecretValue", "ssm:GetParameter*", "kms:Decrypt"]
    resources = ["*"]
  }
}

# ---------------------------------------------------------------------------
# 2) Apply do Terraform em produção.
# Ponto de partida: os serviços que a plataforma usa, só em us-east-1.
# Endurecer (resources específicos) à medida que os módulos ficarem prontos.
# ---------------------------------------------------------------------------
data "aws_iam_policy_document" "infra_apply" {
  statement {
    sid = "ManagePlatformServices"
    actions = [
      "ec2:*", "autoscaling:*", "rds:*", "s3:*", "ecr:*", "ecs:*", "elasticloadbalancing:*",
      "application-autoscaling:*", "secretsmanager:*", "logs:*", "cloudwatch:*", "kms:*",
      "budgets:*", "cloudfront:*", "acm:*", "route53:*", "wafv2:*", "sns:*",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [local.region] # CloudFront, ACM do CloudFront, Route 53 e Budgets respondem em us-east-1
    }
  }

  statement {
    sid       = "ReadIam"
    actions   = ["iam:Get*", "iam:List*"]
    resources = ["*"]
  }

  # Criar role da aplicação só é possível COM o boundary anexado.
  statement {
    sid       = "ManageAppRolesWithBoundary"
    actions   = ["iam:CreateRole", "iam:PutRolePermissionsBoundary"]
    resources = ["arn:aws:iam::${local.account}:role/plataforma/*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PermissionsBoundary"
      values   = [local.boundary_arn]
    }
  }

  # Demais operações nas roles da aplicação. Anexar uma policy ampla não escala
  # privilégio, porque o boundary continua limitando o resultado.
  # Atenção: uma role criada MANUALMENTE em /plataforma/ sem boundary seria uma brecha.
  # Toda role desse path deve nascer pelo Terraform.
  statement {
    sid = "ManageAppRoles"
    actions = [
      "iam:DeleteRole", "iam:UpdateRole", "iam:UpdateRoleDescription", "iam:UpdateAssumeRolePolicy",
      "iam:TagRole", "iam:UntagRole",
      "iam:PutRolePolicy", "iam:DeleteRolePolicy", "iam:AttachRolePolicy", "iam:DetachRolePolicy",
    ]
    resources = ["arn:aws:iam::${local.account}:role/plataforma/*"]
  }

  statement {
    sid = "ManageAppPolicies"
    actions = [
      "iam:CreatePolicy", "iam:CreatePolicyVersion", "iam:DeletePolicy", "iam:DeletePolicyVersion",
      "iam:SetDefaultPolicyVersion", "iam:TagPolicy", "iam:UntagPolicy",
    ]
    resources = ["arn:aws:iam::${local.account}:policy/plataforma/*"]
  }

  # Instance profile da instância NAT (fck-nat).
  statement {
    sid = "ManageAppInstanceProfiles"
    actions = [
      "iam:CreateInstanceProfile", "iam:DeleteInstanceProfile", "iam:TagInstanceProfile",
      "iam:AddRoleToInstanceProfile", "iam:RemoveRoleFromInstanceProfile",
    ]
    resources = ["arn:aws:iam::${local.account}:instance-profile/plataforma/*"]
  }

  # Entregar roles da aplicação aos serviços que as usam.
  statement {
    sid       = "PassAppRoles"
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::${local.account}:role/plataforma/*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com", "ec2.amazonaws.com", "monitoring.rds.amazonaws.com"]
    }
  }

  # Roles vinculadas a serviço que a AWS cria na primeira utilização.
  statement {
    sid       = "ServiceLinkedRoles"
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"
      values = [
        "ecs.amazonaws.com", "rds.amazonaws.com", "elasticloadbalancing.amazonaws.com",
        "autoscaling.amazonaws.com", "ecs.application-autoscaling.amazonaws.com",
      ]
    }
  }

  # ---- Negações explícitas (vencem qualquer Allow) ----

  # Anti-escalada 1: o pipeline não altera as próprias roles, o boundary nem o provider OIDC.
  # Sem isso, um PR aprovado poderia abrir a trust policy da própria role ou afrouxar o boundary.
  statement {
    sid     = "DenyCiAndBoundaryEdits"
    effect  = "Deny"
    actions = ["iam:*"]
    resources = [
      "arn:aws:iam::${local.account}:role/github-actions/*",
      "arn:aws:iam::${local.account}:policy/github-actions/*",
      "arn:aws:iam::${local.account}:oidc-provider/*",
    ]
  }

  # Anti-escalada 2: remover o boundary de uma role da aplicação.
  statement {
    sid       = "DenyBoundaryRemoval"
    effect    = "Deny"
    actions   = ["iam:DeleteRolePermissionsBoundary"]
    resources = ["*"]
  }

  # Anti-escalada 3: identidades humanas e chaves permanentes nunca são criadas pelo pipeline.
  # Nenhum Allow acima cobre essas ações; o Deny protege contra uma ampliação futura descuidada.
  statement {
    sid    = "DenyUsersAndLongLivedKeys"
    effect = "Deny"
    actions = [
      "iam:CreateUser", "iam:CreateAccessKey", "iam:UpdateAccessKey", "iam:CreateLoginProfile",
      "iam:UpdateLoginProfile", "iam:AttachUserPolicy", "iam:PutUserPolicy", "iam:AddUserToGroup",
      "iam:CreateGroup", "iam:AttachGroupPolicy", "iam:PutGroupPolicy",
      "iam:UpdateAccountPasswordPolicy", "iam:CreateSAMLProvider", "iam:CreateOpenIDConnectProvider",
    ]
    resources = ["*"]
  }

  # Protege o bucket do state: o apply grava o state e o lock, mas não desliga o
  # versionamento, não troca a policy nem apaga versões antigas (recuperação de desastre).
  statement {
    sid    = "ProtectStateBucket"
    effect = "Deny"
    actions = [
      "s3:DeleteBucket", "s3:PutBucketPolicy", "s3:DeleteBucketPolicy", "s3:PutBucketVersioning",
      "s3:PutLifecycleConfiguration", "s3:PutEncryptionConfiguration", "s3:PutBucketPublicAccessBlock",
      "s3:DeleteObjectVersion",
    ]
    resources = ["arn:aws:s3:::${var.state_bucket}", "arn:aws:s3:::${var.state_bucket}/*"]
  }

  # Protege a trilha de auditoria e a detecção de ameaças (configuradas fora deste pipeline).
  statement {
    sid    = "ProtectAuditAndDetection"
    effect = "Deny"
    actions = [
      "cloudtrail:StopLogging", "cloudtrail:DeleteTrail", "cloudtrail:UpdateTrail",
      "cloudtrail:PutEventSelectors", "guardduty:DeleteDetector", "guardduty:UpdateDetector",
      "access-analyzer:DeleteAnalyzer",
    ]
    resources = ["*"]
  }
}

# ---------------------------------------------------------------------------
# 3) Publicação de imagem (backend/frontend): push no PRÓPRIO repositório ECR.
# Não faz deploy: colocar a imagem em execução é papel do repositório de release.
# ---------------------------------------------------------------------------
data "aws_iam_policy_document" "app_publish" {
  for_each = toset(local.apps)

  statement {
    sid       = "EcrLogin"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"] # a API não aceita resource específico
  }

  statement {
    sid = "PushOwnImage"
    actions = [
      "ecr:BatchCheckLayerAvailability", "ecr:InitiateLayerUpload", "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload", "ecr:PutImage", "ecr:BatchGetImage", "ecr:DescribeImages",
    ]
    resources = [local.ecr_repo_arns[each.key]]
  }
}

# ---------------------------------------------------------------------------
# 4) Deploy em produção a partir do repositório plataforma-release.
# Lê as imagens já publicadas, registra task definitions, executa a migration e
# atualiza os dois serviços. Não executa Terraform e não envia imagens.
# ---------------------------------------------------------------------------
data "aws_iam_policy_document" "release_deploy" {
  statement {
    sid       = "EcrLogin"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid       = "ReadImages"
    actions   = ["ecr:BatchGetImage", "ecr:DescribeImages", "ecr:GetDownloadUrlForLayer", "ecr:BatchCheckLayerAvailability"]
    resources = values(local.ecr_repo_arns)
  }

  statement {
    sid       = "TaskDefinitions"
    actions   = ["ecs:RegisterTaskDefinition", "ecs:DescribeTaskDefinition", "ecs:ListTaskDefinitions"]
    resources = ["*"] # a API não aceita resource específico
  }

  statement {
    sid       = "UpdateServices"
    actions   = ["ecs:UpdateService", "ecs:DescribeServices"]
    resources = [for app in local.apps : "arn:aws:ecs:${local.region}:${local.account}:service/${local.cluster}/plataforma-${app}"]
  }

  # Migration: task avulsa, somente a definição de migration e somente no cluster de produção.
  statement {
    sid       = "RunMigration"
    actions   = ["ecs:RunTask"]
    resources = ["arn:aws:ecs:${local.region}:${local.account}:task-definition/plataforma-migration*"]
    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"
      values   = ["arn:aws:ecs:${local.region}:${local.account}:cluster/${local.cluster}"]
    }
  }

  statement {
    sid       = "WatchTasks"
    actions   = ["ecs:DescribeTasks"]
    resources = ["arn:aws:ecs:${local.region}:${local.account}:task/${local.cluster}/*"]
  }

  statement {
    sid       = "TagOnCreate"
    actions   = ["ecs:TagResource"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "ecs:CreateAction"
      values   = ["RegisterTaskDefinition", "RunTask"]
    }
  }

  # Ler o log da migration para decidir se o deploy segue.
  statement {
    sid       = "ReadMigrationLogs"
    actions   = ["logs:GetLogEvents", "logs:FilterLogEvents"]
    resources = ["arn:aws:logs:${local.region}:${local.account}:log-group:/ecs/${local.cluster}/*"]
  }

  # Para registrar a task definition, o job entrega as roles da task ao ECS.
  statement {
    sid       = "PassTaskRoles"
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::${local.account}:role/plataforma/plataforma-*-${local.env}-*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}

module "github_oidc" {
  source        = "../../modules/github-oidc"
  github_org_id = local.github_org_id

  roles = merge(
    {
      "infra-plan" = {
        repository    = "plataforma-infrastructure"
        repository_id = local.repo_ids["plataforma-infrastructure"]
        subjects      = ["pull_request"]
        policy_json   = data.aws_iam_policy_document.infra_plan.json
      }
      "infra-apply" = {
        repository    = "plataforma-infrastructure"
        repository_id = local.repo_ids["plataforma-infrastructure"]
        subjects      = [local.production_subject]
        policy_json   = data.aws_iam_policy_document.infra_apply.json
      }
    },
    {
      for app in local.apps : "${app}-publish" => {
        repository    = "plataforma-${app}"
        repository_id = local.repo_ids["plataforma-${app}"]
        subjects      = ["ref:refs/heads/main"]
        policy_json   = data.aws_iam_policy_document.app_publish[app].json
      }
    },
    var.release_repository_id == null ? {} : {
      "release-deploy" = {
        repository    = "plataforma-release"
        repository_id = var.release_repository_id
        subjects      = [local.production_subject]
        policy_json   = data.aws_iam_policy_document.release_deploy.json
      }
    }
  )
}

output "provider_arn" {
  value = module.github_oidc.provider_arn
}

output "role_arns" {
  description = "Copiar para as variables AWS_ROLE_ARN_* de cada repositório no GitHub (não é segredo)."
  value       = module.github_oidc.role_arns
}

output "workload_boundary_arn" {
  description = "Permissions boundary obrigatório para roles criadas em /plataforma/."
  value       = aws_iam_policy.workload_boundary.arn
}
