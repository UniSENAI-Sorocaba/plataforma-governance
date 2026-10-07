# INF-001 — Bootstrap do state remoto.
# Problema do ovo e da galinha: o bucket que guarda o state não pode ter o state
# guardado nele mesmo. Por isso este root usa state LOCAL e roda uma única vez.
terraform {
  required_version = ">= 1.10.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test" # credencial falsa: só vale no MiniStack
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

  endpoints {
    s3  = "http://localhost:4566"
    sts = "http://localhost:4566"
  }
}

variable "environment" {
  type    = string
  default = "development"
}

resource "aws_s3_bucket" "state" {
  bucket = "plataforma-tfstate-${var.environment}"
}

# Versionamento = dá para voltar a uma versão anterior do state se algo corromper.
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Criptografia em repouso (o state pode conter dados sensíveis!).
resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      # No laboratório: SSE-S3 (AES256), chave gerenciada pela AWS.
      # Na AWS real, em produção: sse_algorithm = "aws:kms" com uma chave KMS gerenciada
      # pelo projeto (kms_master_key_id), cuja key policy libera apenas as roles de CI e de
      # administração. Assim, ler o state exige permissão no bucket E na chave.
      sse_algorithm = "AES256"
    }
  }
}

# Ninguém na internet lê esse bucket.
resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Desativa ACLs: todos os objetos pertencem à conta dona do bucket e o acesso é
# controlado apenas por policies (IAM e bucket policy), que são auditáveis.
resource "aws_s3_bucket_ownership_controls" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Recusa qualquer requisição feita sem TLS (HTTP puro), mesmo que autenticada.
# Na AWS real, acrescente um segundo statement negando o acesso a qualquer principal
# que não seja as roles de CI (gha-infra-plan, gha-infra-apply) e de administração.
data "aws_iam_policy_document" "state_tls_only" {
  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.state.arn,
      "${aws_s3_bucket.state.arn}/*",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "state" {
  bucket = aws_s3_bucket.state.id
  policy = data.aws_iam_policy_document.state_tls_only.json

  # A policy só é aplicada depois do bloqueio de acesso público, evitando uma janela
  # em que o bucket teria policy mas ainda aceitaria configurações públicas.
  depends_on = [aws_s3_bucket_public_access_block.state]
}

output "state_bucket" {
  value = aws_s3_bucket.state.bucket
}
