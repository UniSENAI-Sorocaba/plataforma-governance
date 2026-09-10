---
title: "Visão Geral de Segurança da Informação e LGPD"
domain: "security"
status: "accepted"
owner: "Luciano Jr"
last_updated: "2026-08-27"
---

# 🛡️ Visão Geral de Segurança da Informação & LGPD

Princípios e políticas de segurança aplicados à arquitetura, código e infraestrutura da Plataforma Digital Integrada.

---

## 1. Princípios Norteadores de Segurança
* **Princípio do Menor Privilégio (*Least Privilege*):** Usuários, serviços, instâncias e bancos de dados possuem apenas o conjunto estritamente necessário de permissões para executar sua função.
* **Segurança por Padrão (*Secure by Default*):** Todas as rotas são privadas por padrão; rotas públicas exigem anotação explícita `@Public()`.
* **Defesa em Profundidade (*Defense-in-Depth*):** Barreiras redundantes de proteção (WAF -> ALB -> NestJS Guards -> DTO Validation -> Database Constraints -> Data Encryption).

---

## 2. Conformidade com a Lei Geral de Proteção de Dados (LGPD)
* **Minimização de Dados:** Apenas dados necessários para as funções acadêmicas são coletados e persistidos.
* **Mascaramento e Anonimização:**
  * CPFs e documentos de identificação são mascarados na visualização pública (`***.456.789-**`).
  * Relatos da ouvidoria e avaliações da CPA não possuem vínculo de chave estrangeira com o ID do usuário quando marcados como anônimos.
* **Direito ao Esquecimento e Soft Delete:** Usuários inativados têm suas credenciais revogadas imediatamente e dados pessoais anonimizados quando legalmente permitido.

---

## 3. Atribuição de Responsabilidade de SSO/IAM e Segurança
* **Owner Técnico Geral:** **Luciano Jr** (Definição de arquitetura, políticas de tokens, desenho de schemas e quality gates de segurança).
* **Execução Técnica:** Desenvolvedores de Backend (Marco, Pedro, Matheus Henrique), Frontend (Nicolas Leão e time) e Cloud (Fazano e time).
* **Auditoria e Homologação:** PO (Fellipe Raszejas) e Docência.

---

## 4. Documentos Relacionados
* [Autenticação e Sessões](authentication.md)
* [Matriz de Permissões RBAC](iam-rbac.md)
* [Threat Modeling e OWASP](threat-model.md)
