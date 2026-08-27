---
title: "Mecanismo de Autorização e RBAC"
domain: "security"
status: "accepted"
owner: "Luciano Jr"
last_updated: "2026-08-27"
---

# 🛡️ Mecanismo de Autorização & RBAC

Controle de acesso granular baseado em papéis (*Role-Based Access Control*) e verificação de posse de recursos (*Resource Ownership Verification*).

---

## 1. Níveis de Proteção de Rotas

```
[Requisição HTTP]
       ↓
[1. AuthGuard] ─── Valida Assinatura JWT RS256 e Expiração
       ↓
[2. RolesGuard] ─── Valida se a Role do Token está em @Roles(...)
       ↓
[3. PermissionsGuard] ─── Valida se o Escopo está em @Permissions(...)
       ↓
[4. Resource Ownership Service] ─── Valida se o ID do Aluno é dono do recurso
       ↓
[Execução do Controller de Negócio]
```

---

## 2. Implementação em Código (Decorators NestJS)

```typescript
@Controller('academic/evaluations')
@UseGuards(AuthGuard, RolesGuard)
export class EvaluationController {
  
  @Post()
  @Roles(UserRole.PROFESSOR, UserRole.ADMIN)
  @Permissions('evaluation:write')
  async submitEvaluation(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: SubmitEvaluationDto
  ) {
    return this.evaluationService.submit(user.id, dto);
  }
}
```

---

## 3. Prevenção de Insecure Direct Object References (IDOR / BOLA)
Mesmo que um aluno possua a role `STUDENT`, o serviço de aplicação verifica explicitamente se o `user.id` do token JWT corresponde ao `student_id` ou ao `leader_id` do registro antes de permitir edição ou exclusão. Caso contrário, a API retorna `403 Forbidden` (`ACCESS_DENIED_NOT_OWNER`).

---

## 4. Documentos Relacionados
* [Matriz de Permissões RBAC](iam-rbac.md)
* [Autenticação](authentication.md)
* [Threat Modeling](threat-model.md)
