# Provider configurado para o MiniStack. Na AWS real, ficaria apenas:
#   provider "aws" { region = "us-east-1" }
# e as credenciais viriam do OIDC do GitHub Actions (INF-004), nunca de chave fixa.
locals {
  endpoint = "http://localhost:4566"
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

  endpoints {
    ec2            = local.endpoint
    s3             = local.endpoint
    ecr            = local.endpoint
    rds            = local.endpoint
    secretsmanager = local.endpoint
    iam            = local.endpoint
    sts            = local.endpoint
  }

  # Toda resource criada recebe essas tags → rastreabilidade e FinOps.
  default_tags {
    tags = {
      Project     = "plataforma-digital"
      Environment = local.environment
      ManagedBy   = "terraform"
      Squad       = "cloud-devops"
    }
  }
}
