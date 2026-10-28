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

## Regras oficiais
- Projeto aparece no site público quando o docente marca a opção de publicação no cadastro.
- Rascunho fica disponível a alunos autenticados; projeto publicado é exibido publicamente.
- Nota do projeto pode ser pública; horas e notas individuais não são públicas.
- Docente responsável decide se autoriza publicação de fotos, considerando menores e terceiros.
- Arquivos internos do projeto podem ser vistos pelos alunos vinculados, docentes e administradores; acesso ao arquivo não implica publicação no catálogo.

## Detalhes ainda não definidos
Campos exatos do catálogo, filtros, busca, ordem, paginação, cache/retirada, autorização e registro para imagens, e prazo para conteúdo retirado desaparecer de caches.

## Trabalho das equipes
Backend/DB expõem somente os campos de projeto permitidos; Frontend apresenta conteúdo publicado; Cloud configura cache que permita retirar publicação; QA testa acesso anônimo, conteúdo, nota agregada, privacidade de notas individuais e retirada.

## Cenários de aceite verificáveis
- **AC-PORTAL-001-01 — Público:** visitante anônimo consulta somente projetos cuja opção de publicação foi marcada pelo docente responsável.
- **AC-PORTAL-001-02 — Rascunho:** rascunho não aparece em listagem nem consulta anônima; aluno autenticado pode consultá-lo.
- **AC-PORTAL-001-03 — Retirada:** ao desmarcar publicação ou retirar projeto, a API deixa de servi-lo anonimamente. Cache/CDN não pode continuar expondo o conteúdo; SLA de expurgo precisa ser definido antes do aceite final.
- **AC-PORTAL-001-04 — Campos:** horas e notas individuais nunca aparecem na resposta pública. Nota do projeto só é exposta no nível agregado permitido; não incluir arquivos internos automaticamente.
- **AC-PORTAL-001-05 — Imagens:** nenhuma foto de aluno/terceiro é pública sem opção de publicação definida pelo docente responsável; conteúdo sem autorização permanece acessível apenas conforme regra de arquivo interno.
- Campos públicos, cache, filtros e paginação permanecem pendentes; os critérios acima não autorizam inventar o schema de catálogo.

## Rastreabilidade
EPIC-PORTAL-001; REQ-PORTAL-001; PG-011/PG-012; INF-010/011; SPEC-PI-004; [regras oficiais](../product/official-validation-decisions.md).
