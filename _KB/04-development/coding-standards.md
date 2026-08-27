---
title: "Padrões de Código e Convenções de Desenvolvimento"
domain: "development"
status: "accepted"
owner: "Luciano Jr / Marco / Nicolas Leão"
last_updated: "2026-08-27"
---

# 📏 Padrões de Código & Convenções

Diretrizes obrigatórias de estilo, tipagem, nomenclatura e qualidade para todo o código escrito no projeto.

---

## 1. Padrões Gerais TypeScript & JavaScript
* **Tipagem Estrita (`strict: true`):** É estritamente proibido o uso do tipo `any`. Utilize tipos explícitos, `unknown` ou generics quando necessário.
* **Validação em Tempo de Execução:** Todo DTO de entrada na API deve ser validado via **Zod** ou **Class-Validator**.
* **Imutabilidade:** Prefira `const` e métodos imutáveis (`map`, `filter`, `reduce`) a loops imperativos com `let` ou mutação direta de arrays/objetos.
* **Funções Pequenas e Coesas:** Funções devem ter responsabilidade única e idealmente menos de 30 linhas de código.

---

## 2. Padrão de Nomenclatura de Arquivos e Código

| Elemento | Convenção | Exemplo |
| :--- | :--- | :--- |
| **Arquivos TypeScript/JS** | `kebab-case.ts` | `evaluation-service.ts`, `auth-guard.ts` |
| **Componentes React / Next.js** | `PascalCase.tsx` | `ProjectCard.tsx`, `EvaluationModal.tsx` |
| **Classes e Interfaces** | `PascalCase` | `UserEntity`, `CreateProjectDto` |
| **Variáveis, Funções e Métodos** | `camelCase` | `calculateAverageGrade()`, `isActive` |
| **Constantes Globais e Enums** | `UPPER_SNAKE_CASE` | `MAX_UPLOAD_SIZE_BYTES`, `UserRole.STUDENT` |
| **Tabelas e Colunas do Banco** | `snake_case` | `project_members`, `scheduled_at` |

---

## 3. Padrão de Mensagens de Commit (Conventional Commits)

Todas as mensagens de commit devem seguir o padrão formal:
`<tipo>(<escopo>): <descrição no presente imperativo>`

### Tipos Permitidos:
* `feat`: Nova funcionalidade para o usuário final.
* `fix`: Correção de bug.
* `docs`: Alteração exclusivamente em documentação.
* `refactor`: Refatoração de código que não altera comportamento funcional.
* `test`: Adição ou correção de testes automatizados.
* `chore`: Atualização de dependências, scripts ou tarefas de manutenção.
* `infra`: Alterações em Terraform, Docker ou pipelines de CI/CD.

### Exemplos Válidos:
* `feat(auth): add refresh token rotation mechanism`
* `fix(academic): resolve concurrent evaluation race condition`
* `infra(terraform): configure rds automated backup retention to 7 days`

---

## 4. Documentos Relacionados
* [Estratégia de Branching](branching-strategy.md)
* [Diretrizes de Pull Request](pull-requests.md)
* [Diretrizes de API](api-guidelines.md)
