# 00 — Plano Mestre e Roadmap de Fases

## 1. Resultado esperado

Ao final do plano, um aluno, docente e administrador devem conseguir usar a plataforma em um ambiente de staging para:

1. autenticar com segurança e receber autorização por perfil;
2. criar, publicar como rascunho ou publicado e acompanhar uma proposta;
3. solicitar e decidir participação de alunos, sem convites individuais;
4. entregar arquivos e registrar horas de extensão;
5. avaliar entregas com rubricas e gerar nota determinística;
6. emitir e validar um certificado com hash;
7. publicar e consultar projetos aprovados no portal público;
8. operar o sistema com logs, métricas, rollback e evidências de qualidade.

## 2. Ordem de execução

| Fase | Nome | Resultado | Gate de saída |
|---|---|---|---|
| F0 | Preparação e integração | Branch, contratos, ambiente e backlog prontos | Plano de integração aprovado |
| F1 | Fundação técnica e dados | Aplicação, banco, CI e observabilidade mínimas | Builds e migrations reproduzíveis |
| F2 | IAM/SSO | Login, sessão, RBAC e logs técnicos sanitizados funcionais | Jornada autenticada aprovada |
| F3 | Projetos Integradores | Propostas, equipes e entregáveis funcionais | Jornada PI ponta a ponta aprovada |
| F4 | Extensão, avaliação e certificados | Horas, rubricas, notas e certificado funcionais | Jornada acadêmica aprovada |
| F5 | Portal público | Catálogo, impacto e validação pública funcionais | Jornada pública e SEO aprovados |
| F6 | Hardening e V1 | Segurança, performance, operação e release | Go/no-go aprovado |

As fases são sequenciais por dependência, mas podem ter execução paralela dentro de cada fase. O trabalho em branches não integradas deve ser tratado como insumo, não como entrega concluída.

## 3. Subfases e etapas

### F0 — Preparação e integração

#### F0.1 Inventário e baseline

- confirmar `main`, `origin/develop` e branches candidatas em cada repositório;
- identificar duplicidades de branches e escolher o PR canônico;
- mapear cada item do backlog para SPEC, código, teste e evidência;
- registrar bloqueios de ambiente, secrets, banco e deploy.

**Aceite:** 100% dos itens P0 do MVP possuem owner, revisor, dependências e destino de integração; nenhum PR é aceito somente por possuir documentação.

#### F0.2 Contratos e integração

- congelar contratos OpenAPI/JSON Schema da primeira jornada;
- definir versionamento de API e payloads de erro;
- alinhar migrations, seeds e dados sintéticos;
- definir ambientes local, CI e staging.

**Aceite:** backend, frontend e quality conseguem executar contra o mesmo contrato e o CI falha em breaking change não aprovado.

### F1 — Fundação técnica e dados

#### F1.1 Backend e frontend

- consolidar `BE-001/002/003` e `FE-001/003`;
- padronizar erros, correlation ID, logs e healthcheck;
- garantir lint, typecheck, testes e build no CI.

#### F1.2 Banco

- consolidar `DB-001/002/003/016`;
- executar migrations limpas e upgrade incremental;
- manter seeds sintéticos, determinísticos e sem dados pessoais.

#### F1.3 Infraestrutura

- validar Terraform development e production;
- definir registry, secrets, rede, banco, runtime e storage;
- preparar deploy efêmero no CI.

**Aceite F1:** build reproduzível em CI; migrations limpas e de upgrade passam; healthcheck responde; nenhum segredo aparece em logs; Terraform `fmt` e `validate` passam em todos os roots e módulos.

### F2 — IAM/SSO

#### F2.1 Identidade e sessão

- implementar identidade, vínculo institucional e credenciais;
- login institucional com JWT RS256;
- Argon2id para senha;
- refresh token rotativo, expiração, revogação e detecção de reuse;
- logout e recuperação de senha.

#### F2.2 Autorização

- RBAC server-side para aluno, docente, coordenação, CPA e administrador;
- negação por padrão;
- catálogo de permissões e escopos;
- auditoria de autenticação e decisões de autorização.

#### F2.3 Experiência autenticada

- telas de login, loading e erro;
- renovação de sessão uma única vez;
- redirecionamento por perfil;
- tratamento seguro de expiração.

**Aceite F2:** 100% das rotas protegidas têm allow/deny testado; credencial inválida não autentica; refresh reutilizado é rejeitado; tokens não são gravados em logs; jornada de login passa no E2E.

### F3 — Projetos Integradores

#### F3.1 Propostas

- cadastro com rascunho/publicação;
- validação de campos e papéis;
- somente transições formalmente aprovadas;
- sem histórico de auditoria de negócio.

#### F3.2 Equipes

- solicitação do aluno, aprovação/negação docente e remoção justificada;
- limite de participação conforme regra do produto;
- prevenção de duplicidade e corrida concorrente;
- visão do aluno, docente e coordenação.

#### F3.3 Entregáveis

- upload com tipo, tamanho, autorização e expiração;
- hash e metadados persistidos;
- download somente por owner ou papel autorizado.

**Aceite F3:** uma proposta percorre o ciclo completo sem intervenção manual no banco; testes cobrem transições e concorrência; arquivos inválidos são rejeitados; nenhuma informação privada aparece no portal público.

### F4 — Extensão, avaliação e certificação

#### F4.1 Atividades e horas

- edital/janela e inscrição quando aplicável;
- submissão de atividade;
- decisão docente com motivo;
- totalização reproduzível de horas, sem histórico de valores anteriores.

#### F4.2 Avaliações, rubricas e notas

- avaliadores válidos e vínculos autorizados;
- rubrica versionada;
- cálculo determinístico, precisão definida e limites validados;
- nota consolidada somente por papel autorizado.

#### F4.3 Certificados

- emissão autorizada;
- hash SHA-256 e QR Code;
- validação pública;
- revogação e detecção de adulteração.

**Aceite F4:** a mesma entrada produz sempre a mesma nota; permissões e
vínculos inválidos são bloqueados; certificado alterado falha na validação;
emissão sem permissão é bloqueada. Não exigir auditoria persistente de
negócio ou histórico de valores anteriores.

### F5 — Portal público

#### F5.1 Catálogo

- catálogo SSR;
- paginação;
- filtros por curso, semestre e ODS;
- estados vazio, erro e conteúdo não publicado.

#### F5.2 Impacto e prestação social

- conteúdo em rascunho, submetido, aprovado e retirado;
- somente conteúdo aprovado renderiza publicamente;
- origem e versão do impacto preservadas.

#### F5.3 SEO e acessibilidade

- metadata, sitemap, robots e canonical URL;
- teclado, foco, labels, contraste e nomes acessíveis;
- URLs de certificado públicas e estáveis.

**Aceite F5:** catálogo público não exige login; filtros retornam resultados consistentes; conteúdo privado nunca é exibido; Lighthouse atinge pelo menos 90 em performance, acessibilidade e SEO na página principal de staging.

### F6 — Hardening e V1

#### F6.1 Segurança e qualidade

- SAST, SCA, secret scanning, container scanning e IaC scanning;
- testes API, contrato, E2E, performance e DAST;
- correção ou aceite formal de todos os findings High/Critical.

#### F6.2 Operação

- logs estruturados, métricas e correlação;
- alarmes de erro, p95, disponibilidade e banco;
- backup, restore, retenção e runbooks;
- rollback para a versão anterior recuperável.

#### F6.3 Homologação

- regressão consolidada;
- smoke pós-deploy;
- parecer de .agents/quality-security-agent.md, .agents/infrastructure-agent.md e PO;
- go/no-go registrado.

**Aceite F6:** nenhum P0 falha; cobertura global mínima de 75%; k6 comprova 200 RPS com p95 <= 500 ms; smoke e rollback foram executados ou a limitação foi formalmente aprovada.

## 4. Dependências críticas

| Dependência | Bloqueia |
|---|---|
| DB-004 a DB-006 | Login, sessão e RBAC |
| BE-004 a BE-006 | .agents/frontend-agent.md autenticado e .agents/quality-security-agent.md de sessão |
| BE-007/008 + DB-008 | Propostas e equipes |
| BE-011/014/015 + DB-009/010/013 | Avaliação, horas e notas |
| BE-017 + DB-011 | Certificados |
| BE-018/019 + DB-014/015 | Portal público |
| INF-009/011 | Staging, SSR e E2E |
| QA-019/024/025/026 | Go/no-go técnico |
| PG-017/018 | Aprovação do release |

## 5. Ritmo de execução

- daily técnico por squad, limitado a bloqueios e decisões;
- revisão de integração duas vezes por semana;
- demonstração funcional ao final de cada fase;
- revisão de risco semanal;
- fechamento de fase somente após gate de aceite;
- nenhuma nova feature P1/P2 entra quando houver P0 vermelho.
