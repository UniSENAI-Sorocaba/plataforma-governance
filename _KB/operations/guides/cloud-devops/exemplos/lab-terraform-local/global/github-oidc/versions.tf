terraform {
  required_version = ">= 1.10.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Root "global" da conta: IAM não pertence a um ambiente, pertence à CONTA.
  # Aplicado UMA vez por um humano (admin), junto do bootstrap — o pipeline
  # ainda não tem acesso antes desta role existir (ovo e galinha).
  backend "s3" {
    bucket       = "plataforma-tfstate-development"
    key          = "global/github-oidc.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true

    # ---- só para o MiniStack ----
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
