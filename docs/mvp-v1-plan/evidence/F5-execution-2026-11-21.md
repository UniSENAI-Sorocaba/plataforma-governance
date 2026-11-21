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

## Validações

- `npm run check` passou após a integração do catálogo e da rota de certificados;
- build confirmou as rotas `/projects` e `/certificados`;
- endpoint público de projetos continua sem autenticação no backend.
- `make test` do banco passou, incluindo validação de upgrade incremental e checks V0017;
- `mvn --batch-mode verify` passou com 106 testes e gate de cobertura;
- `npm run check` passou com lint, typecheck, 21 testes e build, incluindo `/robots.txt` e `/sitemap.xml`.

## Limitações de aceite

O workflow de impacto aprovado e a medição Lighthouse em staging ainda não foram demonstrados. A busca T19 e o SEO estrutural T21 estão implementados; Lighthouse continua dependente de ambiente de staging.
