variable "environment" {
  description = "Nome do ambiente isolado."
  type        = string

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "environment deve ser development, staging ou production."
  }
}

variable "vpc_cidr" {
  description = "CIDR exclusivo do ambiente (não pode colidir entre ambientes)."
  type        = string
}

variable "azs" {
  description = "Zonas de disponibilidade (Multi-AZ = 2 no mínimo)."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "alb_ingress_prefix_list_ids" {
  description = "Prefix lists autorizadas a acessar o ALB na porta 443 (ex.: a do CloudFront). Lista vazia = qualquer endereço da internet."
  type        = list(string)
  default     = []
}
