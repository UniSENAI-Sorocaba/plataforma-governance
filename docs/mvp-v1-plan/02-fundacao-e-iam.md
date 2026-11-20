# 02 — Fundação, Dados e IAM

## Objetivo

Criar a base estável sobre a qual os fluxos de Projetos, Extensão e Portal possam ser desenvolvidos sem retrabalho de contratos, segurança, migrations ou operação.

## Subfase A — Integração da fundação

### Etapa A1 — Backend base

**Itens:** `BE-001`, `BE-002`, `BE-003`.  
**Executor:** .agents/backend-agent.md.  
**Revisor:** .agents/architecture-agent.md + .agents/quality-security-agent.md.

**Atividades:**

- integrar estrutura modular e limites de pacote;
- consolidar envelope de erro, correlation ID e logs;
- publicar OpenAPI 3.1;
- validar mock consumível pelo frontend e quality;
- manter healthcheck e actuator sem expor dados sensíveis.

**Aceite:** `mvn verify` passa; contrato OpenAPI valida; breaking change falha no CI; 100% dos erros HTTP têm formato documentado; healthcheck responde em até 1 s em ambiente local.

### Etapa A2 — Frontend base

**Itens:** `FE-001`, `FE-003`.  
**Executor:** .agents/frontend-agent.md.  
**Revisor:** .agents/quality-security-agent.md.

**Aceite:** lint, typecheck, testes e build passam; rota principal é SSR; cinco componentes base possuem estados de erro/foco; nenhuma tela crítica depende de JavaScript para conteúdo essencial.

### Etapa A3 — Banco reprodutível

**Itens:** `DB-001`, `DB-002`, `DB-003`, `DB-016`.  
**Executor:** .agents/database-agent.md.  
**Revisor:** .agents/backend-agent.md + .agents/quality-security-agent.md.

**Aceite:** banco vazio aplica todas as migrations; banco existente executa upgrade; seeds são determinísticos; drift é detectado no CI; `make validate` passa sem intervenção manual.

### Etapa A4 — Infraestrutura mínima

**Itens:** `INF-001` a `INF-009`, conforme dependência.  
**Executor:** .agents/infrastructure-agent.md.  
**Revisor:** .agents/quality-security-agent.md + .agents/architecture-agent.md.

**Aceite:** Terraform formatado e validado em development/production; secrets não ficam em código; CI gera artefato imutável; ambiente efêmero pode ser criado e destruído por workflow autorizado.

## Subfase B — Identidade e sessão

### Etapa B1 — Modelo de identidade

**Itens:** `DB-004`, `DB-005`, `DB-006`.  
**Dependências:** A3.

**Aceite:** usuário, vínculo institucional, sessão, refresh token, papel, permissão e escopo possuem constraints, índices e migrations; tokens armazenados são hashes; expiração e revogação são consultáveis sem varredura completa.

### Etapa B2 — Login e credenciais

**Itens:** `BE-004`, `BE-005`.  
**Dependências:** B1.

**Aceite:** credencial válida emite JWT RS256; credencial inválida retorna erro uniforme sem indicar qual campo falhou; Argon2id está configurado; senha, token e segredo não aparecem em logs; testes de integração cobrem sucesso e falha.

### Etapa B3 — Refresh, logout e recuperação

**Itens:** `BE-006`, `AUTH-10-BE`, `FE-005`.  
**Dependências:** B2.

**Aceite:** refresh é rotativo; reuse invalida a família; logout revoga a sessão; recuperação usa token de uso único, expiração e revogação; frontend tenta renovar uma vez e encerra sessão com segurança após falha.

### Etapa B4 — RBAC server-side

**Itens:** `BE-010`, `QA-009`.  
**Dependências:** B2.

**Aceite:** cada rota protegida possui matriz allow/deny por papel; ausência de permissão retorna 403; ausência de autenticação retorna 401; logs técnicos não expõem segredos; o default é deny.

### Etapa B5 — Jornada autenticada

**Executor:** .agents/frontend-agent.md + .agents/quality-security-agent.md.  
**Aceite:** Playwright cobre login, erro, loading, redirecionamento por papel, expiração e logout; acessibilidade sem bloqueador nas telas críticas.
