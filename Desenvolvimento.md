#Aviso: A base está sendo alinhado e corrigida, logo o documento pode conter falhas, porém essas são as informações mais atualizadas que temos:


## 1. Contexto & Diagnóstico Atual

### 1.1 Solução para o Bloqueio da AWS (Infraestrutura sem Custo)
Devido ao término dos créditos gratuitos da AWS, o projeto encontra-se paralisado. A estratégia imediata consiste em eliminar qualquer dependência de serviços pagos no ambiente de desenvolvimento e adotar provedores com *free tier* permanente para staging/produção.

#### Ambiente de Desenvolvimento Local (Imediato)
* **Docker & Docker Compose:** Containerização completa da pilha de software.
* **Storage Local / MinIO:** Substituição do AWS S3 por volumes locais persistentes em desenvolvimento.

#### Ambiente de Staging / Produção (Zero Custo)
* **Frontend (React):** Vercel, Netlify ou GitHub Pages.
* **Backend (PHP):** Render (Free Tier Web Service), Fly.io ou Railway.
* **Banco de Dados:** Neon (PostgreSQL) ou Render (MySQL).
* **Armazenamento de Mídia:** Cloudinary (Free Tier) ou Supabase Storage.

---

## 2. Visão Geral da Nova Sprint

A nova fase do projeto estende a plataforma original (focada em Projetos de Extensão) para suportar também os **Projetos Integradores (PI)**, unificando a autenticação via SSO/JWT, a gestão de equipes, a validação de horas e notas, e a publicação dos resultados em um **Portal Público (Vitrine)**.



# Relatório de Diretrizes e Alinhamento Técnico de Desenvolvimento

---

## 1. Diretrizes de Frontend & UI/UX

* **Paleta de Cores & Tema:** Utilizar estritamente a paleta de cores baseada nos tons de vermelho (identidade visual inspirada no padrão SENAI). O sistema funcionará apenas em Light Mode (sem suporte a modo noturno).
* **Animações e Microinterações:** Permissível o uso de IAs e bibliotecas para gerar efeitos em componentes, desde que sejam sutis, fluidos e naturais. Evitar excessos visuais que causem poluição visual.
* **Componentes de Terceiros:** Permitido o uso de UI Kits e bibliotecas online. A equipe deve realizar uma validação prévia para garantir que os componentes não possuem vulnerabilidades técnicas nem licenças restritivas (riscos judiciais/copyright).
* **Design Anti-Genérico (Fuga do Padrão IA):** Evitar estruturas clichês geradas por IA (como Header fixo + Navbar padrão no topo). A equipe deve buscar referências modernas de UI/UX online (ex: menus laterais/sidebars dinâmicas, painéis modulares, layouts assimétricos) para garantir uma navegação autêntica e não saturada.

---

## 2. Estratégia de Modelagem de Banco de Dados

* **Modelagem Incremental por Sprint:** O banco de dados deve ser construído de forma reduzida e enxuta, mapeando estritamente as entidades e campos necessários para a sprint atual.
* **Evolução Contínua sem "Gambiarras":** Novas tabelas e colunas serão adicionadas à medida que o projeto avançar. É proibido o uso de soluções temporárias ou gambiarras estruturais; todas as atualizações de esquema devem ser feitas via scripts formais de migração (*migrations*) mantendo o histórico de integridade.

---

## 3. Arquitetura Backend & Regras de Negócio Core

* **Autenticação & Autorização Central:** Implementar arquitetura baseada em JWT / OAuth2 com controle de acesso granular baseado em perfis (RBAC - Aluno, Docente, Coordenação, CPA, Admin).
* **Módulos de Negócio Críticos:** Desenvolver a automação para o cálculo de notas dos Projetos Integradores, apuração de horas acumuladas de Extensão e a API de agendamento de recursos institucionais.
* **Comunicação Interequipes:** A equipe de backend deve manter um canal direto e contínuo de testes com as Equipes 3 e 4 para homologação de rotas e validação da integridade dos dados.
* **Padrão de Código em PHP:** O código PHP no backend deve seguir orientações a objetos estritas, aplicando padrões de projeto (*Design Patterns*) e tipagem forte semelhantes às práticas adotadas em C# e Java (Arquitetura em Camadas, Services, Repositories).

---

## 4. Cloud, DevOps & FinOps (Infraestrutura)

* **Resolução do Bloqueio de Cloud (Sem AWS):** A infraestrutura deve ser movida inteiramente para containers Docker para padronizar o ambiente local sem gerar custos.
* **Pipeline de CI/CD:** Implementação de esteiras de automação via GitHub Actions para testes automatizados e deploy contínuo em serviços de staging gratuitos (ex: Render, Vercel ou Neon/Supabase).
* **Infraestrutura como Código (IaC):** Versionamento das configurações dos ambientes e monitoramento de métricas. As decisões de FinOps (gestão de custos zero) serão acompanhadas de perto para alinhamento e aprendizado do time.

---

## 5. Governança, Reporte e Comprovação de Entregas

* **Relatório Individual de Problemas & Resoluções:** Cada participante deverá documentar formalmente em relatórios periódicos todos os impedimentos, bugs e desafios técnicos encontrados durante a sprint, acompanhados da solução implementada.
* **Evidência de Contribuição:** Esses relatórios serão o instrumento oficial de auditoria e comprovação da participação efetiva e evolução individual de cada membro na entrega do projeto (para GitHub).
