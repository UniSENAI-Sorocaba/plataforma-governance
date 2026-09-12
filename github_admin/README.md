# Plataforma GitHub Admin

CLI Python para comparar o estado da organização GitHub com uma configuração declarativa e aplicar somente as diferenças aprovadas.

## Segurança

- lê o token exclusivamente da variável `GH_TOKEN`;
- carrega automaticamente `GH_TOKEN` do arquivo local `.env`, sem sobrescrever uma variável já definida no processo;
- nunca aceita token por argumento ou pelo arquivo de configuração declarativa;
- mascara valores sensíveis em erros;
- `audit`, `validate` e `plan` são read-only;
- `apply` exige `--confirm <ORGANIZACAO>`;
- não remove Teams, membros ou regras;
- a única exclusão suportada é `delete-legacy`, limitada à lista explícita `migration.legacy_repositories` e protegida por confirmação dupla;
- suporta `--only` para aplicar uma categoria por vez;
- não tenta contornar recursos indisponíveis no plano GitHub.

Use um fine-grained PAT temporário, com expiração curta e permissões mínimas, ou um installation token de GitHub App. Revogue o PAT após o bootstrap.

## Uso

```powershell
cd github_admin
python manage.py validate --config config/github.json
# Crie .env com uma única linha: GH_TOKEN=<seu-token>
python manage.py audit --config config/github.json
python manage.py plan --config config/github.json
python manage.py apply --config config/github.json --confirm UniSENAI-Sorocaba
python manage.py import-backlogs --config config/github.json --confirm UniSENAI-Sorocaba
python manage.py sync-project --config config/github.json --confirm UniSENAI-Sorocaba --stage structure
python manage.py sync-project --config config/github.json --confirm UniSENAI-Sorocaba --stage issues --repository plataforma-backend
python manage.py sync-project --config config/github.json --confirm UniSENAI-Sorocaba --stage fields --repository plataforma-backend
python manage.py sync-project --config config/github.json --confirm UniSENAI-Sorocaba --stage assignments --repository plataforma-backend
python manage.py delete-legacy --config config/github.json --confirm UniSENAI-Sorocaba --confirm-delete DELETE-LEGACY
```

O modelo adotado usa um único Project organizacional como portfólio do produto. O trabalho continua separado nos seis repositórios e pode ser operado pelas views de Squad e de Sprint. Isso mantém dependências entre equipes visíveis sem duplicar Issues em vários Projects.

O estágio `issues` atualiza descrições e labels de forma idempotente. O estágio `assignments` aplica o assignee nativo somente quando o usuário já está elegível no repositório; enquanto um convite estiver pendente, o campo `Responsável planejado` preserva a atribuição definida no backlog.

O `.env` está ignorado pelo Git e deve permanecer somente na máquina local. Não cole o token no chat e não use `setx`, pois ele persistiria o segredo. Em automações CI, defina `GH_TOKEN` por GitHub Actions Secrets; a variável do processo tem precedência sobre o `.env`.

`audit` salva por padrão em `audit-report.md` e `plan` em `plan.md`. Use `--output caminho/arquivo.md` para escolher outro destino. Para integrações que ainda precisem de JSON, informe uma saída terminada em `.json`.

A configuração atual pressupõe GitHub Free com repositórios privados. Por isso, rulesets e environments estão registrados em `deferred_until_github_team` e não entram no `plan`/`apply`. Quando a organização migrar para GitHub Team, mova essas duas configurações novamente para as chaves de primeiro nível `ruleset` e `environments`.

## Cobertura

- organização e plano detectado;
- repositórios e configurações básicas;
- Teams, membros conhecidos e permissões por repositório;
- labels;
- rulesets de branch por repositório;
- environments;
- Project V2 organizacional básico;
- criação idempotente de Issues a partir dos backlogs Markdown.

Secrets não são enviados pelo arquivo declarativo. A CLI configura apenas a estrutura; valores secretos devem ser inseridos separadamente no GitHub/AWS com criptografia apropriada.

## Fluxo recomendado

1. Copiar `config/github.example.json` para `config/github.json`.
2. Preencher usernames pendentes sem inserir tokens.
3. Executar `validate`, `audit` e `plan`.
4. Revisar `plan.md`.
5. Aplicar por categoria: `--only teams`, depois `repositories`, `labels`, `rulesets`, `environments`, `project`.
6. Importar backlogs por último.
7. Fazer PR de teste, validar acessos e revogar o token temporário.
