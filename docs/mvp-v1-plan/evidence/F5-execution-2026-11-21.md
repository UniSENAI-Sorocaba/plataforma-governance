# Evidências de execução — F5

**Data:** 2026-11-21  
**Escopo:** catálogo público e validação pública.

## Implementação integrada

- catálogo existente permanece SSR e consulta somente `/api/v1/public/projects`;
- frontend adiciona busca textual, filtro por classificação, estados vazio e paginação estável no conjunto recebido;
- rota `/certificados` publica validação por código sem login;
- metadata de catálogo e certificado está definida no App Router.

## Validações

- `npm run check` passou após a integração do catálogo e da rota de certificados;
- build confirmou as rotas `/projects` e `/certificados`;
- endpoint público de projetos continua sem autenticação no backend.

## Limitações de aceite

Filtros de curso, semestre e ODS, workflow de impacto aprovado e medição Lighthouse em staging ainda não foram demonstrados no repositório atual: não há contrato backend/DB correspondente identificado. Não são declarados como concluídos sem essa implementação e ambiente de staging.
