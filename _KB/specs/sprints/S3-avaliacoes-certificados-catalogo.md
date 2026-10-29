---
kind: sprint-specification-package
status: Draft
owner: Fellipe Raszejas
approval: []
sprint: S3
epics: [EPIC-PI-001, EPIC-EXT-001, EPIC-PORTAL-001]
canonical_specs: [SPEC-PI-002, SPEC-PI-003, SPEC-EXT-003, SPEC-PORTAL-001]
source_of_truth: ../product/official-validation-decisions.md
---

# Sprint 3 — Avaliações, certificados e catálogo público

## Contexto

Este pacote organiza as decisões de produto necessárias para as entregas S3 de avaliações/notas, certificados e catálogo. Ele não substitui as SPECs por domínio nem define endpoints ou tabelas. As regras já respondidas pelo Caderno são obrigatórias; lacunas continuam como decisões do PO.

## Resultado esperado

O estudante, docente e visitante veem e executam somente os fluxos de avaliação e publicação que lhes cabem; o catálogo público respeita a opção de publicação do docente; certificados só entram em desenvolvimento após o PO definir seu ciclo de vida.

## Atores e escopo

- Docente responsável pelo PI: define critérios e pesos, e finaliza, reabre ou corrige avaliações do PI.
- Coordenação: atribui estudante avaliador e data para avaliações entre alunos.
- Docente: qualquer docente pode adicionar avaliação a projeto de Extensão.
- Estudante: pode avaliar outro estudante quando atribuído; pode consultar somente informações autorizadas.
- Visitante: consulta projetos e conteúdo que estejam efetivamente publicados.
- Fora do escopo: banca, agenda, sala, link, conflito de horários, número fixo de avaliações e histórico anterior de notas.

## Regras de produto confirmadas

1. Não haverá banca nem gerenciamento de agenda, sala ou link.
2. A quantidade de avaliações é variável.
3. Alunos podem avaliar outros alunos; no PI, o responsável define critérios e pesos e a coordenação atribui avaliador e data.
4. Somente o docente responsável pelo PI pode finalizar, reabrir ou corrigir avaliação de PI.
5. Qualquer docente pode adicionar avaliação de Extensão.
6. A nota do projeto pode ser pública; notas e avaliações individuais e horas individuais não são públicas.
7. Não se mantém o valor anterior de notas. Atualização substitui o valor vigente; o caderno não autoriza trilha de auditoria de negócio.
8. Projeto publicado aparece no catálogo; rascunho fica disponível apenas a alunos autenticados.
9. Arquivo interno não se torna público automaticamente. Foto só pode ser publicada conforme decisão do docente responsável, com atenção a menores e terceiros.

## Critérios de aceite propostos

- AC-S3-01 — Avaliação sem banca: nenhum fluxo exige banca, sala, link, agenda ou resolução de conflito de horário.
- AC-S3-02 — Variação: o modelo e a interface permitem quantidade variável de avaliações, sem exigir uma quantidade fixa de avaliadores.
- AC-S3-03 — Atribuição entre alunos: somente avaliação atribuída pela coordenação pode ser realizada pelo aluno designado, para o projeto e data correspondentes. As regras detalhadas de elegibilidade e visibilidade entre alunos seguem bloqueadas até decisão listada abaixo.
- AC-S3-04 — PI: usuário que não seja docente responsável não consegue finalizar, reabrir ou corrigir avaliação PI; negação não altera o valor vigente.
- AC-S3-05 — Extensão: um docente pode adicionar avaliação de Extensão sem ser tratado como avaliador de banca.
- AC-S3-06 — Privacidade: visitante anônimo nunca recebe nota ou hora individual. Nota do projeto só é exibida no nível agregado e após publicação autorizada. Avaliação individual de docente fica restrita aos alunos do próprio projeto conforme o caderno.
- AC-S3-07 — Sem histórico: correção atualiza o valor vigente e não preserva valor anterior nem cria trilha de auditoria de negócio.
- AC-S3-08 — Catálogo: projeto não publicado não aparece para visitante; aluno autenticado pode consultar rascunho; projeto publicado só expõe campos e conteúdo aprovados como públicos.
- AC-S3-09 — Imagens: arquivo/foto sem autorização do docente responsável não aparece publicamente.
- AC-S3-10 — Certificado: a entrega permanece bloqueada para implementação funcional até que critérios de emissão e validação sejam aprovados e registrados na SPEC-EXT-003.

## Contratos e dependências de equipe

- Backend: BE-015 (notas), BE-017 (certificado), BE-018 (catálogo). BE-016 (auditoria de negocio) não integra o escopo conforme o Caderno; manter bloqueado até reconciliar a issue.
- Database: DB-009/010/014, sem inferir dados além das decisões aprovadas.
- Frontend: FE-013/014/015.
- Qualidade: QA-016/017/018.
- Contratos a publicar: operações e schemas de avaliações/notas, certificados e catálogo em OpenAPI 3.1; aprovação dos consumidores Frontend, Database e QA.
- Referências: SPEC-PI-002, SPEC-PI-003, SPEC-EXT-003, SPEC-PORTAL-001; PG-008, PG-010, PG-012.

## Decisões pendentes do PO

1. Nota: escala, precisão, arredondamento, validação dos pesos, critério sem peso, avaliação ausente e instante em que a ficha fecha.
2. Avaliação por aluno: elegibilidade do avaliador/alvo, visibilidade, edição/correção e tratamento de ausência ou retirada de avaliador.
3. Certificado: evento de emissão, elegibilidade, responsável emissor, campos, validação pública, assinatura/QR, validade, revogação, correção/reemissão, retenção e consulta.
4. Catálogo: campos públicos, busca/filtros/ordenação/paginação, retirada e prazo de expurgo em cache.
5. Nenhuma decisão acima pode ser inventada por Backend, Database, Frontend ou QA para fechar a sprint.

## Rastreabilidade

Caderno de Validações; EPIC-PI-001, EPIC-EXT-001, EPIC-PORTAL-001; SPEC-PI-002/003, SPEC-EXT-003, SPEC-PORTAL-001; BE-015/017/018; DB-009/010/014; FE-013/014/015; QA-016/017/018.

## Histórico

- Draft preparado para validação do PO; não aprovado e não normativo até revisão.
