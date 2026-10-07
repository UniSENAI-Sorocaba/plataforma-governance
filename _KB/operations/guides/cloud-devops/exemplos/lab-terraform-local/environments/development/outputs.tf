output "vpc_id" { value = module.network.vpc_id }
output "private_subnet_ids" { value = module.network.private_subnet_ids }
output "uploads_bucket" { value = module.storage.bucket_name }
output "ecr_repositories" { value = module.registry.repository_urls }
output "database_endpoint" { value = module.database.endpoint }
output "database_secret_arn" { value = module.database.secret_arn }
