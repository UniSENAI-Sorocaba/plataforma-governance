# Configuração do GitHub — Plataforma Digital

> Status: **Pronto para execução**
> Fonte organizacional: [`new_teams.md`](new_teams.md)
> Data: 2026-09-10

## 1. Objetivo e decisões adotadas

Este documento define a configuração necessária da organização GitHub `UniSENAI-Sorocaba` para operar a Plataforma Digital em arquitetura multi-repositório, com cinco squads funcionais e governança centralizada.

Decisões:

- Luciano Menezes Júnior (`@lucianomenezesjr`) é **Lead Product Owner (LPO) / PO Coach**.
- Fellipe Raszejas (`@FellipeRaszejas`) é **Product Owner (PO)**.
- `new_teams.md` é a fonte de verdade da composição das equipes.
- O trabalho é controlado por Issues e por um único GitHub Project organizacional.
- O desenvolvimento usa GitHub Flow, com `main` protegida e releases por tag.
- Regras normativas ficam em um repositório de governança e são consumidas por tag e commit imutáveis.

### Plano GitHub adotado

Este guia não pressupõe GitHub Enterprise. Para repositórios privados, o plano mínimo recomendado é **GitHub Team**, pois oferece protected branches, required reviewers e CODEOWNERS. Se a organização permanecer no GitHub Free, essas proteções ficam limitadas em repositórios privados; nesse caso, usar repositórios públicos ou aceitar formalmente a redução dos gates.

Sem Enterprise:

- configurar rulesets/branch protection **em cada repositório**, não como uma policy única da organização;
- não depender de custom repository roles, merge queue ou controles exclusivos de Enterprise;
- tratar Secret Protection e Code Security em repositórios privados como add-ons opcionais do GitHub Team;
- manter scanners open source no Actions (`gitleaks`, `Trivy`, `OWASP ZAP` e análise da linguagem) como baseline independente de licença.

## 2. Organização e repositórios

Criar ou validar os seguintes repositórios privados:

| Repositório | Finalidade | Time mantenedor |
| --- | --- | --- |
| `plataforma-governance` | KB, requisitos, SPECs, ADRs, contratos globais e políticas | `product-governance` |
| `plataforma-backend` | API Java 21 / Spring Boot 3 | `backend` |
| `plataforma-frontend` | Aplicações Next.js com SSR | `frontend` |
| `plataforma-database` | modelo, migrations, seeds e validações de dados | `database` |
| `plataforma-infrastructure` | Terraform, ambientes AWS e observabilidade | `cloud-devops` |
| `plataforma-quality` | E2E, performance, DAST e evidências transversais | `quality-security` |

Configuração comum:

- branch padrão `main`;
- Issues, Projects e Discussions habilitados no repositório de governança; Issues habilitadas nos demais;
- Wiki desabilitada para evitar fonte documental concorrente;
- merge commits desabilitados; squash merge habilitado; rebase opcional;
- exclusão automática da branch após merge;
- releases e tags imutáveis para baselines e versões publicadas;
- nomes, descrições, tópicos e links do Project preenchidos em todos os repositórios.

## 3. GitHub Teams e permissões

Criar os times abaixo. Os nomes são slugs sugeridos.

| Team | Membros | Acesso |
| --- | --- | --- |
| `product-governance` | Luciano e Fellipe | Maintain em governance; Triage nos demais |
| `product-owners` | Luciano e Fellipe | Triage em todos; aprovação funcional conforme regra |
| `po-lead` | Luciano | Maintain em governance e administração do Project |
| `backend` | integrantes da squad Backend | Write em backend; Read nos demais |
| `frontend` | integrantes da squad Frontend | Write em frontend; Read nos demais |
| `database` | integrantes da squad Banco de Dados | Write em database; Read nos demais |
| `cloud-devops` | integrantes da squad Cloud & DevOps | Maintain em infrastructure; Read nos demais |
| `quality-security` | integrantes da squad Qualidade, Testes & Segurança | Write em quality; Triage nos repositórios de implementação |
| `technical-leads` | líderes e referências técnicas das cinco squads | Maintain nos repositórios técnicos aplicáveis |

Princípios:

- conceder acesso por Team, não diretamente por pessoa;
- limitar `Admin` aos administradores da organização;
- habilitar 2FA obrigatória na organização;
- usar contas pessoais nominativas; não compartilhar credenciais;
- revisar membros, outside collaborators e chaves trimestralmente;
- incluir Fellipe (`@FellipeRaszejas`) nos Teams e CODEOWNERS aplicáveis.

## 4. Rulesets de branches e tags

Aplicar o mesmo ruleset à branch `main` **individualmente em cada repositório**. A centralização organizacional descrita na versão anterior foi removida por exigir Enterprise:

- pull request obrigatório;
- ao menos 1 aprovação; 2 para governança Level 0/1, segurança, produção e migrations destrutivas;
- aprovação de CODEOWNERS obrigatória;
- invalidar aprovações quando novos commits forem enviados;
- exigir resolução de todas as conversas;
- impedir force push, exclusão e push direto;
- exigir branch atualizada antes do merge;
- bloquear merge quando houver check obrigatório pendente ou com falha;
- restringir bypass aos administradores, somente para incidente documentado;
- exigir commits assinados quando o plano da organização oferecer suporte adequado.

Checks comuns: `lint`, `build`, `unit-tests`, `secret-scan`, `dependency-review`, `codeql` e `spec-compliance`.

Checks específicos:

| Repositório | Checks adicionais |
| --- | --- |
| backend | testes de integração, cobertura >= 80% lines / 70% branches, contrato OpenAPI |
| frontend | typecheck, testes de componentes, cobertura da lógica >= 70%, build SSR |
| database | validação de migrations, lint SQL, teste de upgrade/rollback seguro |
| infrastructure | `terraform fmt`, `validate`, lint, scan IaC e plano sem erro |
| quality | Playwright, k6 quando aplicável, ZAP e publicação de evidências |
| governance | links, schema/front matter, IDs únicos, rastreabilidade e validação de contratos |

Criar rulesets de tags:

- proteger `governance-v*` em `plataforma-governance`;
- proteger `v*` nos repositórios de implementação;
- permitir criação de tags de release apenas a `cloud-devops`/release managers;
- não permitir mover ou excluir uma tag publicada.

## 5. CODEOWNERS

Criar `.github/CODEOWNERS` em cada repositório. Base para governança:

```text
*                         @UniSENAI-Sorocaba/product-governance
/_KB/product/             @UniSENAI-Sorocaba/product-owners
/_KB/requirements/        @UniSENAI-Sorocaba/product-owners
/_KB/specs/               @UniSENAI-Sorocaba/product-owners
/_KB/must-haves/          @UniSENAI-Sorocaba/product-governance @UniSENAI-Sorocaba/technical-leads
/_KB/architecture/        @UniSENAI-Sorocaba/technical-leads
/_KB/contracts/           @UniSENAI-Sorocaba/technical-leads
/_KB/security/            @UniSENAI-Sorocaba/quality-security
/.github/                 @UniSENAI-Sorocaba/cloud-devops @UniSENAI-Sorocaba/quality-security
```

Nos repositórios técnicos, usar o time da squad como owner padrão e adicionar owners especializados para `.github/`, infraestrutura, contratos, migrations e testes de segurança.

## 6. GitHub Project organizacional

Criar o Project **Plataforma Digital — 2026.2** e adicionar Issues de todos os repositórios.

Campos:

| Campo | Tipo / valores |
| --- | --- |
| Status | Backlog, Refinement, Ready, In Progress, In Review, Validation, Blocked, Done |
| Squad | Product, Backend, Frontend, Database, Cloud & DevOps, Quality |
| Epic | texto/iteração vinculando `EPIC-*` |
| Priority | P0, P1, P2, P3 |
| Iteration | Sprint 0 a Sprint 6; Future |
| Repository | automático |
| SPEC | texto ou link |
| Size | 1, 2, 3, 5, 8, 13 |
| Risk | Low, Medium, High, Critical |
| Target release | v0.x, v1.0.0, Future |

Views: Portfolio, Product/Governance, uma por squad, Current Iteration, Blocked, Release v1.0 e Future/2027.1.

Automações:

- Issue adicionada entra em `Backlog`;
- item com Sprint e DoR completo pode ir para `Ready`;
- PR vinculada aberta move para `In Review`;
- PR merged move para `Validation`, não diretamente para Done;
- fechamento após aceite/evidência move para `Done`;
- campo/reason obrigatório ao mover para `Blocked`.

## 7. Labels, milestones e templates

Labels comuns:

- tipo: `type:epic`, `type:feature`, `type:story`, `type:task`, `type:bug`, `type:spike`, `type:security`, `type:documentation`;
- prioridade: `priority:P0` a `priority:P3`;
- squad: `squad:backend`, `squad:frontend`, `squad:database`, `squad:cloud`, `squad:quality`, `squad:product`;
- estado auxiliar: `blocked`, `needs-refinement`, `needs-po`, `needs-security`, `breaking-change`;
- release: `release:v1.0.0`, `future:2027.1`.

Criar milestones para `Sprint 0` a `Sprint 6` e `Release v1.0.0`. Datas devem seguir o calendário aprovado no Project, evitando duplicar status em Markdown.

Criar formulários de Issue para Epic/Feature, User Story, Task técnica, Bug, Security Finding e ADR/Decision. Campos mínimos: objetivo, squad, repositório, Epic, SPEC, prioridade, dependências, critérios de aceite, Must Haves, evidências e riscos.

Template de PR:

- Issue vinculada (`Closes #...`);
- SPEC e baseline de governança;
- resumo e impacto;
- critérios atendidos;
- testes/evidências;
- impacto em segurança, banco, infraestrutura e compatibilidade;
- checklist de documentação e rollback.

## 8. Governança e aprovações

| Mudança | Aprovação mínima |
| --- | --- |
| Level 0 — governança central | Fellipe (PO) + Luciano (LPO) + technical lead quando aplicável |
| Level 1 — produto/requisito/SPEC | 1 PO; Luciano obrigatório em conflito, escopo global ou breaking change |
| Level 2 — arquitetura/contrato/segurança | owner técnico; PO também se afetar comportamento de produto |
| Level 3 — conteúdo da squad | líder ou referência técnica da squad |
| Level 4 — gerado | CI; edição humana direta proibida |

O GitHub não representa bem regras condicionais complexas apenas com branch protection. Para Levels 0/1, usar CODEOWNERS por caminho e um check `governance-approval` que valide as aprovações exigidas.

## 9. Actions, ambientes, secrets e segurança

Criar ambientes `development`, `staging` e `production`:

- `production` isolado, com aprovação manual de Cloud & DevOps e PO quando houver aceite de release;
- proteção por branch/tag; sem deploy de branches arbitrárias;
- secrets por environment e OIDC para AWS, evitando access keys permanentes;
- AWS roles separadas por repositório e ambiente, com privilégio mínimo;
- concurrency para impedir dois deploys simultâneos no mesmo ambiente;
- artefatos e evidências com retenção conforme política de governança.

Habilitar quando disponível no plano/repositório:

- Dependabot alerts e security updates;
- dependency review em PR;
- secret scanning e push protection nativos; em privados, dependem de Secret Protection adquirido;
- CodeQL/default setup; em privados, os recursos avançados dependem de Code Security adquirido;
- revisão de Actions de terceiros, fixadas por commit SHA;
- proteção contra forks executarem workflows privilegiados;
- política de token `GITHUB_TOKEN` read-only por padrão, elevando apenas por job.

Secrets/variables sugeridos: AWS role ARN por ambiente, região, nomes de buckets/ECR, endpoints não sensíveis como variables e credenciais somente em Secrets Manager/GitHub Environments. Nunca versionar valores reais.

## 10. Baseline de governança

Cada repositório técnico terá `.governance-baseline`:

```text
repository=https://github.com/UniSENAI-Sorocaba/plataforma-governance
tag=governance-v0.1.0
commit=<SHA_IMUTAVEL>
```

O workflow deve verificar que a tag resolve para o SHA declarado antes de executar `spec-compliance`. Atualizações de baseline são feitas por PR e devem listar mudanças incompatíveis.

## 11. Ordem de implantação

1. Confirmar os usernames ainda ausentes em `new_teams.md`.
2. Criar Teams e incluir membros conforme a fonte definitiva.
3. Criar/renomear repositórios e atribuir permissões por Team.
4. Criar Project, campos, views, milestones e labels.
5. Adicionar community files, templates e CODEOWNERS.
6. Aplicar rulesets e required checks separadamente em cada repositório; validar antes de ativar.
7. Configurar OIDC, environments, secrets e proteções de produção.
8. Publicar `governance-v0.1.0` e fixar o SHA em cada repositório.
9. Importar o backlog e vincular cada Issue ao Project.
10. Executar um PR de teste por repositório e registrar evidências.

## 12. Critérios de aceite da configuração

- nenhum integrante recebe acesso nominal fora de uma exceção documentada;
- `main` não aceita push direto nem merge com check obrigatório falhando;
- CODEOWNERS exige os aprovadores corretos por tipo de alteração;
- todos os repositórios aparecem no Project único;
- deploy de produção requer ambiente protegido;
- workflows AWS usam OIDC e privilégio mínimo;
- Dependabot e os scanners Actions estão ativos; secret scanning/CodeQL nativos entram quando suportados pela visibilidade e licença;
- tags de governança e release são protegidas e imutáveis;
- um PR de teste comprova o fluxo completo de Issue até Validation/Done.

## 13. Pendências que não bloqueiam a documentação

- usernames dos integrantes marcados como “não identificado com segurança”;
- confirmar GitHub Team ou decidir conscientemente operar com as limitações do GitHub Free em repositórios privados;
- definição nominal dos administradores da organização e release managers;
- datas finais das iterações no Project.

## 14. Autenticação segura para a configuração

Não registrar tokens neste repositório, em `.env`, documentação, comandos versionados ou mensagens. O GitHub chama essa credencial de Personal Access Token (PAT).

### Opção A — Fine-grained PAT temporário

Indicada para o bootstrap inicial. Criar com:

- resource owner limitado à organização;
- acesso apenas aos repositórios envolvidos;
- expiração de 1 a 7 dias;
- permissões mínimas necessárias;
- conta emissora com autoridade de organization owner/admin;
- revogação imediata após a configuração e auditoria.

Disponibilizar o valor somente no processo local como `GH_TOKEN`, sem imprimir ou persistir. Antes de qualquer escrita, executar inventário read-only e gerar plano/diff.

### Opção B — GitHub App privada da organização — recomendada

Indicada para operação repetida. Instalar somente nos repositórios do projeto, com permissões granulares. A automação usa installation tokens de curta duração e identidade auditável, sem depender permanentemente da conta pessoal do Luciano.

### Opção C — GitHub CLI com login interativo

Adequada para execução assistida em uma máquina confiável. O login por device flow evita colar token no chat e o credential manager do sistema armazena a sessão. O CLI ainda respeita as permissões da conta autenticada.

### Procedimento obrigatório

1. Não usar o PAT clássico irrestrito se um fine-grained PAT ou GitHub App atender.
2. Executar auditoria read-only de organização, plano, repositórios, Teams, membros, Projects, regras e recursos disponíveis.
3. Produzir comparação entre estado atual e configuração desejada.
4. Aplicar mudanças em fases, começando por Teams/repositórios e terminando em proteções.
5. Validar acesso, PR de teste e ausência de lockout administrativo.
6. Revogar o token temporário e registrar somente data, finalidade e identidade — nunca o valor.
