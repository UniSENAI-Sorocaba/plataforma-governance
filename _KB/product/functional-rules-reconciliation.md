# Regras por issue e lacunas de refinamento

Fonte oficial: [Regras oficiais do caderno de validações](official-validation-decisions.md), transcritas do Caderno de Validações de Escopo — AUTH, PI e Extensão, recebido em 22/10/2026. O PO definiu as respostas do caderno como decisões oficiais para os temas cobertos. Não as chamar de propostas nem pedir nova aprovação de regra já respondida. Quando um documento anterior divergir, registrar a incompatibilidade e atualizá-lo por PR.

## Como separar decisão e desenvolvimento

1. **Regra respondida pelo caderno:** é oficial. O PO mantém rastreabilidade na SPEC, requisito e issue; arquitetura e equipes ajustam contrato, dados, telas e testes para obedecê-la.
2. **Detalhe que o caderno não respondeu:** permanece lacuna de produto ou de especificação. O responsável indicado deve propor alternativas e obter decisão sem a equipe técnica inventar regra.
3. **Trabalho de implementação:** depois de registrar a regra, as equipes projetam, implementam, integram, testam e documentam a solução de sua responsabilidade.

Uma resposta oficial pode exigir revisão de outra documentação e não transforma uma SPEC inteira em pronta. Bloquear somente critérios dependentes de lacunas; continuar trabalho independente.

## AUTH — PG-005 / PG-006

**Decisões oficiais:** login local por CPF, sem provedor externo; cadastro inicial por CSV da coordenação e sem autocadastro; coordenação mantém e inativa cadastros; uma conta por CPF pode acumular permissões; docentes e coordenação podem redefinir senha de outro usuário e o usuário cria nova senha no próximo acesso.

**Reconciliar:** remover dos artefatos de produto o fluxo de OIDC/OAuth2 e recuperação por token como comportamento do MVP. Atualizar ADRs, contratos, Must Haves e cards que descrevem o fluxo incompatível. A decisão não especifica normalização de CPF, esquema/erros/reimportação do CSV, verificação para reset, revogação de sessão nem matriz completa de ações/escopos; esses detalhes continuam em aberto. Não alterar controles de proteção de credenciais.

**Equipes após registro:** Backend/DB implementam a identidade e o provisionamento definidos; Frontend apresenta primeiro acesso, troca/reset e funcionalidades do semestre; QA verifica login, CSV, conta ativa/inativa, permissões e falhas.

## PI — PG-007 / PG-008

**Decisões oficiais:** propostas equivalentes não são bloqueadas automaticamente; projeto pode ser contínuo ou ter data final; rascunho é visível a alunos autenticados e publicado aparece no site público; docente responsável aprova/remove participantes e justifica remoção; não há convites individuais, alunos solicitam participação em períodos de inscrição; estudante pode participar de um PI e uma Extensão por vez, e um projeto contado nos dois tipos ocupa ambos; docente pode reabrir/arquivar; não haverá banca nem agendamento.

**BE-007, “transições”:** implementar mudanças válidas de estado da proposta/projeto, com ator e condições de autorização. O caderno define pelo menos rascunho/publicado, publicação pública por escolha do docente, continuidade ou data de encerramento, e reabertura/arquivamento por docente. Não define todos os estados intermediários nem todas as transições de edição/submissão; explicitar a tabela de estado atual → ação → ator → condição → resultado na SPEC/issue antes de criar estados novos.

**BE-008:** o fluxo oficial é solicitação de participação pelo aluno durante a janela e aprovação/negação pelo docente, não convite com aceite/recusa. Atualizar BE-008 e referências de DB/Frontend/QA. Permanecem por especificar janela e encerramento, elegibilidade, vagas, desistência/reenvio, notificações, concorrência e exceções. O aceite de BE-008 deve testar solicitação e decisão docente, idempotência/concorrência e limite de participação conforme essas regras.

**Bancas e avaliações:** remover banca, agenda, sala e link. Avaliações individuais podem variar em número; no PI, docente responsável define critérios/pesos e finaliza/reabre/corrige; coordenação atribui avaliadores alunos e data; alunos podem avaliar outros alunos; qualquer docente pode adicionar avaliação de Extensão. A nota do projeto pode ser pública; notas individuais não. Não manter histórico de valores anteriores de nota. Escala, arredondamento, ausência e outros pormenores não definidos permanecem em aberto.

**Equipes após registro:** DB/Backend modelam estados e limites aprovados; Frontend apresenta rascunho/publicação e pedido de participação; QA valida autorização, transições, visibilidade, simultaneidade e limites.

## Extensão — PG-009 / PG-010

**Decisões oficiais:** avisos podem ser gerais ou destinados a um projeto; coordenação gerencia períodos no fuso UTC-3; períodos podem ser alterados; docente responsável define/valida horas; depois de aprovado no projeto, somente docente altera participação; aluno pode corrigir informação até o encerramento; não se aceitam envios atrasados; não manter histórico de horas.

**Conflito interno do caderno:** Q61 diz que cada etapa tem prazo não prorrogável; Q62 diz que o docente pode ajustar prazo. Registrar ambas como fonte oficial e deixar a regra de precedência pendente de esclarecimento do PO, sem escolher uma por inferência.

**Ainda não especificado:** relação entre aviso, edital, atividade e projeto; elegibilidade, vagas, duplicidade, cancelamento, unidade/limites de horas, motivo de recusa, total e regra no instante-limite. Certificados não recebem regras completas no caderno.

**Equipes após registro:** Backend/DB implementam inscrições, horas e regras transacionais; Frontend apresenta oportunidades e estados; Cloud aplica a política de arquivos; QA verifica janelas, cálculo, permissões, evidências e limites aprovados.

## Entregáveis e Portal

**Decisões oficiais:** formatos citados são PDF, DOCX e imagens; alunos vinculados, docentes e administradores podem ver arquivos do projeto; docente responsável decide se foto pode ser publicada, considerando menores e terceiros; arquivo pode ser alterado até o início da avaliação; orientação para arquivos do projeto é retenção permanente na AWS, sem backup ou redundância; projeto é público se docente marcar publicação.

**Ainda não especificado:** tamanho máximo, MIME validado, autorização/registro de imagem, campos exatos públicos, filtros/ordem/paginação/cache e retirada. Não generalizar a regra de backup de arquivos para o banco de dados.

## Auditoria e histórico

O caderno determina não manter registros de auditoria nem histórico anterior de notas/horas. Reconciliar SPECs, Must Haves, esquema DB e cards para remover o requisito de trilha de negócio incompatível. Manter controles para não expor senhas, tokens ou segredos em logs técnicos; log operacional sem credenciais não deve ser confundido com trilha de auditoria de negócio.

## Checklist de rastreabilidade

- Registrar a decisão oficial na SPEC/REQ/EPIC relevante, preservando IDs e link para a transcrição.
- Substituir requisitos e critérios de aceite incompatíveis; atualizar ADRs/contratos e cards dependentes.
- Separar lacunas reais de comportamento já decidido pelo caderno.
- Conferir status de execução no GitHub Project, issues e PRs; o texto de um escopo por equipe não comprova entrega.
