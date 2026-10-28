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

## Escopo
O Caderno de Validações não define regras completas de emissão ou validação de certificados. Não inferir critérios de elegibilidade, assinatura, QR, validade ou revogação a partir das regras de horas.

## Detalhes pendentes
Responsável institucional, critérios de elegibilidade, campos do certificado, evento que habilita emissão, assinatura/QR, consulta pública, validade, correção/revogação/reemissão, retenção e backup.

## Trabalho das equipes
Depois das regras aprovadas, Backend gera certificado e validação; Frontend apresenta emissão/consulta autorizada; DB registra estado necessário; Cloud armazena conforme política; QA valida integridade e permissões.

## Rastreabilidade
EPIC-EXT-001; REQ-EXT-003; PG-010; SPEC-EXT-002; [regras oficiais](../product/official-validation-decisions.md).
