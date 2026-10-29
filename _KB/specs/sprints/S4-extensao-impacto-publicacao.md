---
kind: sprint-specification-package
status: Draft
owner: Fellipe Raszejas
approval: []
sprint: S4
epics: [EPIC-EXT-001, EPIC-PORTAL-001]
canonical_specs: [SPEC-EXT-001, SPEC-EXT-002, SPEC-PORTAL-001, SPEC-PORTAL-002]
source_of_truth: ../../product/official-validation-decisions.md
---

# Sprint 4 — Extensão, horas e impacto publicado

## Contexto

Este pacote organiza os fluxos de Extensão e publicação de impacto previstos para S4. Não supõe que aviso, edital e inscrição em atividade sejam a mesma coisa. Onde o Caderno não detalha o comportamento, a decisão fica registrada como pendência de Produto.

## Resultado esperado

Estudantes encontram avisos e atividades autorizados, enviam ou corrigem suas informações dentro das regras aprovadas e consultam o estado vigente. Docente responsável define e valida horas. Conteúdo de impacto só é exibido publicamente segundo uma regra de publicação que o PO precisa aprovar.

## Atores e escopo

- Coordenação: mantém períodos e pode publicar avisos gerais ou destinados a um projeto.
- Docente: pode publicar avisos gerais ou destinados a um projeto; docente responsável define/valida horas e é o único que altera a participação de aluno já aprovado.
- Estudante: solicita participação quando houver janela aplicável e envia/corrige informações permitidas até o prazo vigente.
- Visitante: só consulta projetos e conteúdo efetivamente publicado.
- Fora do escopo: recurso à coordenação de decisão de horas, histórico de valores anteriores, relatório público de horas individuais.

## Regras de produto confirmadas

1. Aviso pode ser geral ou dirigido a um projeto; não presumir que todo aviso seja um edital.
2. Coordenação define períodos no fuso UTC-3 (Brasília). As respostas do Caderno registram tanto prazos não prorrogáveis (Q61) quanto a possibilidade de docente ajustar prazo (Q62); a precedência não foi esclarecida.
3. Somente o docente responsável define/valida as horas. Depois de aprovado no projeto, somente docente pode alterar a participação do aluno.
4. O aluno pode enviar/corrigir informações até o encerramento do prazo; depois dele, não pode enviar nem alterar.
5. Não se mantém valor anterior de horas. A atualização substitui o valor vigente, sem trilha de auditoria de negócio.
6. Horas individuais não são públicas. Publicação de projeto requer opção do docente responsável.
7. O Caderno não define métricas, fontes nem método de cálculo de impacto comunitário.

## Critérios de aceite propostos

- AC-S4-01 — Aviso geral: ator autorizado cria aviso geral e este não é tratado automaticamente como janela de inscrição ou edital.
- AC-S4-02 — Aviso de projeto: aviso dirigido a projeto só fica associado ao projeto escolhido; a API e a interface não o apresentam como aviso geral.
- AC-S4-03 — Períodos: sistema apresenta instantes com conversão consistente para UTC-3. Quem pode criar ou alterar cada período deve seguir a matriz de papel aprovada.
- AC-S4-04 — Atividade do aluno: envio/correção antes do prazo vigente é permitido ao ator autorizado; depois do prazo, servidor nega a alteração. O caso do instante exato final depende da decisão pendente.
- AC-S4-05 — Decisão de horas: somente docente responsável valida; outro docente, coordenação e estudante não alteram essa decisão.
- AC-S4-06 — Valor vigente: alteração autorizada de horas substitui o valor corrente e não mantém valor passado.
- AC-S4-07 — Privacidade: respostas públicas nunca incluem horas individuais nem dados de atividade do aluno.
- AC-S4-08 — Impacto sem publicação implícita: métrica sem definição/aprovação não é apresentada como indicador oficial. O catálogo não deve expor origem interna, dado pessoal ou conteúdo não aprovado.
- AC-S4-09 — A retirada de projeto/impacto publicado deve impedir novas consultas públicas; o prazo de remoção em cache fica pendente e precisa ser definido antes do aceite final.
- AC-S4-10 — Inscrição em atividade de Extensão (EXT-05): não assumir que a inscrição na atividade equivale à solicitação de participação em projeto. O vínculo entre esses dois fluxos deve ser aprovado e documentado antes da integração.

## Contratos e dependências de equipe

- Backend: BE-014 para horas, BE-019 para impacto e EXT-05-BE para inscrição em atividade.
- Database: DB-013/015 e EXT-05-DB.
- Frontend: FE-012/016 e EXT-05-FE.
- Qualidade: QA-015, QA-019/022 e EXT-05-QA.
- Cloud: armazenamento/publicação e cache conforme INF-010/011/012.
- Contratos a publicar: avisos/inscrição/atividade/horas e publicação de impacto em OpenAPI 3.1, com exemplos de sucesso, validação, autorização e privacidade.
- Referências: SPEC-EXT-001/002, SPEC-PORTAL-001/002; PG-009/010/011/012; DB-013/015; BE-014/019.

## Decisões pendentes do PO

1. Resolver Q61/Q62: condições e autoridade para alterar prazos sem contrariar a resposta de que etapas são não prorrogáveis.
2. Definir entidade e relação entre aviso, edital, atividade, inscrição e projeto; política de duplicidade, elegibilidade, vagas e cancelamento.
3. Definir unidade/limites de horas, evidências aceitas, motivo de recusa, reenvio, totalização e fronteira do prazo.
4. Definir indicadores de impacto, origem, período, cálculo, revisão, aprovação e retirada; proteger beneficiários e parceiros.
5. Definir campos públicos do impacto, cache e prazo de expurgo.
6. Não escrever estes detalhes como regra final antes de Produto decidir.

## Rastreabilidade

Caderno de Validações; EPIC-EXT-001, EPIC-PORTAL-001; SPEC-EXT-001/002, SPEC-PORTAL-001/002; BE-014/019, EXT-05-BE; DB-013/015; FE-012/016; QA-015/019/022; INF-010/011/012.

## Histórico

- Draft preparado para validação do PO; não aprovado e não normativo até revisão.
