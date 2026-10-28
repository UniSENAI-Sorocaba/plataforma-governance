---
title: Regras oficiais do caderno de validações
status: Review
owner: Product Owner
source: caderno-perguntas-e-respostas (1).pdf
source_date: 2026-10-22
---

# Regras oficiais do caderno de validações

O PO definiu que as respostas do Caderno de Validações de Escopo — AUTH, PI e Extensão são as decisões oficiais de produto para os temas que elas respondem. Esta transcrição passa a ser a referência versionada da KB. Em conflito com regra anterior de produto, SPEC, ADR, contrato, backlog ou guia, prevalece a resposta do caderno e os documentos afetados devem ser reconciliados por PR.

A transcrição não completa perguntas que o caderno não respondeu. Pontos sem resposta continuam pendentes de detalhe, sem autorizar cada equipe a inventar regra. O status **Review** desta transcrição significa que o conteúdo foi preparado para revisão no PR; não muda a autoridade que o PO atribuiu à fonte.

## AUTH: identidade, cadastro, sessão e permissões

- Não haverá provedor externo de identidade. O login será por CPF; no primeiro acesso, o aluno cria a própria senha e poderá alterá-la depois.
- O cadastro inicial será importado por CSV por usuários com permissão de coordenação. Não haverá autocadastro público.
- Coordenação pode inativar uma turma ou um aluno. A conta continua ativa se o aluno ainda estiver ativo em outra turma; histórico acadêmico anterior pode permanecer visível.
- Qualquer pessoa com permissão de coordenação pode manter cadastros. A mesma pessoa tem um cadastro por CPF e pode acumular permissões de mais de uma função.
- Não haverá um fluxo de login diferente por perfil; a interface exibe as funcionalidades previstas para o semestre.
- Docentes e coordenação podem redefinir a senha de outro usuário; no acesso seguinte, a pessoa precisa criar nova senha.

Detalhes ainda não especificados: formato e validação do CSV, tratamento de duplicatas e importação parcial, normalização/uniquidade do CPF, verificação de identidade no reset, revogação de sessões e conteúdo exato da matriz de permissões por ação e escopo.

## Projetos Integradores, equipes e participação

- Docentes cadastram propostas e verificam manualmente se já há proposta equivalente; a plataforma não bloqueia duplicidade.
- Um projeto pode ser contínuo ou ter data de encerramento. Integrantes e participantes podem mudar a cada semestre.
- No cadastro, o docente escolhe rascunho ou publicação. Rascunho fica disponível a alunos autenticados; publicado aparece no site público.
- Todo projeto tem ao menos um docente responsável. Ele aprova ou remove alunos; remoção exige justificativa.
- Não haverá convites individuais. Durante períodos de inscrição, alunos solicitam participação e docentes aprovam ou negam as solicitações.
- Cada aluno pode participar de um projeto de PI e um de Extensão por vez. Se um projeto de Extensão também for classificado como PI, ele ocupa os dois limites enquanto o aluno estiver vinculado.
- Somente docentes podem reabrir ou arquivar projetos.
- Horas e notas individuais não são públicas; a nota do projeto pode ser pública.

Detalhes ainda não especificados: estados e nomes formais, elegibilidade, vagas, prazos e reabertura de períodos, desistência/reenvio, notificações, critérios para equivalência manual, troca de participantes na virada do semestre e exceções administrativas.

## Avaliação e bancas

- Não haverá bancas nem gerenciamento de agenda, salas ou links.
- O número de avaliações pode variar; não há número fixo de avaliadores.
- O docente responsável pelo projeto é o único que valida horas. Em Extensão, qualquer docente pode adicionar uma avaliação.
- Alunos podem avaliar outros alunos. No PI, o docente responsável define critérios e pesos; a coordenação atribui qual aluno avalia cada projeto e em qual data.
- A nota é ponderada pelos critérios e pesos definidos pelo docente responsável pelo PI.
- Somente o docente responsável pelo PI pode finalizar, reabrir ou corrigir a avaliação.
- A nota do projeto pode ser pública. Avaliações individuais feitas por docente são visíveis somente aos alunos daquele projeto.
- Não é necessário manter histórico de valores anteriores de notas.

Detalhes ainda não especificados: escala, precisão e arredondamento, ausência de avaliação, estados da avaliação, prazos, motivo de correção, autorização de avaliadores para Extensão, e como a atribuição de avaliadores alunos se relaciona com avaliações docentes.

## Editais, avisos e horas de Extensão

- Docentes e coordenação podem publicar avisos gerais ou destinados a um projeto. Aviso não deve ser presumido como edital.
- Coordenação define as datas dos períodos; elas podem ser alteradas se necessário. O fuso é UTC-3 (horário de Brasília).
- Após aprovado no projeto, somente o docente pode alterar a inscrição ou participação do aluno.
- O docente responsável define as horas do projeto e é quem valida as horas.
- O aluno pode enviar ou corrigir informações durante o período do projeto; depois do encerramento dos prazos, não pode enviar ou alterar informações.
- As etapas têm prazos definidos e não prorrogáveis.
- O docente responsável pode alterar nota ou horas e ajustar o prazo, conforme necessário.
- Não é necessário guardar histórico dos valores anteriores de horas.

**Conflito interno no próprio caderno:** a resposta 61 diz que os prazos não são prorrogáveis; a resposta 62 diz que o docente pode ajustar o prazo. Ambas foram registradas; o material não define como conciliá-las. Não escolher uma interpretação até o PO esclarecer este ponto específico.

Detalhes ainda não especificados: relação entre edital, aviso, atividade e projeto; elegibilidade, vagas, inscrições duplicadas, cancelamento, unidade/limites de horas, motivo de recusa e regra de submissão no instante final.

## Entregáveis e publicação

- Formatos mencionados para entregas: PDF, DOCX e imagem. O limite de tamanho ainda precisa ser definido.
- Arquivos podem ser vistos por alunos vinculados ao projeto e por docentes ou administradores.
- Docente responsável decide se fotos podem ser publicadas, considerando menores de idade e terceiros.
- Arquivos podem ser alterados até o início da avaliação. Há períodos para inscrição, encerramento de edição e início das avaliações.
- A orientação registrada é manter os arquivos permanentemente na AWS, sem backup e sem redundância. Essa regra se refere aos arquivos do projeto, não ao backup do banco de dados.
- Um projeto aparece no site público quando o docente seleciona a opção de publicação.

Detalhes ainda não especificados: limite de tamanho, MIME/validação, fluxo de autorização para imagens, dados exatos do catálogo e processo/tempo para retirada de publicação.

## Auditoria

A resposta 65 define que não haverá registros de auditoria. Não manter histórico de alterações de notas ou horas também está definido acima. Regras anteriores da KB que exigem trilhas de auditoria para essas decisões de negócio precisam ser reconciliadas. A implementação deve evitar registrar segredos e credenciais em logs técnicos; isso não cria uma trilha de auditoria de negócio.

## Rastreabilidade

As respostas oficiais devem ser transpostas às SPECs, requisitos, contratos, ADRs e cards afetados, mantendo os IDs. Cada documento deve indicar quais regras do caderno cobre, os critérios verificáveis, dependências de equipe e detalhes ainda não especificados. SPECs podem continuar em Draft enquanto esses detalhes, critérios e revisões estiverem incompletos; isso não torna as respostas do caderno não oficiais.
