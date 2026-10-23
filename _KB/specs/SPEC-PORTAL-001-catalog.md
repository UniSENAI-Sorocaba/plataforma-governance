---
id: SPEC-PORTAL-001
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-PORTAL-001]
requirements: [REQ-PORTAL-001]
affected_systems: [backend, frontend, database, infrastructure]
legacy_aliases: [US12]
---
# Catálogo público

## Objetivo
Listar e buscar projetos aprovados para publicação sem expor dados privados. Esta SPEC permanece Draft até aprovação do conteúdo público e do ciclo de retirada.

## Alinhamento pendente
PO/coordenação e Segurança/Privacidade devem aprovar:
- Quais campos podem ser acessados anonimamente e quais exigem autenticação; não presumir que campos do projeto podem ir ao catálogo.
- Quem aprova a publicação e a retirada e quais estados de rascunho/publicado/retirado existem.
- Busca, filtros, ordenação, paginação e comportamento para resultado vazio.
- Como cache e indexação respeitam alteração de visibilidade ou retirada, em quanto tempo o conteúdo deixa de estar público.
- Separação entre avisos, editais de Extensão e projetos no catálogo.

## Trabalho dependente da decisão
Após aprovação, Backend/DB expõem apenas a projeção pública permitida; Frontend implementa busca e filtros acordados; Cloud configura cache compatível com retirada; QA verifica acesso anônimo, campos, filtros, paginação, cache e retirada.

## Rastreabilidade
PG-011/PG-012; REQ-PORTAL-001; EPIC-PORTAL-001; INF-010/011. Mapa cruzado: [KB de reconciliação](../product/functional-rules-reconciliation.md).