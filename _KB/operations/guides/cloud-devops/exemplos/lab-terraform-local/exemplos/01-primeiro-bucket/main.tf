# Exemplo 01 — o menor Terraform possível contra o MiniStack.
# Usa state LOCAL (arquivo terraform.tfstate nesta pasta) para que o conteúdo possa ser aberto e estudado.

terraform {
  required_version = ">= 1.10.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# O provider AWS normalmente se comunica com a AWS real. Aqui os endpoints são redirecionados para o MiniStack.
provider "aws" {
  region     = "us-east-1"
  access_key = "test" # credencial fictícia: o MiniStack aceita "test"/"test"
  secret_key = "test"

  # Pula checagens que só fazem sentido na AWS real:
  skip_credentials_validation = true # não tenta validar a chave na AWS
  skip_requesting_account_id  = true # não pergunta o número da conta
  skip_metadata_api_check     = true # não procura credencial de máquina EC2
  s3_use_path_style           = true # URL localhost:4566/bucket (e não bucket.localhost)

  # Redirecionamento: cada serviço utilizado aponta para o MiniStack.
  endpoints {
    s3 = "http://localhost:4566"
  }
}

variable "seu_nome" {
  description = "Identificador em minúsculas, sem espaços (ex.: teste). Compõe o nome do bucket."
  type        = string
  default     = "exemplo"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,20}$", var.seu_nome))
    error_message = "Use só letras minúsculas, números e hífen (3 a 20 caracteres)."
  }
}

resource "aws_s3_bucket" "meu_bucket" {
  bucket = "primeiro-bucket-${var.seu_nome}"
}

# Um arquivo dentro do bucket, com conteúdo escrito aqui mesmo.
resource "aws_s3_object" "ola" {
  bucket       = aws_s3_bucket.meu_bucket.id # ← referência: só cria depois do bucket
  key          = "ola.txt"
  content      = "Olá, ${var.seu_nome}! Este arquivo foi criado pelo Terraform."
  content_type = "text/plain"
}

output "bucket" {
  value = aws_s3_bucket.meu_bucket.bucket
}

output "como_ler_o_arquivo" {
  value = "make aws CMD=\"s3 cp s3://${aws_s3_bucket.meu_bucket.bucket}/ola.txt -\""
}
