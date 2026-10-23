# Regras por issue e lacunas de refinamento

Fonte adicional: caderno de perguntas e respostas recebido em 22/10/2026. As respostas do caderno são **propostas/regras candidatas**; não se tornam baseline aprovada sem validação. As SPECs AUTH, PI, EXT e Portal permanecem Draft. Os refinamentos abaixo ficam junto à issue que depende deles.

## Como interpretar as pendências

Há dois tipos diferentes de pendência, e eles não devem ser misturados:

1. **Alinhamento/decisão de Produto:** falta uma regra de negócio, uma escolha entre alternativas ou aprovação de política. A decisão cabe ao PO/coordenação acadêmica e, conforme o tema, a Segurança/Privacidade ou responsável técnico. A equipe registra a decisão na issue/SPEC/ADR e não deve inventar a regra durante a implementação.
2. **Desenvolvimento das equipes:** a regra já está aprovada, mas falta projetar, implementar, integrar, testar ou documentar a solução. A responsabilidade é da equipe indicada no card. Pode haver bloqueio técnico até a decisão anterior, mas isso não transforma a decisão de Produto em tarefa para a equipe técnica.

Uma pendência pode conter as duas etapas: primeiro obter a decisão; depois desenvolver e validar segundo os critérios aprovados. A equipe deve avançar em partes independentes e bloquear apenas os critérios afetados.

### Registro mínimo de cada decisão

Na própria issue/SPEC que precisa da resposta, registrar:

- **Pergunta e alternativas:** qual comportamento precisa ser escolhido, sem apresentar sugestão como fato.
- **Responsável pela decisão:** PO/coordenação; adicionar Segurança/Privacidade ou responsável técnico quando necessário.
- **Status:** pendente, aprovada ou rejeitada.
- **Decisão, justificativa e data:** preencher após alinhamento; indicar a fonte aprovada.
- **Impactos e critérios de aceite:** SPEC, API, dados, telas, infraestrutura e testes afetados; transformar a decisão em critérios verificáveis.
- **Rastreabilidade:** links diretos para SPEC, ADR e cards de implementação/teste, quando existirem. Não criar referências a documentos ainda inexistentes.

## PG-005 — Épico e requisitos de AUTH

**Proposta do caderno:** login local por CPF; conta criada via importação de CSV pela coordenação; estudante define senha no primeiro acesso; não há cadastro espontâneo.

**Alinhamento necessário:** a base vigente prevê OIDC/OAuth2 e recuperação por token. Produto e Segurança devem escolher a identidade, a origem oficial do usuário, o conteúdo e reprocessamento do CSV, normalização/uniquidade de CPF, primeiro acesso e redefinição. Se houver reset manual, definir verificação de identidade, autorização e revogação de sessões.

**Depois da decisão, equipes desenvolvem:** Backend/DB implementam o fluxo aprovado e suas restrições; Frontend integra as telas e estados; QA cobre sucesso, falhas e segurança. Critérios de aceite devem refletir a decisão registrada em PG-006/SPEC AUTH.

## PG-006 — SPEC-AUTH-001..004

- **Login e conta — alinhar:** identidade, estados ativa/inativa, unicidade, cadastro e comportamento de conta associada a mais de uma turma.
- **Importação — alinhar:** campos do CSV, formato, duplicatas, erros parciais, atualização e desativação de turma/aluno.
- **Senha/sessão — alinhar:** OIDC versus senha local; token de recuperação versus reset manual; bootstrap, mudança obrigatória no próximo acesso (se aprovada), verificação de identidade, expiração, logout e revogação.
- **RBAC — alinhar:** matriz de coordenação acadêmica, administrador técnico, docente e estudante; permissões acumuladas quando houver múltiplos papéis; escopo por turma/projeto.
- **Auditoria — alinhar:** o caderno propõe não registrar auditoria; Must Haves/arquitetura atuais exigem trilha para ações sensíveis. Aprovar eventos, dados mínimos, retenção, acesso e comportamento em falha antes de alterar controles.
- **Equipes, após aprovação:** Backend implementa autenticação/autorização e endpoints; DB materializa identidade, papéis e auditoria conforme decisão; Frontend aplica os estados/permissões sem substituir autorização do servidor; QA valida matriz de acesso, importação e fluxos de conta.
- **Critérios de aceite:** critérios numerados por fluxo, incluindo casos negados/erro; manter SPEC Draft até decisões e revisão de PO, Segurança e responsáveis técnicos.

## PG-007 — Épico e requisitos de PI

**Proposta do caderno:** projetos podem ser contínuos ou ter data final; participantes podem mudar por semestre; todo projeto exige docente responsável; duplicidade equivalente não é bloqueada automaticamente.

**Alinhamento necessário:** campos mínimos, ciclo de vida, semestre, continuidade, audiência de rascunho, publicação e como docente identifica propostas equivalentes. Decidir se união PI/Extensão é atributo de domínio ou consequência de participação. Contagem dupla não aprova automaticamente o literal `HYBRID` no enum `project_type`.

**Depois da decisão, equipes desenvolvem:** DB/Backend implementam modelo e regras de ciclo de vida; Frontend apresenta estados e ações; QA verifica transições, visibilidade e casos de continuidade.

## PG-008 — SPEC-PI-001..004

- **Participação/equipe — alinhar:** o caderno propõe pedido do aluno em janela com aprovação/negação do docente, sem convite individual; remoção exige justificativa. O card técnico atual cita convites. Escolher jornada, estados, desistência, vagas/elegibilidade, notificações e transições.
- **Limite de participação — alinhar:** definir como impedir, inclusive em operações simultâneas, mais de um PI e uma Extensão por estudante; atividade classificada em ambos ocupa os dois limites.
- **Bancas/avaliação — alinhar:** o caderno elimina bancas/agendamento; a base atual descreve banca/agendamento. Escolher a jornada antes de modelar avaliações.
- **Notas — alinhar:** escala, precisão, fórmula, pesos, arredondamento, avaliações ausentes, quem cria/finaliza/reabre e visibilidade para estudantes versus público. Caderno propõe critérios/pesos definidos pelo docente responsável PI e não manter histórico; reconciliar com auditoria vigente.
- **Arquivos — alinhar:** MIME real e tamanho máximo; PDF/DOCX/imagens são formatos citados, não limites aprovados. Separar acesso privado do projeto de publicação; decidir consentimento para fotos, menores e terceiros.
- **Equipes, após aprovação:** Backend/DB implementam estados, limites e regras transacionais; Frontend implementa jornada aprovada; QA testa transições, simultaneidade, permissões, cálculos e visibilidade.
- **Critérios de aceite:** descrever cenários verificáveis para cada fluxo; não publicar campos, constraints ou API baseados em regra ainda pendente.

## PG-009 — Épico e requisitos de Extensão

**Proposta do caderno:** coordenação controla janelas de inscrição; docente responsável define e valida horas; avisos podem ser gerais ou específicos de projeto.

**Alinhamento necessário:** separar edital, atividade/projeto e aviso; definir atores, calendário/fuso UTC-3, elegibilidade, vagas, inscrição duplicada, cancelamento e relação entre inscrição e participação. Aviso não equivale automaticamente a edital.

**Depois da decisão, equipes desenvolvem:** Produto documenta fluxo e critérios; Backend/DB implementam inscrições e vínculos; Frontend apresenta oportunidades e status; QA valida elegibilidade, janela, duplicidade e cancelamento.

## PG-010 — SPEC-EXT-001..003

- **Prazos — alinhar:** o caderno diz que fases não podem ser prorrogadas e também que docente pode ajustar prazo. Resolver a contradição; definir fuso e submissão no instante limite.
- **Horas — alinhar:** unidade, limites, evidência aceita, correção, recusa/motivo e cálculo do total. O responsável docente valida; esclarecer se qualquer docente pode avaliar extensão e quem finaliza/corrige.
- **Histórico/auditoria — alinhar:** caderno propõe não guardar histórico de horas/notas; reconciliar com controles atuais antes de modelar atualização ou exclusão.
- **Certificado — alinhar:** elegibilidade, conteúdo, assinatura/QR, validade, revogação e reemissão.
- **Arquivos AWS — alinhar:** retenção permanente sem backup é sugestão, não política. Infra/Segurança revisam privacidade, custo e recuperação.
- **Equipes, após aprovação:** Backend/DB implementam cálculo, registros e estados; Frontend oferece submissão e acompanhamento; Cloud configura armazenamento conforme política aprovada; QA testa prazos, evidências, horas, certificado e permissões.

## PG-011 — Épico e requisitos do Portal

**Proposta do caderno:** projeto só é público quando docente opta pela publicação; docente deve considerar consentimento de imagens.

**Alinhamento necessário:** delimitar conteúdo anônimo e autenticado, dados pessoais, parceiros, imagens, autorização de menores/terceiros, quem aprova e como retirar publicação. Separar arquivo interno da apresentação pública.

**Depois da decisão, equipes desenvolvem:** Produto formaliza campos e consentimentos; Backend cria projeção pública permitida; Frontend apresenta somente conteúdo aprovado; QA valida acesso anônimo/autenticado, retirada e privacidade.

## PG-012 — SPEC-PORTAL-001..002

**Alinhamento necessário:** campos públicos, busca/filtros/ordenação/paginação, comportamento de rascunho, cache e retirada; fonte/aprovação de impacto social e autorização de imagem. O caderno não aprova automaticamente qualquer campo público.

**Depois da decisão, equipes desenvolvem:** Backend implementa contrato público e filtros; Frontend constrói catálogo conforme contrato; Cloud define cache compatível com retirada; QA verifica campos autorizados, paginação, cache e remoção. Só conteúdo permitido e aprovado entra no catálogo.

## Dependências técnicas ligadas às decisões

- **DB-004..006 / AUTH:** decidir identidade local versus externa, CPF/CSV e RBAC antes de constraints e seeds.
- **DB-007 / auditoria:** não afrouxar `public.audit_event` até decisão formal sobre histórico e eventos sensíveis.
- **DB-008..010 / PI:** decidir convite versus solicitação, banca versus avaliação e política de nota antes de modelo e constraints.
- **DB-011 / arquivos:** aprovar tamanho, acesso, consentimento e retenção antes de metadados e lifecycle.
- **DB-012..013 / Extensão e horas:** DB-012 está fechado e é histórico; para implementação ativa, decidir edital/atividade, janelas, fuso, elegibilidade e prazos antes de constraints.
- **INF-005, INF-010 e INF-011 / Cloud:** separar backups do PostgreSQL da retenção de arquivos; manter arquivos privados; não configurar lifecycle/expiração ou cache público sem política aprovada.
- **QA-008..015 / QA:** casos de teste dependem das decisões AUTH, RBAC, convites, editais, bancas, arquivos e horas. Sem regra aprovada, registrar o caso como bloqueado, sem inventar resultado esperado.
- **Frontend/Backend:** implementar o contrato aprovado; tela, tabela ou API não decide regra acadêmica.

## Pendências por sprint: alinhar versus desenvolver

O quadro abaixo classifica as lacunas identificadas no material consultado. “Alinhar” é decisão de Produto/área responsável; “desenvolver” é trabalho das equipes depois da decisão. Esta lista não presume que todo item esteja atualmente bloqueando todo o sprint.

### Atual — Sprints 0, 1 e 2

#### Sprint 0

**Alinhar**
- Aprovar escopo e contratos das SPECs; resolver conflitos iniciais de AUTH, auditoria, banca, publicação e retenção.
- Confirmar a referência/contrato AUTH mencionado nos cards e localizar ou criar o documento canônico com responsável e revisão.
- Definir convenções e os dados sintéticos permitidos para seeds, sem usar dados pessoais reais.

**Desenvolver**
- PO/Arquitetura registra decisões e critérios aprovados nas issues/SPECs.
- DB estabelece convenções, modelo conceitual e estrutura inicial; produz migrations versionadas e seeds sintéticas conforme contratos aprovados.
- Backend, Frontend, Cloud e QA preparam contratos, ambiente e validações previstas nos cards da Sprint 0. Não antecipar regras de negócio não aprovadas.

#### Sprint 1

**Alinhar**
- Normalização/unicidade de CPF e regras de CSV; bootstrap, reset e papéis.
- Campos/estados de projeto, visibilidade e continuidade; elegibilidade, desistência, convites versus pedidos e limite simultâneo PI/Extensão.

**Desenvolver**
- DB/Backend implementam identidade, autorização e estrutura de projetos conforme decisões.
- Frontend implementa os fluxos de conta e projeto aprovados.
- QA cobre cadastro/importação, permissões, visibilidade e participação segundo critérios aceitos.

#### Sprint 2

**Alinhar**
- Banca versus avaliação; escala, pesos, arredondamento e revisão de nota.
- Formatos/tamanho/consentimento de arquivos; fluxo de horas/evidências; prazo, fuso e prorrogação.
- Retenção e auditoria, incluindo política separada para banco e arquivos.

**Desenvolver**
- Backend/DB implementam avaliações, registros de horas, arquivos e auditoria conforme regras aprovadas.
- Frontend oferece submissão, revisão e acompanhamento dos fluxos.
- Cloud configura armazenamento, backup e recuperação conforme políticas aprovadas.
- QA valida cálculos, prazos, permissões, evidências, retenção aplicável e restauração prevista nos cards.

### Futuro — Sprints 3, 4, 5 e 6

O refinamento abaixo é uma lista de temas a confirmar no planejamento dessas sprints; não significa que toda regra já tenha sido aprovada.

#### Sprint 3

**Alinhar:** fórmula e versionamento de rubricas; critérios para certificado; campos do catálogo; política de auditoria e retenção.

**Desenvolver após alinhamento:** equipes implementam rubricas/certificados/catálogo conforme os cards, com testes de regras e migrações necessários.

#### Sprint 4

**Alinhar:** definição de impacto social; relação edital–atividade–projeto; vagas, inscrição, cancelamento, prazos e fuso.

**Desenvolver após alinhamento:** equipes implementam fluxo de extensão e apresentação de impacto, com validações e testes.

#### Sprint 5

**Alinhar:** metas RPO/RTO; retenção e backup do banco; política separada para arquivos; critérios de restauração e rollback.

**Desenvolver após alinhamento:** Cloud/DB implementam e demonstram recuperação, restauração e rollback; QA valida os cenários definidos.

#### Sprint 6

**Alinhar:** critérios de homologação/go-no-go, segurança, acessibilidade, rollback e exceções permitidas.

**Desenvolver após alinhamento:** equipes completam runbooks, dicionário de dados, documentação coerente com migrations e evidências de homologação.

## Limites e atualização desta KB

- A KB separa proposta, decisão pendente e trabalho de implementação; somente decisão aprovada altera a baseline.
- Cada decisão deve permanecer junto à issue/SPEC que depende dela; a KB central serve como mapa e visão cruzada.
- Antes de fechar qualquer item, vincular os critérios à SPEC e aos cards técnicos/testes existentes. Se o documento ou card não existir, registrar essa lacuna sem inventar caminho ou número.
- Revisar este mapa quando PO/coordenação aprovar decisões ou quando as issues/SPECs mudarem; registrar fonte e data da atualização.
