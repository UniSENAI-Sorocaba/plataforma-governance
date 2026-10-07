# INF-005 (RDS privado e cifrado) + INF-008 (senha no Secrets Manager).
#
# A senha do usuário master NÃO fica no state do Terraform:
#  - ephemeral "random_password" gera o valor apenas durante a execução, sem gravá-lo;
#  - os atributos write-only (password_wo e secret_string_wo) enviam o valor à AWS,
#    mas o Terraform não o guarda no state nem o mostra no plan.
# Requer Terraform >= 1.11 e provider random >= 3.7.
#
# Para trocar a senha, incremente var.password_version: os atributos write-only só
# são reenviados quando a versão muda (o Terraform não tem como comparar um valor
# que ele não guarda).
#
# Alternativa preferível na AWS real: manage_master_user_password = true no
# aws_db_instance. A própria AWS gera a senha, guarda em um segredo gerenciado pelo
# RDS e pode fazer a rotação automática; a senha nunca passa pelo Terraform. Ela não
# é usada aqui porque o laboratório também ensina a criar e consumir um segredo no
# Secrets Manager, e o suporte do emulador a segredos gerenciados pelo RDS é limitado.

ephemeral "random_password" "master" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret" "db" {
  name = "plataforma/${var.environment}/database"

  # Comportamento da AWS real: um segredo excluído fica até 30 dias "agendado para exclusão"
  # e o nome não pode ser reutilizado nesse período. Fora de produção, a exclusão é imediata.
  recovery_window_in_days = var.environment == "production" ? 30 : 0
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  # Write-only: o conteúdo (com a senha) vai para o Secrets Manager e não para o state.
  secret_string_wo = jsonencode({
    username = local.master_username
    password = ephemeral.random_password.master.result
    host     = aws_db_instance.this.address
    port     = aws_db_instance.this.port
    dbname   = local.db_name
  })
  secret_string_wo_version = var.password_version
}

locals {
  db_name         = "plataforma"
  master_username = "plataforma_admin"
}

# Subnet group: restringe o RDS às sub-redes privadas.
resource "aws_db_subnet_group" "this" {
  name       = "plataforma-${var.environment}"
  subnet_ids = var.private_subnet_ids
}

# Parameter group: configurações do PostgreSQL definidas como código.
resource "aws_db_parameter_group" "this" {
  name   = "plataforma-${var.environment}-pg16"
  family = "postgres16"

  # Recusa conexões sem TLS: o tráfego entre a aplicação e o banco é sempre cifrado.
  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }

  # Registra consultas que levam mais de 1 segundo, para diagnóstico de desempenho.
  # O log não deve conter dados pessoais: evite valores literais sensíveis nas consultas.
  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }
}

resource "aws_db_instance" "this" {
  identifier     = "plataforma-${var.environment}"
  engine         = "postgres"
  engine_version = var.postgres_major_version
  instance_class = var.instance_class

  allocated_storage     = 20
  max_allocated_storage = 50   # crescimento automático do armazenamento até 50 GB
  storage_encrypted     = true # cifrado em repouso (na AWS real, em produção: kms_key_id próprio)

  db_name  = local.db_name
  username = local.master_username

  # Write-only: a senha é enviada à AWS, mas não fica no state.
  password_wo         = ephemeral.random_password.master.result
  password_wo_version = var.password_version

  db_subnet_group_name   = aws_db_subnet_group.this.name
  parameter_group_name   = aws_db_parameter_group.this.name
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible    = false # nunca exposto à internet

  backup_retention_period    = var.backup_retention_days
  copy_tags_to_snapshot      = true # snapshots herdam as tags (rastreabilidade e custo)
  auto_minor_version_upgrade = true # correções de segurança da versão 16.x na janela de manutenção
  multi_az                   = var.environment == "production"
  deletion_protection        = var.environment == "production"
  skip_final_snapshot        = var.environment != "production"
  final_snapshot_identifier  = var.environment == "production" ? "plataforma-${var.environment}-final" : null

  # WORKAROUND DO EMULADOR: o MiniStack não persiste max_allocated_storage e o
  # plan mostraria "1 to change" para sempre. Na AWS real, REMOVA este bloco.
  lifecycle {
    ignore_changes = [max_allocated_storage]
  }
}
