# Evidências de execução — F5

**Data:** 2026-11-21  
**Escopo:** catálogo público e validação pública.

## Implementação integrada

- catálogo existente permanece SSR e consulta somente `/api/v1/public/projects`;
- frontend adiciona busca textual, filtro por classificação, estados vazio e paginação estável no conjunto recebido;
- rota `/certificados` publica validação por código sem login;
- metadata de catálogo e certificado está definida no App Router.
- backend expõe `/api/v1/public/projects/search` com paginação e filtros de curso, semestre e ODS;
- banco aplica V0017 com `course_code`, `ods_codes`, constraints de domínio e índices B-tree/GIN;
- contrato OpenAPI documenta a consulta paginada e seus limites.
- workflow T20 implementado com rascunho, submissão, aprovação por coordenação, versões e consulta pública somente de impactos aprovados;
- frontend publica `/impactos` com estado vazio, resumo da evidência e versão aprovada.

## Validações

- `npm run check` passou após a integração do catálogo e da rota de certificados;
- build confirmou as rotas `/projects` e `/certificados`;
- endpoint público de projetos continua sem autenticação no backend.
- `make test` do banco passou, incluindo validação de upgrade incremental e checks V0017;
- `mvn --batch-mode verify` passou com 106 testes e gate de cobertura;
- `npm run check` passou com lint, typecheck, 21 testes e build, incluindo `/robots.txt` e `/sitemap.xml`.
- `mvn --batch-mode -Dtest=ImpactServiceTest,ApiFoundationWebTest test` passou com 9 testes;
- `npm run check` do frontend de impactos passou com build da rota `/impactos`.
- Lighthouse local em `/impactos` (segunda execução): performance 93, acessibilidade 94, SEO 100 e best practices 96.

## Limitações de aceite

A medição Lighthouse em staging ainda não foi demonstrada; a medição local atende às metas, mas não substitui staging. T19, T20 e o SEO estrutural T21 estão implementados.
