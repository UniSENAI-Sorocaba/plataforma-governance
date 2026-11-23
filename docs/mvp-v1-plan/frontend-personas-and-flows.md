# Frontend por perfil: estado atual, modelo ideal e fluxos de uso

**Projeto:** Plataforma Digital UniSENAI Sorocaba  
**Data da análise:** 21/11/2026  
**Escopo:** frontend e sua integração com os perfis definidos no módulo de autenticação  
**Status:** diagnóstico para orientar a Fase 6 — Hardening e V1 e o backlog posterior de evolução por perfil

## 1. Conclusão executiva

Sim. Alunos, docentes, coordenadores e administradores possuem objetivos, dados visíveis e ações diferentes. Portanto, o frontend ideal deve oferecer:

- uma identidade visual e uma infraestrutura de navegação compartilhadas;
- uma home, menu e conjunto de tarefas específicos para cada perfil;
- rotas protegidas por perfil no frontend, sempre respaldadas pela autorização do backend;
- mensagens de erro e estados vazios compatíveis com o contexto de cada usuário;
- isolamento explícito dos dados: um aluno consulta seus próprios registros, enquanto perfis institucionais consultam apenas os recursos sob sua responsabilidade.

O frontend atual já possui os quatro perfis no tipo `UserRole` e documenta destinos distintos de redirecionamento. Entretanto, a implementação disponível ainda está centrada no fluxo de aluno: a home autenticada e o shell exibem o mesmo menu para todos, e as rotas `/docente`, `/coordenacao` e `/admin` previstas na documentação não foram identificadas em `src/app`.

Há componentes que podem sustentar a evolução — gestão de projetos, revisão de atividades, atribuição de avaliações, oportunidades de extensão, certificados e impactos —, mas eles ainda não formam portais completos e distintos por perfil.

## 2. Fontes consultadas

Foram consultados:

- `plataforma-frontend/src/features/auth/README.md`;
- `plataforma-frontend/src/features/auth/auth-types.ts` e `auth-service.ts`;
- rotas em `plataforma-frontend/src/app`;
- `authenticated-home.tsx` e `authenticated-shell.tsx`;
- `platform-header.tsx`;
- `features/academic-pi/project-management.tsx`;
- `features/academic-pi/evaluation-assignment-dashboard.tsx`;
- `features/extension/activities-dashboard.tsx`;
- páginas de projetos, solicitações, extensão, certificados e impactos;
- documentação de execução das fases F1–F6 em `plataforma-governance/docs/mvp-v1-plan/`.

Quando uma capacidade não foi encontrada nos arquivos analisados, ela é marcada como **não identificada**, e não como inexistente no backend.

## 3. Perfis identificados e responsabilidades

| Perfil | Objetivo principal | Dados que deve consultar | Ações típicas |
|---|---|---|---|
| `ALUNO` | Encontrar oportunidades, solicitar participação e acompanhar sua trajetória | Seus dados, solicitações, inscrições, atividades, horas, entregáveis e certificados | Solicitar participação, desistir quando permitido, enviar atividade/entregável e consultar status |
| `DOCENTE` | Acompanhar projetos sob sua responsabilidade e revisar entregas acadêmicas | Projetos atribuídos, participantes desses projetos, atividades e avaliações relacionadas | Revisar solicitações, aprovar/recusar atividades e acompanhar avaliações autorizadas |
| `COORDENADOR` | Governar projetos, editais, períodos e decisões acadêmicas | Conjunto institucional sob sua unidade/período, com visão de gestão | Criar/publicar projetos ou editais, atribuir responsáveis/avaliadores, acompanhar indicadores e fluxos de aprovação |
| `ADMIN` | Administrar a plataforma e seus controles | Usuários, papéis, configurações, auditoria e saúde operacional | Gerenciar acessos, configurações e auditoria; não deve substituir decisões acadêmicas sem permissão explícita |
| Público/anônimo | Consultar informações institucionais publicadas | Catálogo público, impactos aprovados e validação de certificados | Navegar, consultar e validar informações públicas; não acessa dados privados |

## 4. Estado atual do frontend

### 4.1 Autenticação e redirecionamento

O tipo de usuário reconhece `ALUNO`, `DOCENTE`, `COORDENADOR` e `ADMIN`. O README do módulo de autenticação define os seguintes destinos:

| Perfil | Destino documentado | Situação encontrada |
|---|---|---|
| Aluno | `/` | Rota implementada e orientada ao portal do aluno |
| Docente | `/docente` | Rota não identificada em `src/app` |
| Coordenador | `/coordenacao` | Rota não identificada em `src/app` |
| Administrador | `/admin` | Rota não identificada em `src/app` |

Isso cria um risco funcional: o login pode reconhecer o perfil corretamente, mas encaminhar o usuário para uma rota sem tela correspondente.

### 4.2 Home e navegação autenticadas

`authenticated-home.tsx` exibe um cabeçalho de perfil, mas o conteúdo e os indicadores são de aluno. O menu é fixo e aponta para visão geral, projetos, solicitações e extensão, sem ramificação por papel.

`authenticated-shell.tsx` reutiliza a mesma estrutura de navegação para páginas autenticadas. A identificação do papel muda o rótulo visual, mas não muda suficientemente as opções, os objetivos ou as ações disponíveis.

`platform-header.tsx` é utilizado por páginas de gestão e atividades. Como ele não é o mesmo shell das telas principais, há uma segunda variação de navegação. Essa divisão deve ser consolidada para evitar que o usuário perca contexto ou encontre ações incompatíveis com seu perfil.

### 4.3 Capacidades de aluno já visíveis

Foram identificadas telas para:

- catálogo de projetos;
- minhas solicitações de participação;
- oportunidades de extensão;
- envio e acompanhamento de atividades e horas;
- envio de entregáveis em solicitações aprovadas;
- consulta pública de impactos;
- validação pública de certificados.

Essas capacidades cobrem boa parte do fluxo do aluno. Ainda assim, os dados exibidos precisam sempre ser derivados dos contratos reais e da sessão atual, e não de textos ou indicadores estáticos.

### 4.4 Capacidades institucionais já disponíveis como componentes

Existem componentes para:

- gestão de projetos e revisão de solicitações (`ProjectManagement`);
- revisão de atividades e decisão de horas (`ActivitiesDashboard`);
- atribuição de avaliações (`EvaluationAssignmentDashboard`).

Esses componentes são evidência de capacidades de domínio já iniciadas, mas não constituem, sozinhos, uma experiência completa de docente ou coordenador. Não foi identificada uma tela administrativa geral no frontend.

### 4.5 Rotas públicas

`/certificados` possui uma validação pública de certificado e `/impactos` lista impactos aprovados. Essas telas não devem exigir sessão. O catálogo de projetos e a página de extensão precisam ter uma decisão explícita de produto: se forem públicos, devem funcionar anonimamente e oferecer login apenas no momento de uma ação protegida; se forem áreas autenticadas, o contrato e a navegação devem comunicar isso claramente.

## 5. Modelo ideal de acesso

### 5.1 Princípios

1. **Autenticação identifica; autorização decide.** O frontend melhora a experiência, mas o backend continua sendo a autoridade final para cada recurso e ação.
2. **Deny by default.** Uma rota ou ação não deve ser liberada apenas porque o usuário conseguiu abrir a página.
3. **Menor privilégio.** Cada perfil recebe somente o menu, os dados e os comandos necessários para seu trabalho.
4. **Escopo de dados explícito.** A autorização deve considerar usuário, papel, projeto, unidade, período e vínculo de responsabilidade quando aplicável.
5. **Sessão expirada tem fluxo único.** Ao receber `401`, o frontend limpa o estado transitório, mostra uma mensagem modal compreensível e redireciona para login preservando o destino original quando isso for seguro.
6. **Estados visuais consistentes.** Sucesso, conflito, erro e confirmação devem usar o padrão de modal/toast adotado pelo projeto; não se deve exibir uma confirmação de login ao apenas navegar para a home.

### 5.2 Matriz de acesso alvo

| Área | Aluno | Docente | Coordenador | Admin | Público |
|---|---:|---:|---:|---:|---:|
| Catálogo publicado | leitura | leitura | leitura | leitura | leitura |
| Solicitar participação | sim | conforme regra de negócio | não como aluno | não como aluno | não |
| Minhas solicitações | próprias | não aplicável, salvo vínculo de aluno | não aplicável | não aplicável | não |
| Solicitações de projetos sob responsabilidade | não | sim, escopo atribuído | sim, escopo institucional | conforme permissão | não |
| Atividades e horas próprias | sim | não como aluno | não como aluno | não como aluno | não |
| Revisão de atividades | não | sim, escopo atribuído | sim, conforme governança | conforme permissão | não |
| Editais/oportunidades | consulta e inscrição | consulta | criar, revisar e publicar | administrar configuração | consulta publicada |
| Atribuição de avaliações | não | conforme atribuição | sim | conforme permissão | não |
| Certificado próprio | consulta | consulta conforme vínculo | consulta institucional | administração | validação por código |
| Usuários, papéis e auditoria | não | não | não, salvo função adicional | sim | não |

“Sim” na tabela significa capacidade prevista; cada endpoint ainda precisa aplicar suas próprias regras e escopos.

## 6. Arquitetura de telas recomendada

### 6.1 Shell compartilhado

O shell deve conter marca, identificação do usuário, papel atual, navegação contextual, indicador de sessão e saída. O menu deve ser gerado a partir do perfil e, quando necessário, dos vínculos retornados pelo backend.

Elementos compartilhados:

- cabeçalho responsivo;
- navegação lateral ou superior com item ativo;
- breadcrumbs nas áreas de gestão;
- estados de carregamento, vazio, erro e sucesso padronizados;
- modal de confirmação para ações irreversíveis;
- tratamento global de sessão expirada;
- rodapé institucional e acessibilidade de teclado.

### 6.2 Portal do aluno — `/`

Objetivo: responder rapidamente “o que posso fazer agora?”

Telas recomendadas:

- visão geral com solicitações pendentes, projetos ativos, oportunidades abertas e horas aprovadas;
- projetos publicados, com detalhe, período, elegibilidade e estado da inscrição;
- minhas solicitações, exibindo nome do projeto, período, status, datas e ações permitidas;
- extensão, separando editais disponíveis de editais nos quais o aluno já está inscrito;
- atividades e horas, com envio, acompanhamento e decisão;
- entregáveis, com upload, validação de tipo/tamanho e status;
- certificados próprios.

### 6.3 Portal docente — `/docente`

Objetivo: concentrar a revisão acadêmica que o docente pode executar.

Telas recomendadas:

- visão geral com pendências de solicitações, atividades e avaliações;
- meus projetos, limitados aos projetos atribuídos;
- solicitações recebidas, com identificação do aluno e período, sem permitir acesso fora do escopo;
- revisão de atividades e horas, com justificativa para recusa;
- avaliações atribuídas e situação de cada avaliação;
- histórico de decisões e filtros por período/status.

### 6.4 Portal do coordenador — `/coordenacao`

Objetivo: administrar o ciclo acadêmico e institucional.

Telas recomendadas:

- painel com projetos, editais, pendências e indicadores do período;
- criação e edição de projetos e períodos;
- publicação e encerramento de editais/oportunidades;
- atribuição de docentes, responsáveis e avaliadores;
- acompanhamento de solicitações e exceções;
- revisão de impactos e elegibilidade para publicação;
- acompanhamento de certificados e pendências de emissão.

### 6.5 Portal administrativo — `/admin`

Objetivo: administrar a plataforma sem misturar administração técnica com decisões acadêmicas.

Telas recomendadas:

- usuários e estado de acesso;
- papéis e permissões;
- auditoria de ações relevantes;
- configurações institucionais e integrações;
- saúde operacional e diagnósticos não sensíveis.

Não foi identificada implementação atual dessas telas. A ordem e o contrato devem ser definidos antes da construção, especialmente para evitar que `ADMIN` ganhe permissões acadêmicas implicitamente.

## 7. Exemplos de fluxos de uso

### 7.1 Aluno solicita participação

1. O aluno entra na home e escolhe **Projetos**.
2. O frontend carrega o catálogo e, em paralelo ou de forma segura, o estado das inscrições do aluno.
3. Para um projeto sem solicitação existente, exibe **Solicitar participação**.
4. O aluno confirma a ação em modal.
5. Em sucesso, o frontend exibe toast/modal de confirmação e atualiza o card para **Solicitação realizada**, desabilitando nova inscrição.
6. Se a API responder conflito `409`, o frontend trata como estado de negócio: “Você já possui uma solicitação para este projeto e período”, sem erro técnico exposto.
7. Em **Minhas solicitações**, o aluno vê o nome do projeto, período, data e status.

### 7.2 Docente revisa uma solicitação

1. O docente entra em `/docente` e vê a pendência no painel.
2. Abre o projeto sob sua responsabilidade.
3. Consulta a lista de solicitações permitida pelo backend.
4. Aprova ou recusa em modal de confirmação; a recusa exige justificativa quando o contrato determinar.
5. O frontend atualiza o status e informa o resultado.
6. O aluno visualiza a mudança somente por meio da consulta autorizada da própria solicitação.

### 7.3 Aluno envia atividade e docente decide horas

1. O aluno abre uma participação aprovada e acessa **Atividades e horas**.
2. Preenche título, descrição e horas solicitadas.
3. O frontend valida campos, limites e estado do período antes de enviar.
4. O docente vê a atividade no seu painel, com projeto e período identificados.
5. Aprova ou recusa em modal, registrando horas aprovadas ou justificativa.
6. O aluno vê o status e o total de horas aprovadas atualizado.

### 7.4 Coordenador publica um edital

1. O coordenador cria um rascunho com título, período, elegibilidade e datas.
2. O frontend valida os campos e mostra o resumo antes da publicação.
3. O coordenador confirma em modal.
4. O edital passa a aparecer no catálogo público/aluno somente após o backend confirmar o estado publicado.
5. O sistema impede nova inscrição do mesmo aluno no mesmo edital/período e exibe a inscrição em suas solicitações.

### 7.5 Público valida um certificado

1. Uma pessoa acessa `/certificados` sem login.
2. Informa o código de validação.
3. O backend retorna somente os dados públicos autorizados.
4. A tela mostra certificado válido, inválido ou não encontrado sem expor informações pessoais além do necessário.

## 8. Lacunas e backlog priorizado

### P0 — segurança funcional e coerência de navegação

- Criar as rotas `/docente`, `/coordenacao` e `/admin`, ou revisar formalmente os destinos se os contratos mudarem.
- Implementar guardas de rota por perfil e estados de `401`/`403`.
- Gerar o menu do `AuthenticatedShell` por papel, em vez de usar sempre as opções do aluno.
- Unificar `PlatformHeader` e `AuthenticatedShell` ou documentar claramente a separação.
- Garantir que cada tela institucional filtre dados por escopo e não apenas por controle visual.

### P1 — completar as jornadas de negócio

- Conectar `ProjectManagement`, `ActivitiesDashboard` e `EvaluationAssignmentDashboard` às telas de docente/coordenador adequadas.
- Exibir sempre nome do projeto e período, evitando UUIDs como identificação primária para o usuário.
- Substituir indicadores estáticos por dados derivados dos endpoints reais.
- Separar “editais disponíveis” de “minhas inscrições” e desabilitar inscrições duplicadas.
- Definir a experiência de certificados próprios para aluno e de gestão para coordenação.

### P1 — validação

- Criar testes E2E por perfil: login, redirecionamento, menu, leitura, ação autorizada e ação negada.
- Criar matriz de endpoints/rotas com respostas esperadas `200`, `401`, `403` e `409`.
- Validar sessão expirada em cada área autenticada.
- Cobrir teclado, foco de modal, leitor de tela, responsividade e estados vazios.

### P2 — administração e refinamento

- Implementar painel administrativo somente após confirmar contratos de usuários, RBAC e auditoria.
- Adicionar filtros, paginação e exportações apenas onde houver necessidade operacional comprovada.
- Consolidar métricas de uso por perfil e tempo de conclusão das tarefas principais.

## 9. Métricas de aceite do modelo por perfil

O modelo deve ser considerado funcional quando:

1. 100% dos perfis reconhecidos pelo login têm uma rota de destino existente ou uma decisão documentada de indisponibilidade.
2. Nenhum perfil consegue abrir uma ação de outro perfil apenas alterando a URL; o backend deve retornar `403` e o frontend deve apresentar uma tela de acesso negado adequada.
3. Cada perfil possui menu e home com pelo menos uma tarefa principal específica.
4. Um aluno nunca visualiza solicitações, atividades ou documentos de outro aluno.
5. Um docente só visualiza projetos e participantes do seu escopo autorizado.
6. Um coordenador consegue publicar um edital e o aluno consegue se inscrever uma única vez, com conflito `409` tratado como estado esperado.
7. Sessão expirada redireciona para login sem loop e sem exibir um falso toast de login bem-sucedido ao retornar à home.
8. Todos os fluxos críticos possuem teste E2E por perfil e registro claro do que foi executado.
9. Os estados de sucesso, conflito, erro e confirmação seguem um único padrão visual e acessível.
10. O build, lint/typecheck e os testes definidos no repositório continuam passando após a implementação.

## 10. Limitações e decisões pendentes

- Não foi identificada uma implementação frontend completa para `DOCENTE`, `COORDENADOR` ou `ADMIN`.
- A existência e o contrato de todos os endpoints administrativos não foram inferidos a partir do frontend; devem ser confirmados na documentação/contratos do backend antes da implementação.
- A regra final sobre quais páginas são públicas ou exigem autenticação deve ser consolidada com produto e backend.
- A análise não altera código de produto nem afirma que fluxos não executados estão validados.

## 11. Próximo passo recomendado

Transformar este documento em três entregas de implementação, nesta ordem:

1. **Role routing e shell:** rotas, guardas, sessão expirada e menus por perfil.
2. **Portais de docente e coordenação:** conectar os componentes já existentes às jornadas reais.
3. **Portal administrativo e matriz E2E:** somente após confirmar contratos de RBAC, auditoria e escopos.

Essa ordem reduz o risco de continuar adicionando telas de aluno sobre uma arquitetura de navegação que ainda não representa os papéis institucionais do sistema.
