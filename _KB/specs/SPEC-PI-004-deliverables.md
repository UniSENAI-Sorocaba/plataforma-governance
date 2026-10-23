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

## Objetivo
Enviar relatórios e artefatos para armazenamento autorizado, com limites e integridade. Esta SPEC permanece Draft para as regras de formato, acesso, publicação e retenção.

## Alinhamento pendente
PO/coordenação, Segurança/Privacidade e Cloud devem definir:
- Tipos MIME permitidos e tamanho máximo; PDF, DOCX e imagens citados no caderno são exemplos, não limites aprovados.
- Quem pode enviar, visualizar, substituir ou excluir arquivos e em que estado do projeto.
- Diferença entre arquivo interno do projeto e conteúdo selecionado para divulgação pública.
- Consentimento para imagens de estudantes, menores, parceiros e terceiros; registro e retirada da autorização.
- Retenção/exclusão, backup e recuperação. A proposta de armazenamento permanente sem backup na AWS não é política aprovada e não define backup do banco.

## Trabalho dependente da decisão
Após aprovação, Backend valida upload e autorização; DB mantém metadados necessários; Cloud configura armazenamento, acesso e ciclo de vida; Frontend informa formatos/limites e permite as ações autorizadas; QA testa arquivos inválidos, tamanho, permissões, retirada e recuperação prevista.

## Rastreabilidade
PG-008; REQ-PI-004; EPIC-PI-001; INF-005/010/011. Mapa cruzado: [KB de reconciliação](../product/functional-rules-reconciliation.md).