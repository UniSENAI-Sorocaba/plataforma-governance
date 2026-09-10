---
title: "Delimitação do MVP e Critérios de Corte de Escopo"
domain: "product"
status: "accepted"
owner: "Fellipe Raszejas / Luciano Jr"
last_updated: "2026-08-27"
---

# 🚀 Delimitação do MVP (Minimum Viable Product)

## 1. Racional de Negócio e Engenharia
Para garantir a entrega de um produto de software robusto, estável, auditável e 100% funcional até o **início de dezembro (2026.2)** por uma equipe de 25 desenvolvedores, adota-se um **corte de escopo estrito e definitivo**:

* **Escopo Obrigatório — Dezembro (MVP do Semestre Atual):** Concentração absoluta de 100% da capacidade produtiva nos 3 módulos essenciais (**SSO/IAM**, **Projetos Integradores & Extensão** e **Portal Público Vitrine**) suportados por infraestrutura AWS, CI/CD e esteira DevSecOps.
* **Backlog / Fase 2 (Próximo Semestre):** Todas as demais funcionalidades e módulos institucionais complementares (**Gestão Patrimonial**, **Carreiras**, **Iniciação Científica** e **CPA/Ouvidoria**) estão formalmente postergados para o planejamento do próximo semestre letivo.

---

## 2. Matriz Comparativa de Escopo

```
+--------------------------------------------------------------------------------------------------------------------+
|                                         MATRIZ OFICIAL DE ESCOPO DO PROJETO                                        |
+------------------------------------+----------------------------------------+--------------------------------------+
| MÓDULO / DOMÍNIO                   | ESCOPO OBRIGATÓRIO — DEZEMBRO (MVP)    | BACKLOG / FASE 2 (PRÓXIMO SEMESTRE)  |
+------------------------------------+----------------------------------------+--------------------------------------+
| **1. Autenticação & SSO (IAM)**    | • Login único centralizado             | • MFA (TOTP) avançado                |
|                                    | • Gestão de perfis (5 roles)           | • Login social / Google Workspace    |
|                                    | • RBAC granular e JWT RS256/OAuth2     | • Biometria FIDO2 / Passkeys         |
|                                    | • Controle de sessões e auditoria      |                                      |
+------------------------------------+----------------------------------------+--------------------------------------+
| **2. Projetos Integradores &       | • Captação de propostas (inc. híbridos)| • Exportação analítica em lote MEC   |
|       Extensão Universitária**     | • Gestão de equipes e alocação alunos  | • Histórico retroativo legado        |
|                                    | • Avaliação docente por rubricas       | • Recomendação algorítmica por IA    |
|                                    | • Cálculo de notas consolidado         | • App mobile presencial com GPS      |
|                                    | • Apuração automatizada de horas ext.  |                                      |
|                                    | • Emissão de certificados com hash     |                                      |
+------------------------------------+----------------------------------------+--------------------------------------+
| **3. Portal Público                | • Vitrine web responsiva de projetos   | • Painel de engajamento social       |
|       (Vitrine de Ações)**         | • Divulgação de impactos comunitários  | • Comentários da comunidade externa  |
|                                    | • Prestação de contas social           |                                      |
|                                    | • Busca, filtros por curso/ODS e SEO   |                                      |
|                                    | • Validador público de certificados    |                                      |
+------------------------------------+----------------------------------------+--------------------------------------+
| **4. Gestão Patrimonial**          | *POSTERGADO INTEGRALMENTE*             | • Inventário de notebooks e QR Code  |
|                                    |                                        | • Check-in e check-out de empréstimos|
|                                    |                                        | • Reserva de salas e autorizações    |
|                                    |                                        | • Gestão de ocorrências e avarias    |
+------------------------------------+----------------------------------------+--------------------------------------+
| **5. Carreira & Oportunidades**    | *POSTERGADO INTEGRALMENTE*             | • Banco de currículos e perfis       |
|                                    |                                        | • Mural de vagas de estágio/trainee  |
|                                    |                                        | • Sistema de candidaturas            |
+------------------------------------+----------------------------------------+--------------------------------------+
| **6. Iniciação Científica (IC)**   | *POSTERGADO INTEGRALMENTE*             | • Editais de fomento e bolsas        |
|                                    |                                        | • Submissão de planos de trabalho    |
|                                    |                                        | • Relatórios parciais e pareceristas |
+------------------------------------+----------------------------------------+--------------------------------------+
| **7. CPA & Ouvidoria**             | *POSTERGADO INTEGRALMENTE*             | • Avaliação institucional periódica  |
|                                    |                                        | • Formulário de avaliação de cantina |
|                                    |                                        | • Relatos confidenciais a docentes   |
|                                    |                                        | • Painel estatístico para a CPA      |
+------------------------------------+----------------------------------------+--------------------------------------+
```

---

## 3. Critérios de Sucesso para o Go-Live do MVP (Início de Dezembro)
1. **SSO Operacional:** 100% dos acessos de alunos, docentes, coordenação, CPA e admins mediados pelo SSO via JWT RS256.
2. **Ciclo Completo de PI:** Submissão de propostas, formação de equipes, bancas examinadoras e consolidação automática de notas operando perfeitamente.
3. **Curricularização da Extensão Auditável:** Alunos registram atividades e horas curriculares validadas com emissão de certificados autenticados em PDF.
4. **Portal Público com Alto Desempenho:** Vitrine pública indexável com pontuação Google Lighthouse $\ge 90$ em Performance, Acessibilidade e SEO.
5. **Quality Gates e Confiabilidade:** Cobertura de testes automatizados $\ge 75\%$, zero vulnerabilidades críticas (Trivy/SonarQube) e custo AWS $< \$120/\text{mês}$.

---

## 4. Documentos Relacionados
* [Módulos do Sistema](modules.md)
* [Escopo Geral](scope.md)
* [Roadmap do Projeto](../archive/legacy-2026-09-09/02-planning/roadmap.md)
* [Plano de Releases](../archive/legacy-2026-09-09/02-planning/release-plan.md)
