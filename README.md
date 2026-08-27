# 🎓 Plataforma Integrada de Extensão, Acadêmico & Gestão Institucional

Plataforma unificada para gestão de Projetos Integradores, Extensão Universitária, Portal Público Vitrine, Recursos Patrimoniais, Carreira e Comunicação Institucional (CPA/Ouvidoria).

> 📚 **Documentação Oficial e Base de Conhecimento:** Consulte a pasta [`_KB/`](_KB/00-index/README.md) para a Knowledge Base completa, arquitetura, ADRs, user stories, diretrizes e runbooks.

---

## 🎯 Escopo do Projeto & Priorização Oficial

Para garantir a entrega de um produto de software robusto, estável e testado até o **início de dezembro (2026.2)** por uma equipe de 25 desenvolvedores, o escopo está formalmente dividido em:

### 🚀 1. Escopo Obrigatório — Dezembro (MVP do Semestre)
1. **Autenticação & Autorização Central (SSO/IAM):**
   * Central unificada de autenticação para todos os módulos.
   * Gestão de perfis e níveis de acesso (Aluno, Docente, Coordenação, CPA, Administrador).
   * Sessões seguras e Single Sign-On via JWT (RS256) e OAuth2.
2. **Projetos Integradores & Extensão Universitária:**
   * **Captação de Projetos:** Submissão e validação de propostas de projetos integradores e de extensão (incluindo modelos híbridos).
   * **Gestão de Equipes/Alunos:** Alocação de estudantes em projetos com acompanhamento de status.
   * **Avaliação Docente:** Módulo para avaliação de desempenho e entregas por professores avaliadores com rubricas.
   * **Cálculo de Horas:** Apuração e controle automatizado de horas de extensão para cumprimento curricular (Resolução CNE).
   * **Cálculo de Notas:** Consolidação e lançamento automatizado de notas para Projetos Integradores.
   * **Certificação Digital:** Emissão automatizada de certificados em PDF com hash SHA-256 e validação pública.
3. **Portal Público (Vitrine de Ações):**
   * Website público responsivo contendo o catálogo de projetos de extensão e integradores desenvolvidos.
   * Divulgação do impacto das ações na comunidade e módulo de prestação de contas social.
   * Busca e filtros avançados por curso/ODS, página individual dos projetos e validador público de certificados.

---

### ⏳ 2. Backlog / Fase 2 (Postergado para o Próximo Semestre)
* **Gestão Patrimonial:** Controle de notebooks (QR Code, check-in/out), agendamento de salas e ocorrências de avarias.
* **Carreira & Oportunidades:** Banco de currículos de alunos e mural de vagas de estágio/trainee.
* **Iniciação Científica & Tecnológica:** Editais de pesquisa, bolsas de fomento e relatórios de IC/IT.
* **CPA & Ouvidoria Institucional:** Autoavaliação periódica, avaliação de serviços/cantina e canal confidencial de relatos.

---

## 👥 Estrutura Organizacional da Equipe (25 Integrantes)

* **Product Owner Titular:** Fellipe Raszejas
* **Product Owner Auxiliar / Líder Técnico Geral:** Luciano Jr
* **Lideranças Técnicas de Especialidade:**
  * **Frontend:** Nicolas Leão
  * **Backend:** Marco
  * **Banco de Dados:** Isabelly
  * **Cloud / DevOps:** Fazano
  * **Qualidade & QA:** Nicolle

### Squads Multifuncionais (Foco no MVP de Dezembro):
1. **Squad Core & SSO:** Auth central, IAM, infraestrutura AWS Terraform, CI/CD e Design System.
2. **Squad Acadêmico:** Captação de propostas de PI, equipes, bancas examinadoras, avaliação por rubricas e notas.
3. **Squad Extensão & Horas:** Editais de extensão, relatórios de atividades, validação de horas e certificados.
4. **Squad Portal Público & QA Core:** Vitrine pública, módulo de prestação de contas social, testes E2E, carga e segurança.

---

## ☁️ Arquitetura Técnica & Stack

* **Padrão Arquitetural:** Modular Monolith (Monólito Modular) em Node.js/TypeScript (NestJS).
* **Frontends:** Next.js 14 (App Router) + Tailwind CSS + Shadcn UI (Monorepo Turborepo + pnpm).
* **Banco de Dados:** Amazon RDS PostgreSQL 16 com isolamento semântico por Schemas (`auth`, `academic_pi`, `extension`).
* **Cloud & DevOps:** AWS (ECS Fargate, ALB, S3, CloudFront, WAF, Secrets Manager, CloudWatch) provisionado via Terraform com pipelines de CI/CD no GitHub Actions.

---

## 🚀 Guia Rápido de Inicialização Local

```bash
# 1. Clonar o repositório
git clone https://github.com/instituicao/plataforma-digital.git
cd plataforma-digital

# 2. Instalar dependências
pnpm install

# 3. Subir banco de dados local via Docker
docker compose -f infra/docker/docker-compose.yml up -d

# 4. Executar migrations e seed inicial
pnpm --filter api-server db:migrate
pnpm --filter api-server db:seed

# 5. Iniciar em modo desenvolvimento
pnpm turbo run dev
```

* **API Swagger:** `http://localhost:3000/api/docs`
* **Painel Admin:** `http://localhost:3001`
* **Portal Público:** `http://localhost:3002`

---

## 📖 Mapa da Base de Conhecimento (`_KB/`)

Para detalhes completos de engenharia, consulte:
* [`_KB/00-index/`](_KB/00-index/README.md) — Índice Geral e Navegação
* [`_KB/01-product/`](_KB/01-product/mvp.md) — Visão de Produto, Escopo e Delimitação do MVP
* [`_KB/02-planning/`](_KB/02-planning/roadmap.md) — Roadmap de Dezembro, Backlog e Sprints
* [`_KB/03-architecture/`](_KB/03-architecture/overview.md) — Arquitetura do Sistema e ADRs
* [`_KB/04-development/`](_KB/04-development/setup.md) — Padrões de Código, Git e APIs
* [`_KB/05-security/`](_KB/05-security/overview.md) — SSO, IAM, RBAC e Segurança
* [`_KB/06-infrastructure/`](_KB/06-infrastructure/overview.md) — AWS, Terraform e Docker
* [`_KB/07-devops/`](_KB/07-devops/ci-cd.md) — CI/CD, Observabilidade e FinOps
* [`_KB/08-quality/`](_KB/08-quality/strategy.md) — Estratégia de QA, E2E e Testes de Carga
* [`_KB/09-governance/`](_KB/09-governance/team-structure.md) — Equipes, RACI, Scrum, DoR e DoD
* [`_KB/10-runbooks/`](_KB/10-runbooks/local-development.md) — Procedimentos Operacionais Passo a Passo
