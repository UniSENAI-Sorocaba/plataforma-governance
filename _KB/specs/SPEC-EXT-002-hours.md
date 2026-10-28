---
id: SPEC-EXT-002
status: Draft
owner: Fellipe Raszejas
epics: [EPIC-EXT-001]
requirements: [REQ-EXT-002]
affected_systems: [backend, frontend, database]
legacy_aliases: [US10]
---
# Atividades e horas

## Regras oficiais
- Docente responsável define quantidade de horas atribuída ao projeto e somente ele valida as horas.
- Aluno pode enviar ou corrigir informações durante o período do projeto; após o encerramento dos prazos, não pode enviar nem alterar.
- Etapas têm prazos definidos e não prorrogáveis; envios atrasados não são aceitos.
- Docente responsável pode alterar nota ou horas e ajustar prazo, conforme necessário.
- Não guardar histórico de valores anteriores de horas.

## Conflito interno no caderno
Q61 declara que os prazos de cada etapa não são prorrogáveis; Q62 autoriza o docente a ajustar o prazo. Ambas as respostas são oficiais, mas não indicam precedência ou condições. Manter este detalhe pendente de esclarecimento do PO; não escolher uma interpretação por inferência.

## Detalhes ainda não definidos
Unidade/limites de horas, evidências aceitas, motivo de recusa, reenvio após recusa antes do prazo, totalização, horário-limite e condições para ajuste excepcional.

## Trabalho das equipes
Backend/DB implementam submissão, validação, cálculo e estados sem histórico anterior; Frontend apresenta status e prazo; QA testa período, recusa/correção, valores e ausência de alteração após fechamento, respeitando resolução do conflito de prazo.

## Cenários de aceite verificáveis
- **AC-EXT-002-01 — Entrada do aluno:** aluno vinculado envia ou corrige informações antes do encerramento vigente; após o prazo encerrado, nova submissão e alteração são recusadas no servidor.
- **AC-EXT-002-02 — Fuso:** comparação entre agora e prazo usa UTC-3 (Brasília), com conversão consistente entre API, banco e interface; caso de fronteira deve testar imediatamente antes e depois do instante final ainda a confirmar.
- **AC-EXT-002-03 — Validação:** somente docente responsável valida horas do aluno no projeto; outro docente e o próprio aluno não validam.
- **AC-EXT-002-04 — Alteração docente:** somente docente responsável altera quantidade de horas; a operação atualiza o valor vigente sem persistir histórico do valor anterior.
- **AC-EXT-002-05 — Conflito de prazo Q61/Q62:** até o PO esclarecer a precedência, não implementar extensão/exceção automática nem rejeitar ajuste manual como regra final; manter comportamento de prazo bloqueado para fechamento da SPEC.
- Unidade/limites, submissão exatamente no instante final, reenvio após recusa e efeito de ajuste no prazo continuam dependentes de definição. Não declarar EXT-002 pronta para produção enquanto estes critérios não tiverem decisão e teste esperado.

## Rastreabilidade
EPIC-EXT-001; REQ-EXT-002; PG-009/PG-010; SPEC-AUTH-004; [regras oficiais](../product/official-validation-decisions.md).
