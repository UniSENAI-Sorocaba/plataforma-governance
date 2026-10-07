locals {
  endpoint = "http://localhost:4566"
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

  endpoints {
    iam = local.endpoint
    sts = local.endpoint
    s3  = local.endpoint
  }

  default_tags {
    tags = {
      Project   = "plataforma-digital"
      ManagedBy = "terraform"
      Squad     = "cloud-devops"
      Issue     = "INF-004"
    }
  }
}
