---
title: "Modelagem de Ameaças e Mitigações OWASP Top 10"
domain: "security"
status: "accepted"
owner: "Luciano Jr"
last_updated: "2026-08-27"
---

# 🛡️ Modelagem de Ameaças & Mitigações OWASP Top 10

Mapeamento sistemático dos principais vetores de ataque cibernético e as respectivas contramedidas arquiteturais e operacionais implementadas.

---

## 1. Matriz de Mitigação OWASP Top 10

| Vulnerabilidade OWASP | Risco no Projeto | Contramedida Implementada |
| :--- | :--- | :--- |
| **A01: Broken Access Control** | Aluno tentar alterar nota de PI de outro grupo ou validar suas próprias horas de extensão. | Guards de autorização em nível de rota (`@Roles()`) combinados com validação estrita de posse de recurso (*Ownership Check*) no serviço. |
| **A02: Cryptographic Failures** | Vazamento de senhas de usuários ou interceptação de dados de autenticação em trânsito. | Hashing de senhas com **Argon2id** (64MB memória, 3 iterações) e tráfego 100% criptografado com TLS 1.3 forçado por HSTS. |
| **A03: Injection (SQL / NoSQL)** | Manipulação maliciosa de queries no banco para extrair dados confidenciais ou bypassar auth. | Uso obrigatório de query builders parametrizados (Prisma/TypeORM) com validação tipada de DTOs via Zod/Class-Validator. |
| **A04: Insecure Design** | Falha de isolamento conceitual entre módulos do sistema. | Separação de domínios em schemas PostgreSQL isolados e modelo de Monólito Modular baseado em DDD. |
| **A05: Security Misconfiguration** | Headers padrão do servidor revelando versões ou ausência de políticas CSP. | Inclusão obrigatória do middleware `helmet` no NestJS, desativação do header `X-Powered-By` e CORS estrito. |
| **A07: Identification & Auth Failures** | Ataques de força bruta contra a rota de login ou roubo de sessões. | Rate limiting de 5 req/min no `/login`, tokens JWT com TTL curto de 15 min e Refresh Tokens em cookies `HttpOnly; Secure; SameSite=Strict`. |
| **A08: Software & Data Integrity Failures** | Inclusão de dependências NPM infectadas com código malicioso. | Assinatura de commits, varredura estática de dependências via **Trivy** e **npm audit** em pipeline bloqueante. |
| **A09: Security Logging & Monitoring Failures** | Falta de rastreamento de tentativas de invasão ou fraudes acadêmicas. | Tabela dedicada de auditoria (`auth.audit_logs`) com registro de IP, payload sanitizado e alarmes no CloudWatch. |

---

## 2. Documentos Relacionados
* [Checklist de Segurança](security-checklist.md)
* [Autenticação](authentication.md)
* [Testes de Segurança](../08-quality/security-testing.md)
