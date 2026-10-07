variable "github_org" {
  description = "Organização do GitHub dona dos repositórios."
  type        = string
  default     = "UniSENAI-Sorocaba"
}

variable "github_org_id" {
  description = <<-EOT
    ID numérico da organização. Quando informado, usa o formato IMUTÁVEL do claim sub
    (padrão do GitHub para repos criados após 2026-07-15):
      repo:<org>@<org_id>/<repo>@<repo_id>:<contexto>
    Confira o prefixo real de cada repo com:
      gh api repos/<org>/<repo>/actions/oidc/customization/sub --jq .sub_claim_prefix
  EOT
  type        = number
  default     = null
}

variable "create_provider" {
  description = "Cria o OIDC provider. Só pode existir UM por conta AWS; use false se ele já existir."
  type        = bool
  default     = true
}

variable "existing_provider_arn" {
  description = "ARN do provider já existente (quando create_provider = false)."
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path IAM das roles: facilita achar e limitar tudo que é de CI."
  type        = string
  default     = "/github-actions/"
}

variable "roles" {
  description = <<-EOT
    Uma entrada por role. A chave vira o nome "gha-<chave>".
      repository   : nome do repo, sem a org (ex.: "plataforma-backend")
      repository_id: ID numérico do repo (obrigatório quando github_org_id é informado)
      subjects   : final do claim "sub" aceito, ex.:
                   "environment:production" | "pull_request" | "ref:refs/heads/main"
      policy_json: política inline de privilégio mínimo (JSON)
  EOT
  type = map(object({
    repository           = string
    repository_id        = optional(number)
    subjects             = list(string)
    policy_json          = string
    max_session_duration = optional(number, 3600)
  }))

  # Guardrail: curinga no sub = qualquer repo/branch poderia assumir a role.
  validation {
    condition = alltrue([
      for r in values(var.roles) :
      !strcontains(r.repository, "*") && alltrue([for s in r.subjects : !strcontains(s, "*")])
    ])
    error_message = "Curinga (*) não é permitido em repository nem em subjects."
  }

  validation {
    condition     = var.github_org_id == null || alltrue([for r in values(var.roles) : r.repository_id != null])
    error_message = "Com github_org_id (formato imutável), toda role precisa de repository_id."
  }

  validation {
    condition = alltrue(flatten([
      for r in values(var.roles) : [
        for s in r.subjects :
        can(regex("^(environment:[A-Za-z0-9_-]+|pull_request|ref:refs/(heads|tags)/.+)$", s))
      ]
    ]))
    error_message = "subjects aceita apenas environment:<nome>, pull_request ou ref:refs/heads|tags/<nome>."
  }
}
