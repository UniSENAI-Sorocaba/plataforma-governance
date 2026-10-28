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

## Rastreabilidade
EPIC-PI-001; REQ-PI-004; PG-008; INF-005/010/011; [regras oficiais](../product/official-validation-decisions.md).
