---
id: SPEC-EXT-003
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-EXT-001]
requirements: [REQ-EXT-003]
affected_systems: [backend, frontend, infrastructure]
legacy_aliases: [US11]
---
# Certificados

## Objetivo
Emitir certificado PDF com mecanismo de validação pública. Esta SPEC permanece Draft até aprovação das regras institucionais de emissão e validação.

## Alinhamento pendente
PO/coordenação de Extensão e responsável institucional por certificados devem definir:
- Elegibilidade e dados que serão exibidos no certificado.
- Quem pode emitir e quando a emissão fica disponível (por exemplo, após validação das horas).
- Assinatura, QR/hash e dados apresentados na validação pública; quais campos podem ser consultados sem login.
- Validade, revogação, correção e reemissão; histórico da ação.
- Retenção, armazenamento e política de backup/recuperação do arquivo.

## Trabalho dependente da decisão
Após aprovação, Backend gera certificado e validação conforme contrato; Frontend mostra emissão/consulta autorizada; DB mantém registros e estado de revogação; Cloud armazena o arquivo segundo política aprovada; QA verifica elegibilidade, integridade, QR/consulta, revogação e reemissão.

## Rastreabilidade
PG-010; REQ-EXT-003; EPIC-EXT-001; SPEC-EXT-002. Mapa cruzado: [KB de reconciliação](../product/functional-rules-reconciliation.md).