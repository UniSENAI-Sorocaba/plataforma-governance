# INF-006 — ECR: onde moram as imagens Docker do backend e do frontend.

variable "environment" { type = string }

variable "repositories" {
  type    = set(string)
  default = ["plataforma-backend", "plataforma-frontend"]
}

# for_each cria um repositório para cada nome do set.
resource "aws_ecr_repository" "this" {
  for_each = var.repositories
  name     = "${each.key}-${var.environment}"

  # Tag imutável: "v1.2.0" sempre aponta para a mesma imagem → rollback confiável.
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true # vulnerabilidades analisadas a cada push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

# Lifecycle: mantém só as 20 imagens mais recentes (custo de armazenamento).
resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = aws_ecr_repository.this
  repository = each.value.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Mantem as 20 imagens mais recentes"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 20
      }
      action = { type = "expire" }
    }]
  })
}

output "repository_urls" {
  value = { for k, r in aws_ecr_repository.this : k => r.repository_url }
}
