# Laboratório local: Terraform com AWS emulada (MiniStack)

Laboratório para praticar Terraform sem conta AWS e sem custo. A AWS é emulada pelo
[MiniStack](https://github.com/ministackorg/ministack), executado em um container Docker, e o código
segue a mesma organização do repositório `plataforma-infrastructure`
(`bootstrap/` → `modules/` → `environments/`).

A explicação completa (conceitos, configuração do provider, limitações do emulador, solução de
problemas e exercícios) está em [`05-laboratorio-local-ministack.md`](../../05-laboratorio-local-ministack.md).

> Versões testadas em 2026-10-05: MiniStack 1.5.20 (fixada no `compose.yaml`), Terraform 1.13.5 e
> provider AWS `~> 6.0`. O ciclo `apply → destroy → apply → plan` termina em `No changes` (28 recursos).

## Pré-requisitos

- Docker (Docker Desktop no macOS e no Windows com WSL2; Docker Engine no Linux), em execução.
- `make`.
- Terraform é opcional. Quando o comando `terraform` não está instalado, o `Makefile` executa a
  imagem `hashicorp/terraform:1.13` em container.

## Primeiro contato (exemplo 01)

```bash
make up                        # inicia o emulador em http://localhost:4566
make status                    # confirma que o emulador está no ar
make exemplo NOME=teste        # cria um bucket S3 com um arquivo
make aws CMD="s3 ls"           # lista os buckets
make exemplo-destroy NOME=teste
```

O código do exemplo está em `exemplos/01-primeiro-bucket/main.tf`.

## Ambiente completo (development)

```bash
make up          # 1. inicia o emulador
make bootstrap   # 2. cria o bucket do state remoto (uma única vez)
make check       # 3. fmt + validate, as mesmas verificações do repositório real
make init        # 4. conecta o ambiente development ao state remoto
make plan        # 5. mostra o que será criado (28 recursos)
make apply       # 6. aplica o plano
make plan        # 7. deve resultar em "No changes" (idempotência)
make destroy     # 8. remove os recursos
make down        # 9. desliga o emulador e descarta todos os dados
```

Inspeção com a AWS CLI já configurada para o emulador:

```bash
make aws CMD="ec2 describe-vpcs --query Vpcs[].CidrBlock"
make aws CMD="secretsmanager list-secrets --query SecretList[].Name"
make aws CMD="s3 ls s3://plataforma-tfstate-development --recursive"   # o arquivo de state
docker ps --filter name=ministack-rds                                   # o PostgreSQL 16 criado pelo "RDS"
```

## Conteúdo

| Caminho | Item do backlog | O que demonstra |
| --- | --- | --- |
| `bootstrap/` | INF-001 | Bucket do state: versionado, cifrado e sem acesso público |
| `modules/network/` | INF-002 | VPC /16, duas sub-redes públicas e duas privadas, internet gateway, security groups encadeados |
| `modules/storage/` | INF-010 | Bucket de uploads sem acesso público, com criptografia e lifecycle |
| `modules/registry/` | INF-006 | Repositórios ECR com tag imutável, scan on push e lifecycle |
| `modules/database/` | INF-005, INF-008 | RDS PostgreSQL 16 privado e cifrado; senha gerada e guardada no Secrets Manager |
| `environments/development/` | INF-001 | Root que compõe os módulos e usa backend S3 com lock nativo |
| `modules/github-oidc/` | INF-004 | Provedor OIDC e roles do GitHub Actions com trust policy exata |
| `global/github-oidc/` | INF-004 | Root da conta de produção: matriz de roles (plan em PR, apply, publicação de imagens, deploy pelo repositório de release) e permissions boundary |
| `exemplos/01-primeiro-bucket/` | - | Menor configuração Terraform possível: um bucket e um arquivo |

## Comandos

Execute `make help` para a lista completa. Resumo:

| Comando | Função |
| --- | --- |
| `make up` / `make down` | Inicia / desliga o emulador (`down` descarta todos os dados) |
| `make status` | Informa se o emulador está no ar |
| `make reset` | Desliga, remove states locais desatualizados, inicia e recria o bucket do state |
| `make bootstrap` | Cria o bucket do state remoto |
| `make check` | `terraform fmt -check` e `terraform validate` |
| `make init` / `plan` / `apply` / `destroy` | Terraform no ambiente `development` |
| `make oidc-init` / `oidc-plan` / `oidc-apply` | Terraform no root `global/github-oidc` |
| `make exemplo NOME=...` / `make exemplo-destroy NOME=...` | Exemplo 01 |
| `make aws CMD="..."` | AWS CLI apontada para o emulador |

## OIDC do GitHub (INF-004)

```bash
make bootstrap
make oidc-init && make oidc-plan && make oidc-apply
make aws CMD="iam get-role --role-name gha-backend-publish --query Role.AssumeRolePolicyDocument"
make aws CMD="iam list-roles --path-prefix /github-actions/ --query Roles[].RoleName"
```

A role `gha-release-deploy` só é criada quando o ID do repositório `plataforma-release` é informado:
`terraform -chdir=global/github-oidc plan -var release_repository_id=<id>`. Com
`-var use_github_environments=true`, as roles que alteram produção passam a aceitar
`environment:production` em vez da branch `main`.

Explicação em [`07-oidc-github-actions-aws.md`](../../07-oidc-github-actions-aws.md). O emulador aceita
`AssumeRoleWithWebIdentity` mesmo com um token inválido: o laboratório valida a estrutura dos recursos,
não a segurança da configuração.

## Limitações principais

- Permissões IAM não são avaliadas por padrão. Com `AUTH: "true"` no `compose.yaml`, as policies passam
  a ser avaliadas, mas a secret key e a assinatura de tokens OIDC continuam sem verificação.
- Os dados ficam em memória: reiniciar o container ou o computador apaga tudo. Use `make reset`.
- Alguns atributos não são persistidos (por exemplo, `max_allocated_storage`); o bloco marcado como
  `WORKAROUND DO EMULADOR` em `modules/database/main.tf` existe por isso.
- Não há cobrança, portanto o laboratório não serve para estimar custos.

## Diferenças em relação ao repositório real

1. Remover `access_key`, `secret_key`, `endpoints` e os parâmetros `skip_*` do provider e do backend.
2. Obter credenciais pelo OIDC do GitHub Actions (INF-004), nunca por chave fixa.
3. Substituir `AES256` por KMS com chave gerenciada onde for adequado.
4. Definir a saída para a internet das sub-redes privadas (NAT ou VPC endpoints), conforme a análise de custos.
5. Remover o bloco `WORKAROUND DO EMULADOR`.
