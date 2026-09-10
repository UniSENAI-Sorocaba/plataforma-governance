---
title: "Glossário de Termos do Projeto"
domain: "index"
status: "accepted"
owner: "Luciano Jr"
last_updated: "2026-08-27"
---

# 📖 Glossário Unificado de Termos

Glossário consolidado de termos técnicos, conceituais, metodológicos e institucionais utilizados na documentação e no código do projeto.

| Termo | Significado / Sigla | Contexto no Projeto |
| :--- | :--- | :--- |
| **ADR** | Architecture Decision Record | Documento que registra uma decisão arquitetural importante, seu contexto e consequências. |
| **ALB** | Application Load Balancer | Balanceador de carga gerenciado da AWS que distribui tráfego HTTPS para as instâncias ECS. |
| **Argon2id** | Algoritmo de Hashing de Senhas | Algoritmo de derivação de chave e hashing criptográfico resistente a ataques de GPU/ASIC. |
| **BDD** | Behavior-Driven Development | Prática de especificação de comportamentos do sistema em formato legível (*Dado/Quando/Então*). |
| **CI/CD** | Continuous Integration / Continuous Deployment | Pipeline automatizada no GitHub Actions para validação de qualidade, testes e implantação. |
| **CPA** | Comissão Própria de Avaliação | Órgão institucional acadêmico responsável pela autoavaliação dos cursos e serviços da faculdade. |
| **DAST** | Dynamic Application Security Testing | Teste de segurança em tempo de execução realizado na aplicação em Staging (via OWASP ZAP). |
| **DDD** | Domain-Driven Design | Abordagem de design de software focada na modelagem orientada ao domínio de negócio. |
| **DoD** | Definition of Done | Critérios de qualidade objetivos e obrigatórios para que uma User Story seja considerada concluída. |
| **DoR** | Definition of Ready | Critérios que uma User Story deve atender antes de poder ser puxada para o Sprint Backlog. |
| **DORA** | DevOps Research and Assessment | Conjunto de 4 métricas de desempenho de engenharia (Deployment Frequency, Lead Time, CFR, MTTR). |
| **ECR** | Elastic Container Registry | Registro gerenciado de imagens Docker da AWS utilizado no pipeline de deploy. |
| **ECS** | Elastic Container Service (Fargate) | Serviço de orquestração de contêineres serverless da AWS onde o backend é executado. |
| **FinOps** | Cloud Financial Management | Prática de governança e controle contínuo dos custos de infraestrutura em nuvem na AWS. |
| **Gherkin** | Sintaxe de Especificação de Cenários | Linguagem estruturada com palavras-chave (*Scenario, Given, When, Then*) para critérios de aceite. |
| **IAM** | Identity and Access Management | Mecanismos de gerenciamento de identidades, credenciais e permissões de usuários. |
| **IaC** | Infrastructure as Code | Gerenciamento e provisionamento automatizado da infraestrutura AWS via scripts Terraform. |
| **JWT** | JSON Web Token | Token autocontido assinado digitalmente (RS256) utilizado para autenticação sem estado. |
| **LGPD** | Lei Geral de Proteção de Dados | Legislação brasileira que regula o tratamento de dados pessoais (aplicada em logs e perfis). |
| **Monólito Modular**| Modular Monolith | Padrão arquitetural com base de código única, implantável como um único contêiner, mas internamente isolada em módulos de domínio. |
| **MVP** | Minimum Viable Product | Versão essencial e funcional da plataforma entregue até a Sprint 4 com os módulos prioritários. |
| **OIDC** | OpenID Connect | Camada de identidade sobre o protocolo OAuth 2.0 que fornece autenticação centralizada. |
| **OWASP** | Open Web Application Security Project | Comunidade de segurança que publica os 10 riscos mais críticos em aplicações web. |
| **PI** | Projeto Integrador | Componente curricular semestral obrigatório onde alunos desenvolvem projetos multidisciplinares em grupo. |
| **PKCE** | Proof Key for Code Exchange | Extensão de segurança do OAuth 2.0 que protege o fluxo de autorização contra interceptação. |
| **pnpm** | Performant Node Package Manager | Gerenciador de pacotes permitido no repositório frontend. |
| **RACI** | Responsible, Accountable, Consulted, Informed | Matriz de governança que mapeia quem faz, quem aprova, quem é consultado e quem é informado. |
| **RBAC** | Role-Based Access Control | Controle de acesso baseado em papéis (Student, Professor, Coordinator, CPA, Admin). |
| **RDS** | Relational Database Service | Banco de dados relacional gerenciado da AWS (utilizado com PostgreSQL 16). |
| **RS256** | RSA Signature with SHA-256 | Algoritmo criptográfico assimétrico usado para assinar tokens JWT com par de chaves pública/privada. |
| **SAST** | Static Application Security Testing | Análise estática do código-fonte para detecção precoce de vulnerabilidades (via SonarQube/Trivy). |
| **SemVer** | Semantic Versioning | Padrão de versionamento numérico no formato `MAJOR.MINOR.PATCH` (ex: `v1.0.0`). |
| **SSO** | Single Sign-On | Sistema que permite ao usuário autenticar-se uma única vez e acessar todos os módulos autorizados. |
| **Story Points** | Pontos de História | Unidade de medida relativa utilizada para estimar o esforço e complexidade de uma User Story. |
| **Testcontainers**| Framework de Testes de Integração | Biblioteca que executa instâncias reais do PostgreSQL em contêineres Docker temporários durante testes. |
| **Turborepo** | Ferramenta de Monorepo | Ferramenta usada apenas na baseline histórica; não integra a arquitetura multi-repo vigente. |
| **VPC** | Virtual Private Cloud | Rede virtual isolada na AWS onde os servidores e bancos de dados são executados de forma privada. |
| **WAF** | Web Application Firewall | Firewall de aplicação da AWS configurado no ALB para bloquear ataques cibernéticos comuns. |
