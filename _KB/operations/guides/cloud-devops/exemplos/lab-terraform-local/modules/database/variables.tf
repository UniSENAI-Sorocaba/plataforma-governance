variable "environment" { type = string }

variable "postgres_major_version" {
  type    = string
  default = "16"

  validation {
    condition     = var.postgres_major_version == "16"
    error_message = "A baseline normativa exige PostgreSQL 16."
  }
}

variable "private_subnet_ids" { type = list(string) }
variable "db_security_group_id" { type = string }

variable "instance_class" {
  type    = string
  default = "db.t4g.micro" # menor classe; compatível com o orçamento de US$ 120/mês (INF-014)
}

variable "backup_retention_days" {
  description = "INF-015: política exige 14 dias em produção."
  type        = number
  default     = 7
}

variable "password_version" {
  description = "Versão da senha do usuário master. Incremente para gerar e aplicar uma nova senha (atributos write-only só são reenviados quando a versão muda)."
  type        = number
  default     = 1
}
