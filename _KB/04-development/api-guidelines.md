---
title: "Diretrizes de Desenvolvimento de APIs REST"
domain: "development"
status: "accepted"
owner: "Luciano Jr / Marco"
last_updated: "2026-08-27"
---

# 🔌 Diretrizes de Desenvolvimento de APIs REST

Padrões obrigatórios para design de rotas, códigos de status HTTP, documentação Swagger e validação de payloads.

---

## 1. Mapeamento de Verbos HTTP e Códigos de Retorno

| Verbo HTTP | Semântica | Sucesso Típico | Erro Comum |
| :--- | :--- | :--- | :--- |
| **GET** | Consulta de recursos idempotente (não altera estado) | `200 OK` | `404 Not Found` |
| **POST** | Criação de novos recursos ou ações de negócio complexas | `201 Created` | `400 Bad Request`, `422 Unprocessable` |
| **PUT** | Substituição integral de um recurso existente | `200 OK` | `404 Not Found`, `400 Bad Request` |
| **PATCH** | Atualização parcial de campos específicos | `200 OK` | `404 Not Found`, `400 Bad Request` |
| **DELETE**| Remoção lógica (*soft-delete*) ou física de um recurso | `204 No Content` | `404 Not Found`, `403 Forbidden` |

---

## 2. Padrão de Documentação Swagger / OpenAPI
Todos os controllers NestJS devem incluir anotações Swagger explícitas:
* `@ApiTags('Domínio')`: Agrupamento de endpoints.
* `@ApiOperation({ summary: 'Descrição curta da ação' })`.
* `@ApiResponse({ status: 201, type: ResponseDto })`.
* `@ApiBearerAuth()`: Para rotas protegidas por JWT.

---

## 3. Paginação e Filtros
Endpoints de listagem devem aceitar obrigatoriamente paginação baseada em limite e deslocamento:
* Query params: `?page=1&limit=20&sortBy=createdAt&sortOrder=DESC`
* Payload de resposta paginado:
  ```json
  {
    "data": [ ... ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "totalItems": 85,
      "totalPages": 5,
      "hasNextPage": true,
      "hasPreviousPage": false
    }
  }
  ```

---

## 4. Documentos Relacionados
* [Arquitetura de Integração](../03-architecture/integration-architecture.md)
* [Padrões de Código](coding-standards.md)
* [Segurança em APIs](../05-security/authorization.md)
