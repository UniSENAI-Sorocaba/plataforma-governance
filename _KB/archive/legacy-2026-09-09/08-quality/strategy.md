---
title: "Estratégia Global de Qualidade e Pirâmide de Testes"
domain: "quality"
status: "accepted"
owner: "Luciano Jr / Nicolle"
last_updated: "2026-08-27"
---

# 🧪 Estratégia Global de Qualidade & Pirâmide de Testes

Estratégia de garantia de qualidade (QA) estruturada em camadas, definindo responsabilidades, ferramentas e critérios de aprovação para cada nível de teste.

```
                                  PIRÂMIDE DE TESTES DO PROJETO
                                           /\
                                          /  \
                                         / E2E\         (10% - Playwright / Fluxos Críticos)
                                        /------\
                                       /Integr. \       (30% - Supertest + Testcontainers DB)
                                      /----------\
                                     /  Unitários \     (60% - Jest / Regras de Negócio & DTOs)
                                    /--------------\
```

---

## 1. Matriz de Camadas de Testes

| Camada | Ferramenta | Responsável | Frequência de Execução | Quality Gate Mínimo |
| :--- | :--- | :--- | :--- | :--- |
| **Unitários** | Jest / Vitest | Desenvolvedor da Feature | Toda PR (Local + CI) | Cobertura de linhas $\ge 80\%$ no domínio. |
| **Integração** | Supertest + Testcontainers | Devs Backend + QA | Toda PR (CI) | 100% dos endpoints REST respondendo contratos válidos. |
| **Contrato** | Zod / TypeScript | Devs Backend | Toda PR (CI) | Zero erros de tipagem entre front e back. |
| **E2E** | Playwright | Squad QA (Nicolle e time) | Diário em Staging | Fluxos críticos (Login, PI, Certificado) 100% verdes. |
| **Performance**| k6 | Luciano Jr + QA Lead | Pré-Release (Sprint 4) | Suportar 200 RPS com p95 latência $< 600\text{ms}$. |
| **Segurança** | Trivy (SAST) + OWASP ZAP (DAST) | Luciano Jr + QA Lead | Toda PR + Semanal | Zero vulnerabilidades de severidade Alta ou Crítica. |

---

## 2. Responsabilidade Transversal de QA
* **Owner Técnico Geral:** **Luciano Jr** (Definição da pirâmide, metas de cobertura, esteira DevSecOps e aprovação dos Quality Gates).
* **Líder Técnica de QA:** **Nicolle** (Orquestração do plano de testes, criação das suítes Playwright e homologação).
* **Analistas de QA:** Ryan, Bianca, Guilherme Aparecido.

---

## 3. Documentos Relacionados
* [Testes Unitários](unit-tests.md)
* [Testes de Integração](integration-tests.md)
* [Testes E2E](e2e.md)
* [Testes de Segurança](security-testing.md)
