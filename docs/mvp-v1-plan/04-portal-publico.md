# 04 — Portal Público e Experiência de Usuário

## Objetivo

Transformar os resultados aprovados dos módulos acadêmicos em uma vitrine pública rápida, acessível, indexável e segura.

## Subfase A — Catálogo

### Etapa A1 — API pública

**Itens:** `BE-018`, `DB-014`, `FE-015`.  
**Aceite:** endpoint pagina resultados; filtros por curso, semestre e ODS são combináveis; ordenação é estável; dados privados são excluídos por query e por teste; índices são comprovados por `EXPLAIN`.

### Etapa A2 — SSR e estados de interface

**Aceite:** primeira carga contém conteúdo no HTML; loading, erro, vazio e paginação têm comportamento definido; filtros preservam URL; conteúdo não publicado não aparece mesmo com URL conhecida.

## Subfase B — Impacto e publicação

### Etapa B1 — Workflow editorial

**Itens:** `BE-019`, `DB-015`, `FE-016`.  
**Aceite:** impacto passa por rascunho, submissão, aprovação e retirada; somente aprovado é renderizado; versão e origem são preservadas; retirada deixa de aparecer em nova consulta pública.

### Etapa B2 — Página pública de projeto

**Aceite:** página individual exibe somente campos públicos; não expõe dados de alunos, solicitações pendentes, notas internas ou documentos privados; links de certificado usam validador público.

## Subfase C — SEO, acessibilidade e desempenho

### Etapa C1 — SEO técnico

**Itens:** `FE-018`.  
**Aceite:** metadata, sitemap, robots e canonical URL existem e são válidos; páginas principais têm título e descrição únicos; URLs não dependem de estado de sessão.

### Etapa C2 — Acessibilidade

**Itens:** `FE-017`, `QA-020`.  
**Aceite:** navegação completa por teclado; foco visível; labels e nomes acessíveis; contraste conforme WCAG aplicável; nenhum bloqueador crítico em auditoria automatizada e manual.

### Etapa C3 — Web Vitals

**Itens:** `FE-019`, `INF-011`, `QA-021`.  
**Aceite:** LCP, INP e CLS são coletados em staging; página inicial atinge Lighthouse >= 90 em performance, acessibilidade e SEO; regressão acima da meta bloqueia release ou exige risco formalmente aceito.

## Gate funcional da fase

Usuário anônimo deve conseguir pesquisar um projeto aprovado, aplicar filtros, abrir sua página, consultar impacto publicado e validar um certificado, sem autenticação e sem receber conteúdo privado.
