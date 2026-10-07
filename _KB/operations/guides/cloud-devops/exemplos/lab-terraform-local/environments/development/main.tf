# Root do ambiente: só "monta" os módulos, passando outputs de um para o outro.
# É aqui que as dependências do backlog viram dependências do grafo do Terraform.

locals { environment = "development" }

module "network" { # INF-002
  source      = "../../modules/network"
  environment = local.environment
  vpc_cidr    = "10.10.0.0/16" # staging = 10.20.0.0/16, production = 10.30.0.0/16
}

module "storage" { # INF-010
  source      = "../../modules/storage"
  environment = local.environment
}

module "registry" { # INF-006
  source      = "../../modules/registry"
  environment = local.environment
}

module "database" { # INF-005 + INF-008 — depende da rede (INF-002)
  source               = "../../modules/database"
  environment          = local.environment
  private_subnet_ids   = module.network.private_subnet_ids
  db_security_group_id = module.network.db_security_group_id
}
