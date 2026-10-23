Caderno de perguntas e respostas (recebido em 22/10/2026) foi incorporado como fonte de refinamento funcional. Seu conteúdo é uma proposta de regras, ainda não aprovada como baseline; as SPECs AUTH/PI/EXT/PORTAL permanecem Draft. Não substituir ADRs, Must Haves ou critérios aprovados sem decisão registrada pelo Product Owner e revisores definidos.

# Regras funcionais candidatas e lacunas de decisão

## Como interpretar

- **Candidato do caderno:** resposta que ajuda a especificar comportamento e orientar refinamento.
- **Conflito:** diverge de uma decisão, SPEC ou Must Have já vigente; requer decisão explícita, versionada e revisão dos responsáveis.
- **Pendente:** falta dado verificável para implementar ou testar; não inferir valor, papel ou fluxo.
- **Implementação:** só deve tratar uma regra como contrato depois de aprovada na SPEC correspondente.

## Regras candidatas consolidadas

### Identidade, matrícula e acesso

- Login local por CPF e senha; não haveria provedor de identidade externo. O primeiro acesso cria a senha e a pessoa pode alterá-la depois.
- Coordenação com permissão importa alunos por CSV com nome, CPF, curso/turma e campos acordados. Não há cadastro público espontâneo.
- Um CPF identifica uma conta. A conta pode estar ativa ou inativa; múltiplos papéis acumulam permissões.
- Coordenação pode desativar aluno ou turma. Se a pessoa ainda pertencer a outra turma ativa, sua conta permanece ativa; histórico de curso concluído pode continuar visível.
- Coordenação administra matrículas e permissões. Docente cria projetos, aprova/remove participantes e valida horas de participantes dos projetos sob sua responsabilidade. Estudante registra/edita atividades até avaliação/validação. Docentes co-responsáveis têm permissões iguais no projeto.
- Uma experiência de login; após autenticação, a interface apresenta recursos da etapa/semestre vigente.
- Redefinição manual por docente ou coordenação; no próximo acesso, a pessoa precisa definir nova senha.

### Projetos integradores e equipes

- Docente propõe projeto e pode consultar propostas equivalentes; duplicatas não são bloqueadas automaticamente.
- Projeto pode ser contínuo ou ter data final; participantes podem mudar por semestre.
- Projeto tem rascunho/publicado. Rascunho é visível a estudantes autenticados; publicado pode aparecer no site público.
- Todo projeto tem ao menos um docente responsável. Estudante solicita participação dentro de janela definida; docente aprova ou nega. Não há convite individual.
- Docente pode remover participante, registrando justificativa. Após aprovação do aluno, só docente altera sua participação.
- Cada pessoa participa de no máximo um PI e uma Extensão ao mesmo tempo. Uma extensão classificada como PI conta nos dois limites enquanto a pessoa estiver nela.
- Só docente pode reabrir/arquivar projeto. Horas e notas individuais não são públicas; nota geral do projeto pode ser pública.

### Avisos, publicação e extensão

- Avisos podem ser gerais ou específicos de projeto; docentes e coordenação podem publicar.
- Coordenação define janelas de inscrição e pode alterar datas; fuso indicado: UTC-3 (Brasília).
- O docente escolhe se o projeto será público. O caderno pede cuidado/consentimento para imagens, especialmente quando aparecem menores ou terceiros.

### Avaliações e notas

- A quantidade de avaliações pode variar; não se impõe quantidade fixa.
- Docente responsável valida horas; qualquer docente pode adicionar avaliação de extensão; estudantes podem avaliar colegas.
- No PI, docente responsável define critérios e pesos; coordenação atribui qual estudante avalia qual projeto e em qual data.
- Docente pode criar formulário. A nota é ponderada pelos critérios/pesos definidos pelo responsável PI.
- Caderno propõe não usar bancas nem agendar sala/link. Responsável PI finaliza, reabre ou corrige avaliação; avaliação individual docente fica visível a estudantes do projeto. Nota geral do projeto pode ser pública.
- Caderno propõe não manter histórico anterior de nota/hora.

### Arquivos e horas

- Formatos citados: PDF, DOCX e imagens; limite de tamanho não definido.
- Estudantes do projeto, docentes e administradores podem ver arquivos. Edição permitida até início da avaliação; inscrição, edição de arquivo e avaliação têm períodos distintos.
- Professor responsável define horas concedidas e valida horas. Estudante pode enviar/corrigir informação durante o período do projeto; após prazo não pode alterar.
- Caderno afirma simultaneamente que prazo de fases não pode ser prorrogado e que responsável pode ajustar prazo. Contradição a resolver.
- Retenção permanente dos arquivos em AWS sem backup/redundância foi sugerida, mas depende de aprovação de Infra/Segurança e política institucional.

## Conflitos que bloqueiam promoção à baseline

1. **AUTH:** login local CPF versus OIDC/OAuth2 aprovado na base; redefinição manual versus fluxo de token previsto em cards e contrato. Escolher identidade, bootstrap, recuperação, prova de identidade e sessão.
2. **Papéis:** coordenação acadêmica, administrador técnico, docente e aluno precisam de matriz explícita; esclarecer papéis acumulados e escopo de autorização por projeto/turma.
3. **PI / avaliações:** caderno elimina bancas e agenda; baseline atual prevê banca, agendamento e atribuição docente. Decidir se a jornada será substituída, limitada ou mantida.
4. **Auditoria e histórico:** caderno diz que não haverá histórico de nota/hora nem auditoria; arquitetura e Must Haves atuais exigem rastreabilidade para ações sensíveis. Decisão de Produto, Segurança e Banco é obrigatória antes de remover controles.
5. **Publicação e imagem:** delimitar dados públicos, consentimento, tratamento de menores/terceiros, aprovação e retirada do conteúdo.
6. **Arquivos:** retenção permanente sem cópia de recuperação precisa de análise de risco, privacidade, custo e recuperação antes de virar regra operacional.
7. **Prazos de Extensão:** esclarecer se docente pode prorrogar; definir fuso, momentos de corte e comportamento de submissão no limite.
8. **Código HYBRID:** a regra de uma atividade de Extensão contar simultaneamente para limites de PI e Extensão não aprova, por si só, o valor literal `HYBRID` no enum `project_type`. Manter o enum em aberto até decisão formal.
9. **Edital versus aviso:** não assumir que aviso geral/de projeto é a mesma entidade do edital de Extensão.

## Informação ainda necessária — trabalho atual (Sprints 0, 1 e 2)

- **S0 / Produto e governança:** resolver os conflitos acima; aprovar SPECs com critérios testáveis, responsável e fonte; fechar contrato AUTH referenciado mas ausente; delimitar campos públicos; definir fronteiras de PI/Extensão/Portal; decidir auditoria mínima. Sem isso, S0 pode documentar Draft e perguntas, mas não declarar regras aprovadas.
- **S0 / Banco:** convenções, IDs, timestamps, schemas, migrations repetíveis e banco vazio podem avançar; seeds devem ser sintéticas e não inventar usuários, papéis ou regras não aprovados. Modelo lógico de domínio só fixa campos/constraints depois de requisitos aceitos.
- **S1 / AUTH:** normalização/validação CPF e unicidade; campos e template CSV; tratamento de erros, duplicatas, reimportação parcial e atualização; bootstrap de senha; autenticação e sessão; processo seguro para reset manual ou token; revogação de sessões; escopo e concessão/revogação de papéis; distinção coordenação/admin.
- **S1 / PI:** campos mínimos e semântica de status/semestre; continuidade e troca de participantes; quem vê rascunho; elegibilidade e vagas; regra atômica de limite simultâneo PI/Extensão e híbrido; aluno cancelar/desistir/editar pedido; aprovação/negação e notificações; busca manual de proposta equivalente.
- **S2 / avaliação, arquivos e horas:** resolver banca versus avaliação avulsa; escala, precisão, pesos, arredondamento e avaliações ausentes; quem finaliza avaliação de extensão; prazos e fuso; limite/tipos MIME e varredura de arquivos; consentimento e visibilidade por campo; total de horas e evidência necessária; motivo e fluxo de correção; política de histórico e auditoria.
- **S2 / API e dados:** contratos de transição de estados, constraints e tratamento de concorrência; identificador de atividade/edital para inscrição; retenção e exclusão lógica/física; seeds que cubram perfis/estados aprovados sem PII real. Registrar cada bloqueio na SPEC/card dono.

## Lacunas para Sprints 3, 4, 5 e 6

- **S3 — rubricas/notas, auditoria, certificados e catálogo:** escala/fórmula/arredondamento e versionamento de rubricas; regras de certificação, elegibilidade, assinatura, QR, revogação/reemissão e conteúdo; campos permitidos no catálogo, filtros/ordem/paginação/cache e retirada; política final de eventos, retenção, acesso e imutabilidade de auditoria.
- **S4 — impacto e inscrições de extensão:** origem e aprovação do dado de impacto; janela/fuso, elegibilidade, capacidade/vagas, duplicidade, cancelamento e mudança de prazo; relação formal entre edital, projeto e atividade; avisos e certificado associados.
- **S5 — performance, backup e conexões:** metas quantitativas, perfil/carga/dataset de teste, limites de instância/pool; RPO/RTO, frequência e retenção de backup do banco; teste de restauração e acessos; política de backup/replicação de arquivos AWS (o caderno sugeriu ausência, ainda não aprovada); critérios de rollback e correção de findings.
- **S6 — documentação e release:** runbook validado por alguém além do autor; dicionário de dados alinhado às migrations; critérios de go/no-go, smoke/regressão, acessibilidade/segurança, responsáveis e rollback; aprovação formal de exceções, campos públicos e retenção antes de liberar.

## Ação de governança

Atualizar as SPECs correspondentes e registrar decisões por ADR/decision log após validação do PO, responsáveis técnicos e Segurança/Infra onde aplicável. Até então, marcar as regras derivadas do caderno como candidatas, manter conflito visível e não encerrar critérios de aceite dependentes como se estivessem aprovados. Reavaliar os PDFs por equipe após aprovação; esta versão dos guias cobre apenas cards S0-S2.