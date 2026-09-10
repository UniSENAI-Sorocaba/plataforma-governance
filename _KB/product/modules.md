---
title: "Módulos do Sistema e Especificação Funcional"
domain: "product"
status: "accepted"
owner: "Fellipe Raszejas / Luciano Jr"
last_updated: "2026-08-27"
---

# 📦 Módulos do Sistema & Especificação Funcional

Detalhamento funcional e de negócio dos módulos da plataforma, categorizados entre o **Escopo Obrigatório com entrega em Dezembro (MVP)** e o **Backlog / Fase 2 (Próximo Semestre)**.

---

# PARTE 1: ESCOPO OBRIGATÓRIO — DEZEMBRO (MVP)

## 1. Módulo 1: Autenticação & Autorização Central (SSO/IAM)
* **Objetivo:** Prover uma central única de identidade e controle de acesso seguro para todos os usuários e aplicações consumidoras.
* **Funcionalidades Obrigatórias:**
  * Login único centralizado com e-mail institucional e senha.
  * Emissão de Access Tokens JWT (RS256) e Refresh Tokens criptográficos em cookies seguros.
  * Controle de acesso baseado em papéis (RBAC): `STUDENT`, `PROFESSOR`, `COORDINATOR`, `CPA`, `ADMIN`.
  * Gestão de sessões ativas e logout centralizado (revogação de tokens).
  * Trilhas de auditoria para operações de login, alteração de permissões e ações sensíveis.
  * Recuperação e redefinição segura de senhas via token com tempo de expiração.

---

## 2. Módulo 2: Projetos Integradores & Extensão Universitária
* **Objetivo:** Gerenciar o ciclo de vida completo de Projetos Integradores interdisciplinares e ações extensionistas (atendendo à Resolução CNE/CES nº 7/2018).
* **Funcionalidades Obrigatórias:**
  * **Captação de Projetos:** Submissão e validação de propostas de projetos integradores e de extensão (incluindo modelos híbridos acadêmico-extensionistas).
  * **Gestão de Equipes/Alunos:** Alocação de estudantes em projetos com acompanhamento de status, convites e liderança de grupo.
  * **Gestão de Bancas Examinadoras:** Agendamento de bancas, alocação de docentes avaliadores e links/salas de apresentação.
  * **Avaliação Docente:** Módulo para avaliação de desempenho e entregáveis por professores avaliadores com base em rubricas estruturadas.
  * **Cálculo de Notas:** Consolidação e lançamento automatizado de notas e médias ponderadas para Projetos Integradores, com geração de ata final.
  * **Cálculo de Horas de Extensão:** Apuração, validação por orientador e controle automatizado de horas de extensão para cumprimento curricular.
  * **Certificação Digital:** Emissão automatizada de Certificados Digitais em PDF com hash SHA-256 e validação pública.

---

## 3. Módulo 3: Portal Público (Vitrine de Ações)
* **Objetivo:** Expor publicamente para a sociedade os projetos acadêmicos e extensionistas, divulgando seus impactos sociais e prestando contas.
* **Funcionalidades Obrigatórias:**
  * **Catálogo Público:** Website público responsivo contendo o catálogo de projetos de extensão e integradores desenvolvidos, sem exigência de autenticação.
  * **Impacto Social & Prestação de Contas:** Divulgação detalhada dos impactos das ações na comunidade, beneficiários atendidos e prestação de contas social.
  * **Busca e Filtros:** Busca facetada por curso, palavra-chave, semestre e Objetivos de Desenvolvimento Sustentável (ODS).
  * **Página Individual do Projeto:** Exibição de resumo executivo, integrantes, orientadores, fotos, vídeos de demonstração e repositórios.
  * **Validador Público de Certificados:** Consulta pública da autenticidade de certificados emitidos através do código hash ou QR Code.
  * **Performance & SEO:** Renderização otimizada (SSR/SSG) garantindo pontuação Google Lighthouse $\ge 90$ e acessibilidade (WCAG).

---

# PARTE 2: BACKLOG / FASE 2 (POSTERGADO PARA O PRÓXIMO SEMESTRE)

## 4. Módulo 4: Gestão Patrimonial
* **Status:** *Postergado para a Fase 2 (Próximo Semestre)*.
* **Funcionalidades Previstas:**
  * **Inventário de Notebooks:** Cadastro com QR Code, check-in e check-out de empréstimos e histórico de responsáveis.
  * **Agendamento de Salas:** Disponibilidade e aprovação de reservas de salas/laboratórios fora do horário.
  * **Gestão de Ocorrências:** Registro de avarias físicas, evidências fotográficas e histórico de resolução.

---

## 5. Módulo 5: Carreira & Oportunidades
* **Status:** *Postergado para a Fase 2 (Próximo Semestre)*.
* **Funcionalidades Previstas:**
  * Perfil profissional com currículo digital, competências e portfólio.
  * Mural de vagas de estágio, trainee e candidaturas simplificadas.

---

## 6. Módulo 6: Iniciação Científica & Tecnológica (IC & IT)
* **Status:** *Postergado para a Fase 2 (Próximo Semestre)*.
* **Funcionalidades Previstas:**
  * Editais de bolsas de fomento, submissão de planos de trabalho e relatórios de pesquisa com pareceristas.

---

## 7. Módulo 7: CPA & Ouvidoria Institucional
* **Status:** *Postergado para a Fase 2 (Próximo Semestre)*.
* **Funcionalidades Previstas:**
  * Formulários dinâmicos de autoavaliação institucional periódica e avaliação da cantina.
  * Canal confidencial/anônimo de relatos com docentes e coordenação.
  * Painel de indicadores consolidados para o relatório de autoavaliação do MEC.

---

## 8. Documentos Relacionados
* [Delimitação do MVP](mvp-baseline.md)
* [Escopo Geral](scope.md)
* [Roadmap do Projeto](../archive/legacy-2026-09-09/02-planning/roadmap.md)
* [Arquitetura de Dados](../architecture/data-flow.md)
