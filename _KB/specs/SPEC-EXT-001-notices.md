---
id: SPEC-EXT-001
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-EXT-001]
requirements: [REQ-EXT-001]
affected_systems: [backend, frontend, database]
legacy_aliases: [US09]
---
# Editais e inscrições

## Objetivo
Publicar editais e permitir inscrições conforme janela e elegibilidade. Esta SPEC permanece Draft; a proposta do caderno não deve ser tratada como regra aprovada.

## Alinhamento pendente
PO/coordenação de Extensão e docentes responsáveis devem definir:
- Se edital é entidade própria e sua relação com atividade, projeto e participação.
- Diferença entre edital, aviso geral e aviso de projeto; quem cria, publica e encerra cada tipo.
- Quem controla a janela, fuso de negócio e regra de envio no instante limite.
- Elegibilidade, capacidade/vagas, duplicidade, cancelamento e quando inscrição vira participação confirmada.
- Como esta jornada se relaciona aos limites PI/Extensão da SPEC-PI-001.

## Trabalho dependente da decisão
Após aprovação, Backend/DB implementam entidades, relações, estados e validações; Frontend apresenta edital/aviso e estado da inscrição; QA verifica elegibilidade, janelas, vagas, duplicidade, cancelamento e fuso.

## Rastreabilidade
PG-009/PG-010; REQ-EXT-001; EPIC-EXT-001; SPEC-PI-001. Mapa cruzado: [KB de reconciliação](../product/functional-rules-reconciliation.md).