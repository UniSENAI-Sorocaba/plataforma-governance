---
title: "Testes de Segurança Automatizados (SAST e DAST)"
domain: "quality"
status: "accepted"
owner: "Luciano Jr / Guilherme Aparecido / Fazano"
last_updated: "2026-08-27"
---

# 🛡️ Testes de Segurança Automatizados (SAST e DAST)

Integração de testes de segurança estáticos e dinâmicos na esteira de engenharia (*DevSecOps*).

---

## 1. Análise Estática de Segurança (SAST)
* **Trivy / SonarQube:** Escaneamento de todo o código-fonte e dependências NPM a cada Pull Request.
* **Critério de Bloqueio:** PRs com vulnerabilidades de severidade `CRITICAL` ou `HIGH` em dependências ou código são automaticamente rejeitados pelo Quality Gate.

---

## 2. Análise Dinâmica de Segurança (DAST)
* **OWASP ZAP (Zed Attack Proxy):** Varredura semanal executada contra o ambiente de Staging para identificação de falhas de injeção, headers ausentes, vazamento de cookies e falhas de CORS.

---

## 3. Prevenção de Segredos no Git (Gitleaks)
* Varredura contínua no histórico de commits para impedir chaves privadas RSA, senhas de banco ou tokens expostos.

---

## 4. Documentos Relacionados
* [Estratégia Global](strategy.md)
* [Threat Modeling](../05-security/threat-model.md)
* [Checklist de Segurança](../05-security/security-checklist.md)
