---
id: SPEC-PI-004
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-PI-001]
requirements: [REQ-PI-004]
affected_systems: [backend, frontend, database, infrastructure]
legacy_aliases: [US08]
---
# Entregáveis

## Regras oficiais
- Formatos citados para entrega: PDF, DOCX e imagens. Limite de tamanho ainda não definido.
- Arquivos podem ser vistos por todos os alunos vinculados ao projeto e por usuários docentes ou administradores.
- Arquivos podem ser alterados até o início da avaliação.
- Docente responsável decide se foto será publicada, considerando menores de idade e terceiros.
- Orientação para arquivos do projeto: manter permanentemente na AWS, sem backup e sem redundância. Esta regra de arquivos não define backup do banco de dados.

## Critérios de aceite que a especificação deve completar
Validar tipo e tamanho após aprovação do limite; autorizar visualização só para atores permitidos; permitir alteração somente até o início da avaliação; publicação de foto só com autorização definida pelo docente responsável.

## Detalhes ainda não definidos
Tamanho máximo, MIME permitido, upload/substituição/exclusão, armazenamento/custos, registro da autorização da foto e retirada pública. O caderno não especifica requisitos para backup do banco neste fluxo.

## Trabalho das equipes
Backend valida upload e acesso; DB guarda somente metadados necessários; Cloud configura o armazenamento conforme a decisão oficial; Frontend explica formatos e janela de edição; QA testa formatos, limites, permissões e visibilidade de fotos.

## Cenários de aceite verificáveis
- **AC-PI-004-01 — Leitura autorizada:** aluno vinculado, docente e administrador conseguem consultar arquivo do projeto; aluno não vinculado e visitante anônimo não conseguem baixar nem obter metadados do arquivo.
- **AC-PI-004-02 — Janela de edição:** substituição de arquivo antes do início da avaliação é permitida ao ator autorizado; depois do início, alteração é negada no servidor, inclusive por chamada direta à API.
- **AC-PI-004-03 — Formatos declarados:** PDF, DOCX e imagem são os formatos de produto citados. Implementação deve validar conteúdo real além da extensão; lista MIME exata, limite e comportamento para formato inválido dependem de decisão técnica/produto antes do aceite.
- **AC-PI-004-04 — Publicação de foto:** arquivo/imagem não entra no catálogo público por estar armazenado ou visível internamente; publicação só ocorre após decisão do docente responsável, considerando menores e terceiros.
- **AC-PI-004-05 — Separação de retenção:** configuração de arquivos não cria backup nem redundância para os objetos do projeto; esta regra não altera política de backup do banco de dados.
- Remoção/substituição, quarentena, varredura e retirada de publicação precisam de contrato operacional aprovado, sem inventar prazo de retenção/limite de tamanho.

## Rastreabilidade
EPIC-PI-001; REQ-PI-004; PG-008; INF-005/010/011; [regras oficiais](../product/official-validation-decisions.md).
