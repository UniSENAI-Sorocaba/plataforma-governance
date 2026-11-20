# 07 — Catálogo Operacional de Tasks

Este documento converte as fases do plano em tasks executáveis. Cada task deve virar uma Issue vinculada a uma SPEC, ser implementada em PR próprio e ser encerrada somente com as evidências indicadas.

## Como ler

- **Executor:** agente responsável pela implementação.
- **Revisor:** agente que verifica código, testes e aderência técnica.
- **Aceite:** agente que confirma o comportamento do produto ou do release.
- **Teste:** validação automatizada obrigatória.
- **Evidência:** artefato que deve ser anexado à Issue/PR.

Os nomes dos agentes abaixo correspondem aos arquivos em `.agents/`. A descrição completa e a atribuição final de cada task estão nos arquivos individuais do diretório [`tasks/`](./tasks/README.md); este catálogo é a visão consolidada.

## Ordem recomendada

`T01 → T02/T03/T04 → T05 → T06/T07 → T08 → T09/T10/T11 → T12/T13/T14 → T15/T16/T17/T18 → T19/T20/T21 → T22/T23/T24 → T25/T26/T27 → T28/T29/T30`.

Tasks do mesmo grupo podem executar em paralelo depois que suas dependências estiverem liberadas.

---

## Grupo 0 — Preparação e integração

### T01 — Consolidar baseline e plano de integração

**Referências:** `PG-004`, `PG-013`, `PG-014`, `PG-018`.

**Objetivo:** definir uma base de integração única e eliminar ambiguidade entre `main`, `origin/develop` e branches de feature.

**Implementação:**

1. inventariar branches locais e remotas dos seis repositórios;
2. identificar branches duplicadas ou superseded;
3. escolher PR canônico para cada funcionalidade;
4. registrar a ordem de merge por dependência;
5. criar matriz `Backlog ID → SPEC → Issue → PR → commit → evidência`;
6. declarar `origin/develop` como base de integração até a promoção para `main`.

**Testes/validações:**

- conferir que cada PR selecionado tem base atualizada;
- verificar ausência de conflito por merge simulado;
- validar que nenhuma task P0 ficou sem owner ou revisor;
- conferir que o status documentado corresponde ao commit integrado, não apenas à branch existente.

**Agentes:** Executor .agents/governance-agent.md; revisores LPO, .agents/architecture-agent.md e .agents/orchestrator.md; aceite PO.

**Done:** matriz publicada, ordem aprovada e nenhum item P0 sem caminho de integração.

### T02 — Congelar contratos de API e erros

**Referências:** `BE-003`, `QA-010`.

**Implementação:**

- consolidar OpenAPI 3.1;
- definir envelope de erro, códigos, correlation ID e paginação;
- versionar schemas compartilhados;
- publicar fixtures de sucesso, validação, autenticação e autorização;
- configurar lint e breaking-change check no CI.

**Testes/validações:**

- lint OpenAPI;
- geração de mock;
- contract test contra fixtures;
- teste negativo para breaking change não aprovado;
- validação de payloads de erro em 400, 401, 403, 404 e 409.

**Agentes:** Executor .agents/architecture-agent.md + .agents/backend-agent.md; revisor .agents/quality-security-agent.md; aceite .agents/frontend-agent.md e PO.

**Done:** contrato aprovado e consumido por backend, frontend e quality.

### T03 — Tornar migrations e seeds reproduzíveis

**Referências:** `DB-001`, `DB-002`, `DB-003`, `DB-016`.

**Implementação:**

- garantir sequência incremental de migrations;
- separar schema, seed e fixture de teste;
- criar comandos de banco limpo, upgrade e validação;
- registrar versões de PostgreSQL e ferramenta de migration;
- impedir dados pessoais nos seeds.

**Testes/validações:**

- aplicar banco vazio;
- aplicar upgrade a partir da versão anterior;
- executar seed duas vezes e comparar resultado;
- executar detector de drift;
- validar constraints, índices e schemas esperados.

**Agentes:** Executor .agents/database-agent.md; revisor .agents/backend-agent.md; .agents/quality-security-agent.md valida CI; .agents/infrastructure-agent.md revisa execução no pipeline.

**Done:** banco limpo, upgrade e drift passam em CI sem intervenção manual.

### T04 — Preparar pipeline mínimo de CI

**Referências:** `INF-003`, `QA-003`, `QA-007`.

**Implementação:**

- criar jobs separados para backend, frontend, database, quality e infrastructure;
- publicar logs e relatórios como artefatos;
- bloquear merge quando build, teste ou contrato falhar;
- configurar cache sem mascarar falhas;
- definir comandos oficiais reproduzíveis localmente.

**Testes/validações:**

- executar pipeline em PR válido;
- introduzir falha sintética e confirmar bloqueio;
- verificar artefatos de cobertura, testes e scans;
- confirmar que secrets não aparecem em logs.

**Agentes:** Executor .agents/infrastructure-agent.md; revisor .agents/quality-security-agent.md revisa secrets; aceite .agents/governance-agent.md.

**Done:** pipeline verde em PR de integração e vermelho em falha controlada.

---

## Grupo 1 — Fundação de aplicação e IAM

### T05 — Padronizar backend, observabilidade base e healthcheck

**Referências:** `BE-001`, `BE-002`.

**Implementação:**

- consolidar limites de módulos;
- implementar error handler comum;
- adicionar correlation ID em request/response/log;
- expor healthcheck sem informações internas;
- configurar logs estruturados e relógio injetável para testes.

**Testes/validações:**

- teste de contexto Spring;
- teste de healthcheck;
- teste de erro de validação e recurso inexistente;
- teste de propagação de correlation ID;
- inspeção para garantir que tokens e senhas não aparecem em logs.

**Agentes:** Executor .agents/backend-agent.md; revisor .agents/architecture-agent.md; .agents/quality-security-agent.md valida testes; .agents/quality-security-agent.md revisa exposição.

**Done:** `mvn verify` passa e todos os endpoints seguem o padrão de erro/correlação.

### T06 — Implementar identidade, vínculo institucional e credenciais

**Referências:** `DB-004`, `BE-004`, `BE-005`.

**Implementação:**

- criar entidades de usuário, vínculo e credencial;
- aplicar unicidade de identificador institucional;
- usar Argon2id com parâmetros documentados;
- separar identificação de autenticação;
- nunca persistir senha em claro.

**Testes/validações:**

- cadastro/lookup de usuário;
- senha correta/incorreta;
- duplicidade institucional;
- hash diferente para mesma senha;
- teste de segurança dos logs;
- análise de configuração para garantir Argon2id.

**Agentes:** Executor .agents/database-agent.md + .agents/backend-agent.md; revisor .agents/quality-security-agent.md executa testes de API; aceite PO.

**Done:** identidade e credenciais funcionam contra banco real de teste e todas as regras de segurança passam.

### T07 — Implementar login JWT RS256

**Referências:** `BE-004`, `FE-004`, `QA-008`.

**Implementação:**

- configurar par de chaves RSA por secret manager;
- emitir access token com issuer, audience, subject, roles e expiração;
- validar assinatura, issuer, audience e clock skew;
- criar endpoint de login e erros uniformes;
- integrar formulário frontend com estados loading/sucesso/erro.

**Testes/validações:**

- login válido;
- senha inválida;
- token expirado;
- token assinado com chave incorreta;
- claims ausentes ou inválidas;
- teste E2E de redirecionamento por perfil.

**Agentes:** Executor .agents/backend-agent.md + .agents/frontend-agent.md; revisor .agents/quality-security-agent.md executa API/E2E; aceite PO.

**Done:** login institucional funciona ponta a ponta e nenhum segredo é embutido no frontend.

### T08 — Implementar sessão, refresh rotativo, logout e recuperação

**Referências:** `DB-005`, `BE-006`, `AUTH-10-BE`, `FE-005`, `QA-008`.

**Implementação:**

- armazenar somente hash de refresh token;
- rotacionar token a cada uso;
- invalidar família após reuse;
- revogar sessão no logout;
- criar token de recuperação de uso único e expiração curta;
- integrar recuperação sem revelar existência de usuário.

**Testes/validações:**

- refresh válido e rotação;
- reuse detectado;
- logout bloqueia refresh;
- expiração e revogação;
- token de recuperação usado uma vez;
- resposta de recuperação uniforme;
- E2E de expiração e encerramento da sessão.

**Agentes:** Executor .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md; revisor .agents/quality-security-agent.md; aceite PO.

**Done:** suite de sessão passa sem token em log, cookie inseguro ou sessão órfã.

### T09 — Implementar RBAC e autorização por rota

**Referências:** `DB-006`, `BE-010`, `QA-009`.

**Implementação:**

- definir catálogo de roles/permissões/scopes;
- aplicar deny-by-default;
- proteger rotas por política server-side;
- separar autenticação de autorização;
- registrar decisão allow/deny sem dados sensíveis.

**Testes/validações:**

- matriz completa de 401/403;
- teste por perfil e rota;
- teste de acesso horizontal a outro usuário/projeto;
- teste de escopo institucional;
- revisão manual das rotas sem política explícita.

**Agentes:** Executor .agents/backend-agent.md; revisor .agents/quality-security-agent.md + .agents/architecture-agent.md; .agents/quality-security-agent.md; aceite PO.

**Done:** 100% das rotas protegidas aparecem na matriz e têm teste allow/deny.

### T10 — Implementar logs técnicos sanitizados

**Referências:** `BE-016`, `DB-007`, `QA-022`.

**Implementação:**

- padronizar correlation ID, resultado e contexto mínimo operacional;
- separar logs técnicos de qualquer histórico de negócio;
- aplicar retenção e proteção contra dados sensíveis;
- não persistir eventos de auditoria de negócio nem disponibilizar consulta funcional de ações.

**Testes/validações:**

- login, logout, reset, autorização, proposta, avaliação e certificado geram evento;
- tentativa de alteração/deleção é bloqueada;
- retenção é validada;
- consulta não expõe segredo;
- teste de correlação entre request e evento.

**Agentes:** Executor .agents/backend-agent.md + .agents/database-agent.md; revisor .agents/quality-security-agent.md; aceite .agents/governance-agent.md.

**Done:** 100% das ações P0 listadas possuem evento verificável.

---

## Grupo 2 — Projetos Integradores

### T11 — Criar modelo de propostas e participação

**Referências:** `DB-008`, `BE-007`, `FE-006`, `QA-011`.

**Implementação:**

- criar projeto/proposta com responsáveis e publicação rascunho/publicado;
- definir somente transições formalmente aprovadas;
- permitir solicitação de participação do aluno e decisão docente, conforme SPEC;
- validar campos no domínio e no contrato;
- impedir edição fora da transição autorizada.

**Testes/validações:**

- criação/consulta/edição permitidas por papel;
- campos obrigatórios;
- todas as transições aprovadas válidas e inválidas;
- concorrência dos limites de participação;
- teste de persistência e recuperação de rascunho.

**Agentes:** Executor .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md; revisor .agents/architecture-agent.md; .agents/quality-security-agent.md; aceite PO.

**Done:** proposta percorre o ciclo sem alteração manual de banco.

### T12 — Implementar solicitações e gestão de equipe

**Referências:** `BE-008`, `FE-007`, `FE-009`, `QA-011`.

**Implementação:**

- criar solicitação de participação idempotente;
- aprovar, negar e remover com autorização;
- preservar motivo de remoção;
- aplicar limite de participação;
- bloquear solicitação duplicada e corrida de aprovação.

**Testes/validações:**

- cenários de aprovação/negação/remoção;
- solicitação duplicada;
- duas aprovações simultâneas;
- usuário sem permissão;
- participante em projeto incompatível;
- E2E da gestão da equipe.

**Agentes:** Executor .agents/backend-agent.md + .agents/frontend-agent.md; .agents/database-agent.md revisa constraints; .agents/quality-security-agent.md; aceite PO.

**Done:** nenhuma inconsistência de equipe nos testes concorrentes.

### T13 — Implementar entregáveis e upload seguro

**Referências:** `BE-012`, `BE-013`, `DB-011`, `FE-011`, `QA-014`.

**Implementação:**

- emitir URL temporária;
- validar MIME, extensão e tamanho;
- persistir hash, owner, versão e lifecycle;
- impedir acesso fora do projeto/papel;
- suportar progresso e cancelamento no frontend.

**Testes/validações:**

- tipo/tamanho inválido;
- URL expirada;
- arquivo adulterado;
- acesso de outro usuário;
- upload cancelado;
- hash e metadados conferidos no banco.

**Agentes:** Executor .agents/backend-agent.md + .agents/frontend-agent.md + .agents/database-agent.md; revisor .agents/quality-security-agent.md + .agents/infrastructure-agent.md; .agents/quality-security-agent.md.

**Done:** upload autorizado funciona e todos os testes de abuso falham de forma segura.

---

## Grupo 3 — Extensão, avaliação e certificados

### T14 — Implementar editais e inscrições

**Referências:** `BE-009`, `DB-012`, `FE-008`, `QA-012`.

**Implementação:**

- modelar janela, status e elegibilidade;
- validar data no servidor usando relógio injetável;
- garantir unicidade por aluno/edital;
- exibir janela e resultado na interface.

**Testes/validações:**

- antes, durante e depois da janela;
- inscrição duplicada;
- inelegibilidade;
- timezone e limite inclusivo/exclusivo;
- E2E do resultado da inscrição.

**Agentes:** Executor .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md; .agents/quality-security-agent.md; revisor PO.

**Done:** nenhuma inscrição fora da regra é persistida.

### T15 — Implementar atividades e horas de extensão

**Referências:** `BE-014`, `DB-013`, `FE-012`, `QA-015`.

**Implementação:**

- criar atividade submetida pelo aluno;
- permitir decisão docente com motivo;
- totalizar somente horas aprovadas;
- impedir duplicidade e valores inválidos;
- manter o estado atual e o motivo, sem histórico de auditoria de negócio.

**Testes/validações:**

- submissão, aprovação e rejeição;
- horas zero, negativas e acima do limite;
- reenvio e duplicidade;
- cálculo acumulado;
- ausência de persistência de auditoria de negócio e de histórico de valores anteriores.

**Agentes:** Executor .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md; .agents/quality-security-agent.md; aceite PO.

**Done:** total de horas é reproduzível a partir das atividades aprovadas.

### T16 — Implementar avaliações e vínculos

**Referências:** `BE-011`, `DB-009`, `FE-010`, `QA-013`.

**Implementação:**

- modelar avaliação, avaliador e vínculo;
- validar autorização e vínculo inválido;
- manter datas conforme o contrato aprovado;
- bloquear alteração concorrente inconsistente.

**Testes/validações:**

- avaliador sem vínculo;
- avaliador duplicado;
- atribuição inválida ou não autorizada.

**Agentes:** Executor .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md; .agents/quality-security-agent.md; revisor PO.

**Done:** nenhum vínculo ou autorização inválidos passam nos testes; não existe agenda de banca.

### T17 — Implementar rubricas e cálculo de notas

**Referências:** `BE-015`, `DB-010`, `FE-013`, `QA-016`.

**Implementação:**

- criar rubrica versionada com pesos;
- validar soma e limites;
- persistir respostas e versão aplicada;
- calcular nota com precisão e arredondamento documentados;
- consolidar somente após critérios de completude.

**Testes/validações:**

- fixture de cálculo conhecido;
- pesos inválidos;
- nota fora do intervalo;
- precisão/rounding;
- repetição idempotente;
- permissão de edição e fechamento.

**Agentes:** Executor .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md; revisor .agents/architecture-agent.md; .agents/quality-security-agent.md; aceite PO.

**Done:** 100% dos fixtures retornam o resultado esperado e reproduzível.

### T18 — Emitir e validar certificado

**Referências:** `BE-017`, `FE-014`, `QA-017`.

**Implementação:**

- gerar identificador e payload canônico;
- calcular SHA-256;
- criar QR apontando para validação pública;
- controlar emissão e revogação;
- ocultar dados não necessários no endpoint público.

**Testes/validações:**

- certificado legítimo;
- hash alterado;
- QR inválido;
- revogação;
- emissão por papel não autorizado;
- duplicidade e idempotência.

**Agentes:** Executor .agents/backend-agent.md + .agents/frontend-agent.md; .agents/quality-security-agent.md revisa exposição; .agents/quality-security-agent.md; aceite PO.

**Done:** certificado válido é reconhecido e qualquer adulteração é detectada.

---

## Grupo 4 — Portal público

### T19 — Implementar catálogo, filtros e paginação

**Referências:** `BE-018`, `DB-014`, `FE-015`, `QA-018`.

**Implementação:**

- criar query pública com projeção de campos permitidos;
- adicionar filtros por curso, semestre e ODS;
- paginação estável;
- índice e `EXPLAIN` para consulta principal;
- estados vazio, erro e carregamento.

**Testes/validações:**

- contrato dos filtros;
- paginação sem duplicidade;
- projeto privado nunca aparece;
- consulta vazia;
- benchmark da query;
- `EXPLAIN` sem full scan inesperado no dataset de referência.

**Agentes:** Executor .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md; .agents/quality-security-agent.md; revisor .agents/quality-security-agent.md.

**Done:** catálogo público atende contrato e não expõe dados privados.

### T20 — Implementar workflow de impacto publicado

**Referências:** `BE-019`, `DB-015`, `FE-016`.

**Implementação:**

- criar estados de impacto;
- permitir revisão/aprovação/retirada;
- versionar conteúdo e origem;
- renderizar apenas versão aprovada.

**Testes/validações:**

- cada transição válida e inválida;
- conteúdo em rascunho não aparece;
- retirada remove publicação;
- versão aprovada permanece estável;
- evidência de aprovação sem criar auditoria persistente de negócio.

**Agentes:** Executor .agents/backend-agent.md + .agents/database-agent.md + .agents/frontend-agent.md; .agents/quality-security-agent.md; aceite PO.

**Done:** página pública só exibe impacto aprovado e rastreável.

### T21 — Implementar SEO e acessibilidade do portal

**Referências:** `FE-017`, `FE-018`, `FE-019`, `QA-020`, `QA-021`.

**Implementação:**

- metadata, sitemap, robots e canonical;
- navegação por teclado e foco;
- labels, nomes acessíveis e contraste;
- coleta de Web Vitals;
- otimização SSR e cache.

**Testes/validações:**

- axe/Lighthouse;
- navegação manual por teclado;
- validação de sitemap/robots;
- teste de HTML SSR;
- Lighthouse >= 90 em performance, acessibilidade e SEO.

**Agentes:** Executor .agents/frontend-agent.md; revisor .agents/quality-security-agent.md; .agents/infrastructure-agent.md revisa cache/SSR.

**Done:** critérios de acessibilidade e SEO sem bloqueador e metas de Lighthouse atingidas.

---

## Grupo 5 — V1, segurança e operação

### T22 — Criar suíte E2E das jornadas P0

**Referências:** `QA-019`, `QA-023`, `QA-028`.

**Implementação:**

- criar dados sintéticos isolados;
- cobrir login, proposta, equipe, entregável, horas, nota, certificado e portal;
- executar contra staging efêmero;
- publicar trace, screenshot e vídeo somente em falha.

**Testes/validações:**

- execução limpa em CI;
- repetição sem dependência de ordem;
- cleanup de dados;
- relatório de falhas com owner;
- 100% das jornadas P0 verdes.

**Agentes:** Executor .agents/quality-security-agent.md; revisor .agents/frontend-agent.md + .agents/backend-agent.md; .agents/infrastructure-agent.md mantém ambiente; aceite PO.

**Done:** todas as jornadas críticas passam em staging sem intervenção manual.

### T23 — Configurar SAST, SCA, secrets, container e IaC scans

**Referências:** `QA-005`, `QA-006`, `QA-025`, `INF-003`.

**Implementação:**

- adicionar ferramentas aos workflows;
- configurar baseline sem silenciar finding real;
- bloquear High/Critical;
- criar processo de exceção com owner e expiração.

**Testes/validações:**

- segredo sintético detectado;
- dependência vulnerável de fixture bloqueada;
- imagem vulnerável bloqueada;
- Terraform inseguro detectado;
- relatório publicado como artefato.

**Agentes:** Executor .agents/quality-security-agent.md + .agents/infrastructure-agent.md; revisor .agents/quality-security-agent.md; aceite .agents/governance-agent.md.

**Done:** todos os scans executam no PR e findings não podem ser ignorados sem registro.

### T24 — Executar teste de carga e corrigir gargalos

**Referências:** `QA-024`, `DB-017`, `DB-019`, `INF-017`.

**Implementação:**

- definir cenário de login, catálogo e endpoints de leitura;
- preparar dataset sintético representativo;
- ajustar pool, índices, cache e autoscaling;
- registrar baseline e resultado após correção.

**Testes/validações:**

- 200 RPS sustentados;
- p95 <= 500 ms;
- taxa de erro < 1%;
- sem exaustão de pool;
- relatório de slow queries.

**Agentes:** Executor .agents/quality-security-agent.md + .agents/infrastructure-agent.md + .agents/database-agent.md; revisor .agents/backend-agent.md; aceite .agents/orchestrator.md.

**Done:** metas de performance comprovadas em ambiente equivalente ao staging.

### T25 — Implantar observabilidade e alertas

**Referências:** `INF-012`, `INF-013`.

**Implementação:**

- padronizar logs estruturados;
- correlacionar request e operação técnica, sem evento de auditoria de negócio;
- criar métricas de latência, erros, disponibilidade e conexões;
- configurar alertas e dashboard mínimo.

**Testes/validações:**

- provocar erro 5xx e localizar no dashboard;
- rastrear request por correlation ID;
- disparar alerta de p95;
- verificar ausência de dados sensíveis nos logs.

**Agentes:** Executor .agents/infrastructure-agent.md; .agents/backend-agent.md e .agents/database-agent.md integram instrumentação; .agents/quality-security-agent.md revisa logs; .agents/quality-security-agent.md valida alerta.

**Done:** incidente sintético é detectável e rastreável ponta a ponta.

### T26 — Implementar backup, restore e retenção

**Referências:** `INF-015`, `INF-016`, `DB-018`.

**Implementação:**

- configurar backup diário e retenção;
- proteger armazenamento;
- restaurar em instância temporária;
- validar schema, dados sintéticos e integridade;
- medir RPO/RTO.

**Testes/validações:**

- execução de backup;
- restore completo;
- consulta de dados restaurados;
- simulação de perda de instância;
- conferência de retenção e acesso mínimo.

**Agentes:** Executor .agents/infrastructure-agent.md + .agents/database-agent.md; revisor .agents/quality-security-agent.md acompanha; aceite .agents/orchestrator.md.

**Done:** restore documentado, medido e repetível.

### T27 — Ensaiar deploy, smoke e rollback

**Referências:** `INF-018`, `INF-019`, `INF-020`, `INF-021`.

**Implementação:**

- publicar artefato imutável;
- executar deploy em staging;
- definir gatilhos de rollback;
- recuperar versão anterior;
- executar smoke pós-deploy;
- atualizar runbooks.

**Testes/validações:**

- deploy limpo;
- falha induzida com rollback;
- smoke de healthcheck, login, proposta e catálogo;
- conferência de migrations compatíveis;
- runbook executado por pessoa diferente do autor.

**Agentes:** Executor .agents/infrastructure-agent.md + .agents/orchestrator.md; .agents/quality-security-agent.md executa smoke; .agents/backend-agent.md/.agents/frontend-agent.md/.agents/database-agent.md revisam seus serviços.

**Done:** rollback recupera versão anterior e smoke fica registrado.

### T28 — Fechar pacote de homologação e go/no-go

**Referências:** `PG-017`, `PG-018`, `QA-028`, `QA-029`, `QA-030`.

**Implementação:**

- consolidar matriz de aceite;
- relacionar cada Must Have a SPEC, Issue, PR e evidência;
- registrar riscos aceitos e pendências;
- preparar pareceres de QA, Cloud e PO;
- registrar decisão go/no-go.

**Testes/validações:**

- checklist de release 100% preenchido;
- nenhum P0 sem decisão;
- pacote navegável;
- smoke e rollback anexados;
- revisão independente do pacote.

**Agentes:** Executor .agents/orchestrator.md + .agents/governance-agent.md; revisores .agents/quality-security-agent.md, .agents/infrastructure-agent.md e .agents/architecture-agent.md; aceite PO/LPO.

**Done:** go/no-go formalmente aprovado ou no-go com bloqueios, owners e próximos passos.

---

## Critério comum de encerramento

Toda task deste catálogo só pode ser fechada quando:

1. código foi integrado na branch de integração;
2. testes obrigatórios passaram;
3. validações manuais aplicáveis foram executadas;
4. evidência está anexada à Issue/PR;
5. revisor registrou aprovação;
6. dependências e riscos foram atualizados;
7. comportamento está coberto pela matriz de aceite.
