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

