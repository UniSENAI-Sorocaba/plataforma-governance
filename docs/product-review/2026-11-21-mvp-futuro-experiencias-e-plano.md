# Revisão do produto: MVP, experiência por usuário e plano de evolução

**Data da revisão:** 2026-11-21  
**Escopo:** produto, experiência do usuário, prontidão do MVP/V1 e horizonte 2027.1  
**Base:** KB ativa, especificações, evidências F1–F6, código e testes integrados dos repositórios.

## 1. Síntese executiva

O produto está funcionalmente avançado no ambiente local, mas ainda não está pronto para ser declarado como release V1. O estado correto é:

- **MVP funcional local:** as jornadas centrais de autenticação, projetos, participação, entregáveis, extensão, avaliações, certificados e portal público foram implementadas e possuem validações locais relevantes.
- **MVP de experiência incompleto:** o fluxo do aluno é o mais desenvolvido; docente, coordenação e administração ainda não possuem portais completos e coerentes com suas responsabilidades.
- **MVP de produto com decisões pendentes:** importação de usuários, matriz completa de permissões, detalhes de notas, conteúdo de certificados, arquivos e indicadores de impacto ainda têm lacunas normativas.
- **V1 operacional em NO-GO controlado:** faltam evidências em staging/AWS para E2E consolidado, Lighthouse, DAST, imagem de release, backup/restore, deploy, smoke e rollback.
- **Fase futura definida em alto nível:** Patrimônio, Carreiras, Iniciação Científica e CPA/Ouvidoria estão corretamente fora do MVP, mas ainda precisam de jornadas, regras, métricas, contratos e sequenciamento detalhados.

O maior risco para o usuário não é uma ausência de backend isolada. É o desalinhamento entre perfil, navegação, permissão, estado da tarefa e comunicação do sistema.

## 2. Critério usado para classificar o estado

| Estado | Significado |
|---|---|
| **Coberto** | Existe implementação integrada e evidência de teste compatível com o escopo atual. |
| **Coberto localmente, falta aceite externo** | O comportamento foi validado localmente, mas depende de staging, AWS, domínio ou operação real. |
| **Parcial** | Há código ou componentes, porém a jornada do usuário, o escopo de acesso ou a integração ainda não está completo. |
| **Aberto de produto** | A regra necessária para implementar/aceitar ainda não foi decidida formalmente. |
| **Futuro** | Está fora do MVP e deve ser tratado como produto posterior, sem entrar no go-live atual. |

## 3. O que o MVP já cobre

### 3.1 Identidade, sessão e autorização

**Coberto localmente:** autenticação local, sessão, refresh, recuperação de credencial, RBAC server-side, negação por padrão e logs técnicos sanitizados possuem implementação e testes.

**Ajuste obrigatório de documentação:** o baseline antigo descreve SSO/OAuth2/JWT RS256 e e-mail institucional, enquanto as decisões oficiais mais recentes definem login local por CPF, provisionamento por CSV e ausência de provedor externo. A decisão mais recente deve prevalecer e todos os documentos incompatíveis precisam ser reconciliados antes do release.

**Em aberto para o usuário:** primeiro acesso, troca de senha temporária, reset feito por docente/coordenação, importação CSV, conta em mais de uma função, inativação por turma/aluno e comportamento de sessões após reset.

### 3.2 Projetos Integradores e Extensão

**Coberto localmente:** cadastro de propostas, rascunho/publicação, participação por solicitação, decisão docente, limites de participação, entregáveis, oportunidades/editais, inscrições, atividades e horas possuem código, migrations, contratos e testes relevantes.

**Parcial na experiência:** o catálogo e as ações do aluno estão mais completos que a operação de docente e coordenação. A regra de negócio está mais madura que a navegação que a apresenta.

**Em aberto para o usuário:** prazos e mensagens de estado precisam ser sempre visíveis; não há e-mail no MVP; atividades aceitam descrição textual, sem upload de evidência; a recusa exige justificativa; o aluno precisa distinguir solicitação de participação, inscrição em edital, atividade e entregável.

### 3.3 Avaliações, notas e certificados

**Coberto localmente:** rubricas versionadas, atribuição de avaliação, cálculo determinístico, emissão/revogação e consulta pública de certificados foram implementados e testados.

**Parcial:** a verificação pública ainda usa o hash persistido e o estado de revogação. A reconstituição do payload completo do documento para detectar alteração física do PDF depende do contrato final do certificado.

**Em aberto de produto:** escala, precisão, arredondamento, avaliação ausente, visibilidade detalhada das avaliações entre alunos, motivo de correção, campos do certificado, assinatura, validade, reemissão, retenção e backup.

### 3.4 Portal público

**Coberto localmente:** catálogo SSR, busca/filtros, paginação, impactos aprovados, certificados públicos, metadata, sitemap e robots foram implementados. A execução local de Lighthouse em impactos atingiu 93/94/100/96.

**Coberto localmente, falta aceite externo:** a meta de Lighthouse precisa ser demonstrada em staging; o cache/CDN deve permitir retirada efetiva de conteúdo publicado.

**Em aberto de produto:** campos oficiais do catálogo, indicadores de impacto, origem dos dados, autorização de imagens, proteção de beneficiários, correção/retirada e prazo de expurgo de cache.

### 3.5 Qualidade e operação

**Coberto localmente:** testes unitários, integração, contrato, build, migrations, carga local equivalente a 200 RPS, validação Terraform no MiniStack e E2E de jornadas selecionadas foram executados.

**Bloqueador de V1:** não há evidência de staging/AWS para E2E consolidado, Lighthouse, DAST, scan de imagem em registry, backup/restore RDS, deploy, smoke e rollback. Também faltam credenciais AWS/OIDC, conta e domínio de staging.

## 4. Experiência esperada por usuário

### 4.1 Aluno

**Objetivo:** encontrar uma oportunidade, participar de um projeto, cumprir atividades, acompanhar horas/notas e obter seu certificado sem depender de planilhas ou contato manual.

**Jornada MVP:**

1. Entrar com CPF e senha; no primeiro acesso, criar senha definitiva.
2. Ver na home apenas o que pode fazer agora: períodos abertos, solicitações pendentes, projetos ativos, atividades pendentes e horas aprovadas.
3. Consultar projetos publicados e rascunhos disponíveis para alunos autenticados.
4. Solicitar participação ou inscrever-se em edital, sempre vendo período, status e regra de desistência.
5. Enviar atividade, horas e entregável; receber confirmação visual e estado atualizado.
6. Corrigir atividade recusada enquanto o período permitir, lendo o motivo da recusa.
7. Consultar nota e horas próprias; nunca ver dados individuais de outro aluno.
8. Emitir/consultar certificado e validar sua autenticidade publicamente.

**Pontos de correção prioritários:** separar claramente “solicitação”, “inscrição”, “atividade” e “entregável”; mostrar prazos em horário de Brasília; tratar `409` como mensagem de negócio; manter uma área “Minhas pendências”; não prometer e-mail no MVP.

### 4.2 Docente/orientador

**Objetivo:** operar as pendências acadêmicas dos projetos sob sua responsabilidade, com o menor número de telas possível.

**Jornada MVP:**

1. Entrar e chegar a `/docente`, com a lista de projetos e pendências autorizadas.
2. Aprovar/negar solicitações de participação, sempre com estado e contexto do período.
3. Acompanhar participantes e entregáveis do projeto.
4. Aprovar/rejeitar atividades e horas; exigir justificativa quando rejeitar.
5. Criar/editar rubrica conforme seu escopo, avaliar e finalizar quando permitido.
6. Reabrir/corrigir apenas as avaliações que a regra permite.
7. Publicar ou retirar o projeto e controlar autorização de fotos quando possuir essa responsabilidade.

**Ponto atual:** existem componentes de gestão, atividades e avaliações, mas não foi identificada uma experiência completa e integrada de `/docente`. Esta é uma lacuna de impacto direto no MVP.

### 4.3 Coordenação

**Objetivo:** controlar períodos, editais, vínculos institucionais, responsáveis, avaliadores e exceções sem executar tarefas de aluno ou docente por atalho administrativo.

**Jornada MVP:**

1. Entrar em `/coordenacao` com visão do semestre, pendências e alertas.
2. Importar e corrigir cadastros de usuários por CSV, com pré-visualização e relatório por linha.
3. Criar/ajustar períodos e editais; deixar explícitas as datas e o fuso.
4. Atribuir docentes/avaliadores e acompanhar conflitos de escopo.
5. Reabrir prazo apenas pela operação autorizada, sem revalidar automaticamente envios antigos.
6. Revisar impactos e acompanhar elegibilidade para publicação.
7. Acompanhar certificados e indicadores acadêmicos sem acessar dados fora do escopo.

**Ponto atual:** a coordenação possui capacidades de backend e alguns componentes, mas a rota e o painel completo não foram identificados como experiência consolidada.

### 4.4 Administrador

**Objetivo:** manter a plataforma, identidades, permissões e saúde técnica; não substituir decisões acadêmicas sem permissão explícita.

**Jornada mínima:** usuários, papéis, estado de acesso, diagnósticos operacionais e configurações permitidas.

**Ponto atual:** `/admin` aparece como destino documentado, mas não há uma área administrativa geral identificada. Deve ser decidido se a administração entra no MVP mínimo ou se somente as ações de coordenação necessárias ao semestre serão entregues.

### 4.5 Visitante externo

**Objetivo:** entender o valor produzido pela instituição e validar certificados sem criar conta.

**Jornada MVP:** navegar no catálogo, filtrar por curso/semestre/ODS, abrir projeto publicado, consultar impacto aprovado e validar certificado por código/QR.

**Regras de confiança:** nunca expor solicitações, justificativas, horas individuais, notas individuais ou arquivos internos; retirada de publicação deve sair do serviço e do cache dentro do SLA definido.

### 4.6 CPA/ouvidoria, patrimônio, carreira e IC — experiência futura

Esses usuários não devem aparecer como “quase disponíveis” no MVP. A futura experiência será desenhada por jornadas próprias:

- **Patrimônio:** solicitar/reservar, retirar, devolver e reportar avaria, com rastreabilidade do ativo.
- **Carreira:** completar perfil, publicar currículo/portfólio, descobrir vaga e candidatar-se com controle de privacidade.
- **IC/IT:** consultar edital, submeter plano, acompanhar parecer, entregar relatório e receber decisão.
- **CPA/Ouvidoria:** responder pesquisa sem ambiguidade sobre anonimato, enviar manifestação confidencial e acompanhar protocolo sem revelar identidade indevidamente.

## 5. Pontos em aberto e plano de correção do MVP

| ID | Ponto em aberto | Impacto | Plano de correção | Critério de pronto |
|---|---|---|---|---|
| MVP-01 | Reconciliar documentos que ainda falam em SSO/OAuth2/e-mail com login por CPF/CSV | Alto: pode gerar fluxo de login errado | Produto + Governança revisar baseline, ADRs, contratos, telas e testes | Uma única regra oficial referenciada por todos os documentos e testes |
| MVP-02 | Fechar importação CSV, CPF, duplicatas, erros parciais e reimportação | Alto: coordenação pode bloquear o início do semestre | Definir contrato, prévia, validação, atomicidade, relatório e rollback lógico | Importação autorizada, reproduzível e compreensível por linha |
| MVP-03 | Fechar matriz de permissões e escopos | Alto: risco de vazamento ou bloqueio de tarefa | Criar matriz ação × papel × vínculo × recurso; testar allow/deny | Toda ação P0 possui regra server-side e teste 401/403/escopo |
| MVP-04 | Entregar portais docente e coordenação | Alto: sem eles o ciclo acadêmico não fecha | Consolidar shell, rotas, menus, dashboards e estados por perfil | Docente e coordenação completam suas jornadas sem URL manual ou banco |
| MVP-05 | Decidir escopo mínimo do admin | Médio/alto | Separar administração técnica, coordenação e decisões acadêmicas | Permissões mínimas documentadas e telas ou exclusão formal do MVP |
| MVP-06 | Fechar notas e avaliações | Alto: afeta resultado acadêmico | PO decidir escala, precisão, arredondamento, ausência, visibilidade e correção | SPEC aprovada, exemplos de cálculo e E2E de cada estado |
| MVP-07 | Fechar contrato do certificado | Alto: afeta validade documental | Definir campos, assinatura, QR, validade, revogação, reemissão, retenção e backup | PDF/QR alterado é detectado; emissão e validação têm critérios verificáveis |
| MVP-08 | Fechar entregáveis e imagens | Alto: risco de upload indevido e privacidade | Definir tamanho, MIME, antivírus, armazenamento, substituição, autorização e retirada | Arquivo válido/inválido e foto autorizada/não autorizada têm testes |
| MVP-09 | Fechar impacto e catálogo público | Médio/alto: comunicação institucional | Definir indicadores, fonte, campos públicos, aprovação, proteção de beneficiários e expurgo | Conteúdo publicado é explicável, revisável e retirável do cache |
| MVP-10 | Corrigir comunicação e estados da UX | Alto: usuário não sabe o que fazer | Padronizar loading, vazio, erro, conflito, confirmação, prazo e pendência | Jornadas críticas têm mensagens de negócio e recuperação sem suporte manual |
| MVP-11 | Executar gates externos de release | Bloqueador de V1 | Provisionar conta, OIDC, domínio e staging; executar T22/T23/T26/T27/Lighthouse | Evidências anexadas e decisão go/no-go revisada |
| MVP-12 | Confirmar operação e continuidade | Alto após publicação | Medir RPO/RTO, testar restore, alarmes, smoke e rollback | Runbook executado por pessoa diferente do autor |
| MVP-13 | Reconciliar auditoria de negócio | Médio: evita expectativa contraditória | Remover exigências incompatíveis e manter apenas logs técnicos sanitizados | SPECs, logs e política não prometem histórico que o produto não guarda |

### Ordem recomendada do MVP

1. **Decisões bloqueantes:** MVP-01, MVP-02, MVP-03, MVP-06, MVP-07, MVP-08 e MVP-09.
2. **Experiência de operação:** MVP-04, MVP-05 e MVP-10.
3. **Aceite externo:** MVP-11 e MVP-12.
4. **Higiene documental:** MVP-13 e atualização de rastreabilidade.

Não iniciar novas features futuras enquanto houver uma jornada P0 sem dono, permissão, estado visual e teste de aceite.

## 6. Plano de cobertura da versão futura

### Fase F7 — Descoberta e fundação comum

**Objetivo:** transformar cada módulo futuro em produto especificado, sem transportar ambiguidades do MVP.

- validar personas, atores institucionais e dados sensíveis;
- definir jornadas ponta a ponta e exceções;
- criar SPECs com regras, métricas, contratos e critérios de aceite;
- reutilizar identidade, perfis, shell, notificações internas, busca, arquivos e observabilidade;
- decidir integrações externas, retenção, LGPD, exportação e auditoria técnica.

**Saída:** backlog priorizado, dependências e decisões aprovadas para cada módulo.

### Fase F8 — Patrimônio

- inventário de ativos e QR Code;
- reserva de salas/laboratórios;
- empréstimo, devolução, atraso e responsabilidade;
- ocorrência, foto, avaria, triagem e encerramento;
- painéis de disponibilidade e inventário.

**Aceite de usuário:** um responsável localiza um ativo, registra retirada/devolução e resolve uma avaria sem planilha paralela; o aluno só vê o que pode solicitar.

### Fase F9 — Carreira e oportunidades

- perfil profissional e consentimento de visibilidade;
- currículo/portfólio versionado;
- vagas com elegibilidade e prazo;
- candidatura, retirada, status e comunicação;
- área de empresa/recrutador sem exposição excessiva de dados.

**Aceite de usuário:** aluno controla o que é público, candidata-se uma vez por vaga e entende o status; empresa consulta apenas perfis autorizados.

### Fase F10 — Iniciação Científica e Tecnológica

- edital e bolsas;
- plano de trabalho;
- orientação e pareceristas;
- relatórios parciais/finais;
- aprovação, pendência, recurso e encerramento.

**Aceite de usuário:** estudante sabe o próximo prazo e o motivo de cada decisão; orientador e parecerista só veem processos atribuídos; coordenação enxerga o portfólio do edital.

### Fase F11 — CPA e Ouvidoria

- questionários dinâmicos e ciclos;
- avaliação de serviços, como cantina;
- manifestação identificada, confidencial ou anônima conforme regra aprovada;
- protocolo, encaminhamento, resposta e encerramento;
- indicadores agregados e exportação para relatório institucional.

**Aceite de usuário:** o participante entende o grau de anonimato antes de enviar; a CPA não consegue inferir identidade por acidente; a gestão trabalha com dados agregados.

### Fase F12 — Escala, integração e melhoria contínua

- notificações configuráveis, preferencialmente sem transformar o MVP em dependência de e-mail;
- exportação analítica e integração com sistemas acadêmicos;
- histórico de negócio quando houver obrigação regulatória aprovada;
- relatórios institucionais, acessibilidade contínua, analytics de uso e suporte;
- aplicativo móvel somente após provar que a experiência web não cobre o caso.

## 7. Roadmap operacional consolidado

| Ordem | Entrega | Dependência | Resultado para o usuário |
|---:|---|---|---|
| 1 | Reconciliar produto e contratos do MVP | PO/Governança | Login, prazos e permissões deixam de ser ambíguos |
| 2 | Fechar regras de notas, certificados, arquivos e impacto | Produto | Resultados acadêmicos e públicos passam a ser confiáveis |
| 3 | Portais docente, coordenação e escopo mínimo admin | Frontend + Backend | Todos os atores necessários conseguem concluir suas tarefas |
| 4 | UX de estados, pendências e privacidade | Frontend + Produto + QA | Usuário sabe o que aconteceu e qual é o próximo passo |
| 5 | Staging, segurança, backup, deploy e rollback | Infra + Qualidade + Banco | MVP torna-se operável e reversível |
| 6 | Go/no-go e homologação com usuários | PO + representantes dos perfis | Aceite baseado em jornadas reais |
| 7 | Descoberta da Fase 2 | Produto + Governança | Futuro tem escopo e valor, não apenas lista de módulos |
| 8 | Patrimônio, Carreira, IC e CPA por ondas | Squads conforme dependências | Cada módulo entra com jornada completa e métricas próprias |

## 8. Definition of Done orientada ao usuário

Uma feature só deve ser considerada concluída quando:

- o ator, objetivo e escopo de dados estão documentados;
- a rota e a navegação aparecem para o perfil correto;
- o servidor autoriza ou nega a ação independentemente do frontend;
- sucesso, vazio, erro, conflito, prazo e sessão expirada têm tratamento visível;
- a regra de negócio tem teste automatizado e evidência reproduzível;
- dados privados não vazam para outro usuário ou para o portal público;
- o suporte sabe explicar o próximo passo sem consultar o banco;
- a operação tem métricas, logs sanitizados e procedimento de recuperação quando aplicável;
- o PO aceita a jornada completa, e não apenas o endpoint.

## 9. Referências principais

- [Baseline do MVP](../../_KB/product/mvp-baseline.md)
- [Escopo geral](../../_KB/product/scope.md)
- [Personas](../../_KB/product/personas.md)
- [Regras oficiais do caderno](../../_KB/product/official-validation-decisions.md)
- [Plano mestre MVP/V1](../mvp-v1-plan/00-plano-mestre.md)
- [Plano de release e go/no-go](../mvp-v1-plan/05-release-v1-e-go-no-go.md)
- [Evidência do go/no-go de 2026-11-21](../mvp-v1-plan/evidence/F6-go-no-go-2026-11-21.md)
- [Frontend por perfil e fluxos](../mvp-v1-plan/frontend-personas-and-flows.md)
