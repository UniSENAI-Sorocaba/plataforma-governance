terraform {
  # >= 1.11: atributos write-only usados no módulo database (senha fora do state).
  required_version = ">= 1.11.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }

  # INF-001 — state remoto no bucket criado pelo bootstrap.
  # use_lockfile = lock nativo do S3 (Terraform >= 1.10). A tabela DynamoDB
  # para lock ainda funciona mas está DEPRECATED — não precisamos mais dela.
  backend "s3" {
    bucket       = "plataforma-tfstate-development"
    key          = "development/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true

    # ---- só para o MiniStack; na AWS real estas linhas somem ----
    endpoints                   = { s3 = "http://localhost:4566" }
    access_key                  = "test"
    secret_key                  = "test"
    use_path_style              = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}
