# INF-002 — VPC, subnets, rotas e security groups.
#
#  Internet ──► IGW ──► subnets PÚBLICAS (ALB)      10.x.0.0/24, 10.x.1.0/24
#                          │
#                          ▼
#                 subnets PRIVADAS (ECS + RDS)      10.x.10.0/24, 10.x.11.0/24
#
# Nada nas privadas tem IP público. Na AWS real ainda entraria um NAT Gateway
# (cerca de US$ 32/mês cada; ver 09-custos-e-finops.md) ou VPC Endpoints.

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "plataforma-${var.environment}" }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "plataforma-${var.environment}-igw" }
}

# count.index gera uma subnet por AZ; cidrsubnet() "fatia" o /16 em /24.
resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.this.id
  availability_zone       = var.azs[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = false
  tags                    = { Name = "plataforma-${var.environment}-public-${count.index}", Tier = "public" }
}

resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.this.id
  availability_zone = var.azs[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  tags              = { Name = "plataforma-${var.environment}-private-${count.index}", Tier = "private" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = { Name = "plataforma-${var.environment}-public-rt" }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security groups encadeados: só o ALB fala com a API; só a API fala com o banco.
resource "aws_security_group" "alb" {
  name        = "plataforma-${var.environment}-alb"
  description = "Entrada HTTPS publica"
  vpc_id      = aws_vpc.this.id

  # Somente HTTPS (443). Se for criado um listener na porta 80, ele deve apenas
  # redirecionar para 443 (resposta HTTP 301) e nunca encaminhar tráfego à aplicação.
  #
  # Quando alb_ingress_prefix_list_ids é informado (por exemplo, com a prefix list
  # gerenciada "com.amazonaws.global.cloudfront.origin-facing"), o ALB passa a aceitar
  # conexões apenas do CloudFront, e não de qualquer endereço da internet. Isso impede
  # que alguém contorne o CloudFront (e um eventual WAF) acessando o ALB diretamente.
  # Complemente com um cabeçalho secreto enviado pelo CloudFront e conferido no listener.
  ingress {
    description     = length(var.alb_ingress_prefix_list_ids) > 0 ? "HTTPS somente do CloudFront" : "HTTPS da internet"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = length(var.alb_ingress_prefix_list_ids) > 0 ? null : ["0.0.0.0/0"]
    prefix_list_ids = length(var.alb_ingress_prefix_list_ids) > 0 ? var.alb_ingress_prefix_list_ids : null
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name        = "plataforma-${var.environment}-app"
  description = "Backend Spring Boot (ECS Fargate)"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "8080 apenas a partir do ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name        = "plataforma-${var.environment}-db"
  description = "PostgreSQL 16 privado"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "5432 apenas a partir do backend"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }
}
