---
title: "Testes End-to-End (E2E) com Playwright"
domain: "quality"
status: "accepted"
owner: "Luciano Jr / Nicolle / Bianca"
last_updated: "2026-08-27"
---

# 🎭 Testes End-to-End (E2E) com Playwright

Automação de testes de ponta a ponta simulando a navegação de usuários reais em navegadores Chromium, Firefox e WebKit.

---

## 1. Fluxos Críticos Automatizados (E2E Test Suite)
1. **Jornada de Autenticação:** Login com credenciais válidas, redirecionamento para o dashboard correto e logout.
2. **Jornada do Aluno (PI):** Acessar painel de PI, preencher formulário de nova proposta, convidar colegas e verificar status "Aguardando Aprovação".
3. **Jornada do Docente (Avaliação):** Acessar lista de bancas atribuídas, abrir modal de avaliação de rubricas, lançar notas e verificar cálculo em tempo real.
4. **Jornada de Extensão:** Submeter atividade com anexo, aprovar como orientador e emitir certificado em PDF.
5. **Jornada do Visitante Público:** Acessar portal público, aplicar filtro de busca por curso e abrir a página individual do projeto com SEO validado.

---

## 2. Execução e Agendamento dos Testes E2E
* **Ambiente Local:** `pnpm --filter web-admin test:e2e`
* **Ambiente Staging:** Execução diária automatizada via GitHub Actions agendado às 03h00 (cron job).

---

## 3. Documentos Relacionados
* [Estratégia Global](strategy.md)
* [Métricas DORA](../02-planning/metrics.md)
* [Plano de Releases](../02-planning/release-plan.md)
