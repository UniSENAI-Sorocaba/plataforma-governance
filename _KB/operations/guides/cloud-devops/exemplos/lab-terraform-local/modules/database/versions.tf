terraform {
  # Atributos write-only (password_wo, secret_string_wo) exigem Terraform >= 1.11.
  required_version = ">= 1.11.0"

  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 6.0" }
    # ephemeral "random_password" exige o provider random >= 3.7.
    random = { source = "hashicorp/random", version = ">= 3.7" }
  }
}
