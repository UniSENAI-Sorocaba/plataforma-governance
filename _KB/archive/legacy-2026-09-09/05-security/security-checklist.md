---
title: "Checklist de Segurança para Desenvolvimento e Deploy"
domain: "security"
status: "accepted"
owner: "Luciano Jr / Nicolle"
last_updated: "2026-08-27"
---

# ✅ Checklist de Segurança para Desenvolvimento e Deploy

Checklist obrigatório a ser verificado pelos desenvolvedores antes de submeter PRs e pelos líderes técnicos antes de releases em produção.

---

## 1. Checklist de Desenvolvimento (Pre-PR)
- [ ] O endpoint possui anotações explícitas de autenticação (`@UseGuards(AuthGuard)`) e papéis (`@Roles(...)`)?
- [ ] Foi implementada a validação de que o usuário logado é dono do recurso que está tentando modificar/deletar?
- [ ] O DTO de entrada possui regras de validação estritas com Zod / Class-Validator sem aceitar campos não declarados (`whitelist: true`)?
- [ ] Nenhuma query SQL crua (*raw query*) foi escrita sem parametrização estrita de variáveis?
- [ ] Nenhum dado sensível (senhas, hashes, chaves privadas) está sendo retornado nas respostas JSON da API?
- [ ] Nenhum log no console (`console.log`) está imprimindo credenciais, CPFs ou tokens JWT?
- [ ] O hook do Gitleaks executou localmente sem apontar nenhum segredo no código?

---

## 2. Checklist de Deploy e Produção (Pre-Release)
- [ ] A varredura de vulnerabilidades SAST (Trivy) e SonarQube passou sem nenhum apontamento Crítico ou Alto?
- [ ] As chaves RSA e credenciais de banco foram geradas diretamente no AWS Secrets Manager de produção?
- [ ] As regras do AWS WAF estão ativas no Application Load Balancer com proteção contra SQLi, XSS e Rate Limit?
- [ ] O banco de dados PostgreSQL RDS está configurado com criptografia em repouso ativada via AWS KMS?
- [ ] O bucket S3 de documentos possui a opção "Block all public access" ativada e criptografia AES-256 forçada?
- [ ] O certificado SSL/TLS (ACM) está ativo com redirecionamento automático de HTTP para HTTPS?

---

## 3. Documentos Relacionados
* [Threat Modeling](threat-model.md)
* [Definition of Done](../09-governance/definition-of-done.md)
* [Runbook de Deploy](../10-runbooks/deployment.md)
