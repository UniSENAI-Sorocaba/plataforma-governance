# INF-010 — Bucket de uploads (entregáveis dos PIs, certificados).
# O backend gera URL pré-assinada curta (BE-012); o bucket NUNCA é público.

variable "environment" { type = string }

variable "noncurrent_days" {
  description = "Dias até apagar versões antigas dos objetos."
  type        = number
  default     = 30
}

variable "allowed_origins" {
  description = "Origens (domínios do frontend) autorizadas a enviar e ler arquivos diretamente por URL pré-assinada. Lista vazia = sem CORS."
  type        = list(string)
  default     = []

  validation {
    condition     = !contains(var.allowed_origins, "*")
    error_message = "Curinga (*) não é permitido em allowed_origins: informe os domínios exatos do frontend."
  }
}

resource "aws_s3_bucket" "uploads" {
  bucket = "plataforma-uploads-${var.environment}"
}

resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket                  = aws_s3_bucket.uploads.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Desativa ACLs: o acesso é controlado apenas por policies.
resource "aws_s3_bucket_ownership_controls" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Recusa requisições sem TLS. URLs pré-assinadas continuam funcionando, pois usam HTTPS.
data "aws_iam_policy_document" "uploads_tls_only" {
  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.uploads.arn,
      "${aws_s3_bucket.uploads.arn}/*",
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

resource "aws_s3_bucket_policy" "uploads" {
  bucket     = aws_s3_bucket.uploads.id
  policy     = data.aws_iam_policy_document.uploads_tls_only.json
  depends_on = [aws_s3_bucket_public_access_block.uploads]
}

# CORS: necessário apenas quando o navegador envia ou baixa o arquivo direto do S3
# usando a URL pré-assinada gerada pelo backend (BE-012). Só os domínios do frontend.
resource "aws_s3_bucket_cors_configuration" "uploads" {
  count  = length(var.allowed_origins) > 0 ? 1 : 0
  bucket = aws_s3_bucket.uploads.id

  cors_rule {
    allowed_methods = ["GET", "PUT"]
    allowed_origins = var.allowed_origins
    allowed_headers = ["Content-Type", "Content-MD5"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # na AWS real, em produção: "aws:kms" com chave gerenciada pelo projeto
    }
  }
}

resource "aws_s3_bucket_versioning" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle: versões antigas somem sozinhas → controla custo (FinOps).
resource "aws_s3_bucket_lifecycle_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  rule {
    id     = "expira-versoes-antigas"
    status = "Enabled"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }

  depends_on = [aws_s3_bucket_versioning.uploads]
}

output "bucket_name" { value = aws_s3_bucket.uploads.bucket }
output "bucket_arn" { value = aws_s3_bucket.uploads.arn }
