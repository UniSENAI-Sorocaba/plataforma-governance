output "provider_arn" {
  value = local.provider_arn
}

# Vai para as *variables* dos environments do GitHub (não é segredo).
output "role_arns" {
  value = { for k, r in aws_iam_role.this : k => r.arn }
}
