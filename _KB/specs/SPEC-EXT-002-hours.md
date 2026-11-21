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
Decisão MVP para reconciliar Q61/Q62: Q61 vale para participantes e submissões — não há extensão automática, e nenhuma submissão é aceita após `ends_at`. Q62 vale como exceção administrativa explícita: somente a coordenação pode alterar `ends_at` para um instante futuro, inclusive reabrir um período encerrado; `starts_at` e o termo são imutáveis. A alteração não retroage nem revalida submissões recusadas ou expiradas.

## Detalhes ainda não definidos
Unidade/limites de horas, evidências aceitas, motivo de recusa, reenvio após recusa antes do prazo, totalização, horário-limite e condições para ajuste excepcional.

## Trabalho das equipes
Backend/DB implementam submissão, validação, cálculo e estados sem histórico anterior; Frontend apresenta status e prazo; QA testa período, recusa/correção, valores e ausência de alteração após fechamento, respeitando resolução do conflito de prazo.

## Cenários de aceite verificáveis
- **AC-EXT-002-01 — Entrada do aluno:** aluno vinculado envia ou corrige informações antes do encerramento vigente; após o prazo encerrado, nova submissão e alteração são recusadas no servidor.
- **AC-EXT-002-02 — Fuso:** comparação entre agora e prazo usa UTC-3 (Brasília), com conversão consistente entre API, banco e interface; caso de fronteira deve testar imediatamente antes e depois do instante final ainda a confirmar.
- **AC-EXT-002-03 — Validação:** somente docente responsável valida horas do aluno no projeto; outro docente e o próprio aluno não validam.
- **AC-EXT-002-04 — Alteração docente:** somente docente responsável altera quantidade de horas; a operação atualiza o valor vigente sem persistir histórico do valor anterior.
- **AC-EXT-002-05 — Regra de prazo Q61/Q62:** submissões respeitam a fronteira exclusiva `now < ends_at`; apenas coordenação pode ajustar `ends_at` para o futuro. Não existe extensão automática, alteração de `starts_at` ou revalidação retroativa.
- Unidade/limites, submissão exatamente no instante final, reenvio após recusa e efeito de ajuste no prazo continuam dependentes de definição. Não declarar EXT-002 pronta para produção enquanto estes critérios não tiverem decisão e teste esperado.

## Rastreabilidade
EPIC-EXT-001; REQ-EXT-002; PG-009/PG-010; SPEC-AUTH-004; [regras oficiais](../product/official-validation-decisions.md).
