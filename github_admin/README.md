# Plataforma GitHub Admin

CLI Python para comparar o estado da organização GitHub com uma configuração declarativa e aplicar somente as diferenças aprovadas.

## Segurança

- lê o token exclusivamente de `GH_TOKEN`;
- nunca aceita token por argumento ou arquivo;
- mascara valores sensíveis em erros;
- `audit`, `validate` e `plan` são read-only;
- `apply` exige `--confirm <ORGANIZACAO>`;
- não remove repositórios, Teams, membros ou regras;
- suporta `--only` para aplicar uma categoria por vez;
- não tenta contornar recursos indisponíveis no plano GitHub.

Use um fine-grained PAT temporário, com expiração curta e permissões mínimas, ou um installation token de GitHub App. Revogue o PAT após o bootstrap.

## Uso

```powershell
cd github_admin
python manage.py validate --config config/github.json
$env:GH_TOKEN = '<defina fora do repositório>'
python manage.py audit --config config/github.json --output audit-report.json
python manage.py plan --config config/github.json --output plan.json
python manage.py apply --config config/github.json --confirm unisenaisorocaba
python manage.py import-backlogs --config config/github.json --confirm unisenaisorocaba
```

Não cole o token no chat e não use `setx`, pois ele persistiria o segredo. Prefira uma sessão PowerShell temporária ou credential manager.

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
4. Revisar `plan.json`.
5. Aplicar por categoria: `--only teams`, depois `repositories`, `labels`, `rulesets`, `environments`, `project`.
6. Importar backlogs por último.
7. Fazer PR de teste, validar acessos e revogar o token temporário.
