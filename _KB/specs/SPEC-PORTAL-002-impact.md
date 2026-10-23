---
id: SPEC-PORTAL-002
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-PORTAL-001]
requirements: [REQ-PORTAL-002]
affected_systems: [backend, frontend, database]
legacy_aliases: [US13]
---
# Impacto comunitário

## Objetivo
Publicar impacto e prestação social apenas após aprovação e com origem rastreável. Esta SPEC permanece Draft; o caderno não aprova automaticamente campos públicos.

## Alinhamento pendente
PO/coordenação, docentes e Segurança/Privacidade devem definir:
- Indicadores e campos de impacto (incluindo fonte, período, método de cálculo e responsável pela validação).
- Se contagens/resumos são informados por docente, calculados pela plataforma ou importados; como corrigir dado publicado.
- Quais informações são públicas e como evitar exposição de pessoas beneficiárias, parceiros ou dados pessoais.
- Aprovação, atualização e retirada do conteúdo; se a decisão também requer autorização de imagens ou relatos.
- Evidência de origem e histórico de alterações necessários para prestação social.

## Trabalho dependente da decisão
Após aprovação, Backend/DB implementam campos, origem e validação; Frontend apresenta somente os indicadores aprovados; QA verifica fonte, consistência, permissões e retirada. Qualquer cálculo deve ter regra e exemplos de validação aprovados.

## Rastreabilidade
PG-011/PG-012; REQ-PORTAL-002; EPIC-PORTAL-001; SPEC-PORTAL-001. Mapa cruzado: [KB de reconciliação](../product/functional-rules-reconciliation.md).