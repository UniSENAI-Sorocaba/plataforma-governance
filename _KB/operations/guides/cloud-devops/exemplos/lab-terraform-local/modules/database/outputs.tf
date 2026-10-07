output "endpoint" { value = aws_db_instance.this.address }
output "port" { value = aws_db_instance.this.port }
# Só o ARN do segredo sai do módulo — o backend lê o valor em runtime.
output "secret_arn" { value = aws_secretsmanager_secret.db.arn }
