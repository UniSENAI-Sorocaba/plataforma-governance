# Regras por issue e lacunas de refinamento

Fonte adicional: caderno de perguntas e respostas recebido em 22/10/2026. Suas respostas são **regras candidatas**, não baseline aprovada. As SPECs AUTH, PI, EXT e Portal permanecem Draft. Cada regra abaixo está colocada junto ao card que precisa dela, para que a equipe encontre contexto, decisão pendente e impacto sem sair da issue.

## PG-005 — Épico e requisitos de AUTH

**Regra candidata:** login local por CPF; conta criada via importação de CSV pela coordenação; estudante define senha no primeiro acesso; não há cadastro espontâneo.

**Alinhamento necessário nesta issue:** a base vigente prevê OIDC/OAuth2 e recuperação por token. Decidir qual identidade vale, origem oficial do usuário, conteúdo e reimportação do CSV, normalização/uniquidade de CPF, primeiro acesso e redefinição. Se houver reset manual, definir verificação de identidade, autorização e revogação de sessões. Essas decisões são de Produto/Segurança, não devem ser decididas pela implementação.

## PG-006 — SPEC-AUTH-001..004

- **Login e conta:** definir identidade, estados ativa/inativa, unicidade, cadastro e comportamento de conta vinculada a mais de uma turma.
- **Importação:** fechar campos CSV, formato, duplicatas, erros parciais, atualização e desativação de turma/aluno.
- **Senha/sessão:** resolver OIDC versus senha local e token de recuperação versus reset manual; documentar bootstrap, mudança obrigatória no acesso seguinte (se aprovada), prova de identidade, expiração, logout e revogação.
- **RBAC:** decidir matriz de coordenação acadêmica, administrador técnico, docente e estudante. O caderno sugere união de permissões quando há múltiplos papéis; definir também escopo por turma/projeto.
- **Auditoria:** o caderno propõe não registrar auditoria; Must Haves/arquitetura atuais exigem trilha em ações sensíveis. Decidir eventos, dados mínimos, retenção, acesso e política de falha antes de remover controles.
- **Critério:** manter Draft até cada conflito ter decisão versionada, critério numerado e revisão de PO, Segurança e responsáveis técnicos.

## PG-007 — Épico e requisitos de PI

**Regra candidata:** projetos podem ser contínuos ou ter data final; participantes podem mudar por semestre; todo projeto exige docente responsável; duplicidade equivalente não é bloqueada automaticamente.

**Alinhamento necessário nesta issue:** definir campos mínimos, ciclo de vida, semestre, continuidade, audiência de rascunho, publicação e como docente identifica propostas equivalentes. Decidir se a união PI/Extensão é um atributo de domínio ou apenas uma consequência de participação. A regra de contagem dupla não aprova automaticamente o literal `HYBRID` no enum `project_type`.

## PG-008 — SPEC-PI-001..004

- **Participação/equipe:** o caderno propõe pedido do aluno em janela e aprovação/negação do docente, sem convite individual; remoção pelo docente exige justificativa. O card técnico atual cita convites. Escolher uma jornada, estados, desistência, vagas/elegibilidade, notificações e transições.
- **Limite de participação:** definir como impedir, inclusive em operações simultâneas, mais de um PI e uma Extensão por estudante; atividade classificada em ambos ocupa os dois limites.
- **Bancas/avaliação:** caderno elimina bancas e agenda; a base atual descreve banca/agendamento. Escolher a jornada antes de modelar avaliações.
- **Notas:** definir escala, precisão, fórmula, pesos, arredondamento, avaliações ausentes, quem cria/finaliza/reabre e o que é visível a estudantes versus público. Caderno propõe critérios/pesos definidos pelo responsável PI e não manter histórico; reconciliar com auditoria vigente.
- **Arquivos:** definir MIME real e tamanho máximo. PDF/DOCX/imagens são os formatos citados, não limites aprovados. Separar acesso privado do projeto de publicação; decidir consentimento para fotos, menores e terceiros.
- **Critério:** não publicar campos/constraints/API até os critérios e decisões correspondentes estarem aprovados.

## PG-009 — Épico e requisitos de Extensão

**Regra candidata:** coordenação controla janelas de inscrição; docente responsável define e valida horas; avisos podem ser gerais ou específicos de projeto.

**Alinhamento necessário nesta issue:** separar edital, atividade/projeto e aviso; definir atores, calendário/fuso UTC-3, elegibilidade, vagas, inscrição duplicada, cancelamento e a relação entre inscrição e participação. Não presumir que aviso equivale a edital.

## PG-010 — SPEC-EXT-001..003

- **Prazos:** o caderno diz que fases não podem ser prorrogadas e também que docente pode ajustar prazo. Resolver a contradição; definir fuso e regra para submissão no instante limite.
- **Horas:** decidir unidade, limites, evidência aceita, correção, recusa/motivo e cálculo de total. O responsável docente valida; esclarecer se qualquer docente pode avaliar extensão e quem finaliza/corrige.
- **Histórico/auditoria:** caderno propõe não guardar histórico de horas/notas; reconciliar com controles atuais antes de modelar atualização ou exclusão.
- **Certificado:** aprovar elegibilidade, conteúdo, assinatura/QR, validade, revogação e reemissão.
- **Arquivos AWS:** retenção permanente sem backup foi sugestão, não política. Infra/Segurança deve revisar privacidade, custo e recuperação antes de fechar retenção.

## PG-011 — Épico e requisitos do Portal

**Regra candidata:** projeto só é público quando docente opta pela publicação; docente deve considerar consentimento de imagens.

**Alinhamento necessário nesta issue:** delimitar conteúdo anônimo e autenticado, dados pessoais, parceiros, imagens, autorização de menores/terceiros, quem aprova e como retirar publicação. Separar visibilidade de arquivo interno da apresentação pública.

## PG-012 — SPEC-PORTAL-001..002

Definir junto aos critérios desta SPEC: campos públicos, busca/filtros/ordenação/paginação, comportamento de rascunho, cache e retirada; fonte/aprovação de impacto social e autorização de imagem. Caderno não aprova automaticamente qualquer campo público. Só conteúdo permitido e aprovado pode entrar no catálogo.

## Dependências técnicas associadas às mesmas decisões

- **DB-004..006 / AUTH:** identidade local versus externa, CPF/CSV e matriz RBAC precisam ser decididos antes de constraints e seeds.
- **DB-007 / auditoria:** não afrouxar `public.audit_event` até decisão formal sobre histórico e eventos sensíveis.
- **DB-008..010 / PI:** fluxo convite versus solicitação, banca versus avaliação e política de nota devem preceder modelo e constraints.
- **DB-011 / arquivos:** tamanho, acesso, consentimento e retenção precedem metadados e lifecycle.
- **DB-012..013 / Extensão e horas:** o card DB-012 está fechado e é histórico; para implementação ativa, definir edital/atividade, janelas, fuso, elegibilidade e prazos antes de constraints.
- **INF-005, INF-010 e INF-011 / Cloud:** separar backups do PostgreSQL da retenção de arquivos; manter arquivos privados; não configurar lifecycle/expiração nem cache público sem política aprovada.
- **QA-008..015 / QA:** casos de teste dependem das decisões AUTH, RBAC, convites, editais, bancas, arquivos e horas; sem regra aprovada, registrar o caso como bloqueado, não inventar resultado esperado.
- **Cards Frontend/Backend:** exibir e executar somente o contrato aprovado; UI, tabela ou API não decide regra acadêmica.

## O que falta para desenvolvimento

### Atual — Sprints 0, 1 e 2

- **S0:** aprovar SPECs/contratos e resolver conflitos de AUTH, banca, auditoria, publicação e retenção; fechar o contrato AUTH referenciado mas ausente. Convenções, banco vazio e seeds sintéticas podem avançar sem inventar regras.
- **S1:** normalizar CPF/CSV; definir bootstrap, reset e papéis; concluir campos/estados de projeto, visibilidade, elegibilidade, desistência, convites versus pedidos e limite simultâneo PI/Extensão.
- **S2:** decidir banca versus avaliação; escala/pesos/arredondamento; direitos de revisão; formatos/tamanho/consentimento de arquivos; fluxo de horas, evidências, prazo/fuso/prorrogação; retenção e auditoria.

### Futuro — Sprints 3, 4, 5 e 6

- **S3:** fórmula/versionamento de rubricas; certificado; campos do catálogo; política de auditoria e retenção.
- **S4:** impacto social; relação edital-atividade-projeto; vagas, inscrição, cancelamento, prazos e fuso.
- **S5:** metas de carga; RPO/RTO; retenção/backup do banco; política separada para arquivos; restauração e rollback testados.
- **S6:** runbooks e dicionário coerentes com as migrations; critérios de homologação/go-no-go, segurança, acessibilidade, rollback e exceções aprovadas.

Até a decisão formal, anotar dúvidas na issue/SPEC que depende delas, indicar responsável pela decisão e bloquear somente os critérios afetados. Não mover a pessoa entre páginas para encontrar o refinamento de uma regra da própria issue.