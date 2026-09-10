---
title: "Guia de Setup e Inicialização do Ambiente Local"
domain: "development"
status: "accepted"
owner: "Luciano Jr / Nicolas Leão / Marco"
last_updated: "2026-08-27"
---

# 🚀 Guia de Setup & Inicialização do Ambiente Local

Este guia orienta novos desenvolvedores a configurarem e executarem toda a plataforma localmente em menos de 15 minutos.

---

## 1. Pré-Requisitos de Software

Antes de iniciar, certifique-se de que sua máquina possui as seguintes ferramentas instaladas:
* **Node.js:** Versão 20 LTS (`v20.x`)
* **pnpm:** Versão 9+ (`npm install -g pnpm`)
* **Docker & Docker Compose:** Versão 24+ com WSL2 (no Windows) ou nativo no Linux/macOS.
* **Git:** Versão 2.40+

---

## 2. Passo a Passo de Execução

### Passo 1: Clonar o Repositório
```bash
git clone https://github.com/instituicao/plataforma-digital.git
cd plataforma-digital
```

### Passo 2: Instalar Dependências do Monorepo
```bash
pnpm install
```

### Passo 3: Configurar Variáveis de Ambiente
Copie o arquivo de exemplo para o arquivo local `.env`:
```bash
cp .env.example .env
```

### Passo 4: Subir Banco de Dados e Serviços Locais (Docker Compose)
```bash
docker compose -f infra/docker/docker-compose.yml up -d
```

### Passo 5: Executar Migrations e Seed Inicial do Banco
```bash
pnpm --filter api-server db:migrate
pnpm --filter api-server db:seed
```

### Passo 6: Iniciar Todas as Aplicações em Modo Desenvolvimento
```bash
pnpm turbo run dev
```

---

## 3. URLs e Portas Locais

| Aplicação / Serviço | URL de Acesso Local | Descrição |
| :--- | :--- | :--- |
| **API Backend REST** | `http://localhost:3000` | Backend Modular Monolith |
| **Documentação Swagger** | `http://localhost:3000/api/docs` | Especificação OpenAPI interativa |
| **Painel Administrativo** | `http://localhost:3001` | Frontend Web Admin (Next.js) |
| **Portal Público** | `http://localhost:3002` | Frontend Web Portal Vitrine (Next.js) |
| **PostgreSQL Database** | `localhost:5432` | Banco local (user: `postgres`, pass: `postgres`, db: `plataforma_db`) |

---

## 4. Credenciais Padrão de Seed Local

* **Administrador:** `admin@universidade.edu.br` / `Senha@123456`
* **Docente:** `docente@universidade.edu.br` / `Senha@123456`
* **Aluno:** `aluno@universidade.edu.br` / `Senha@123456`

---

## 5. Documentos Relacionados
* [Estrutura do Monorepo](repository-structure.md)
* [Padrões de Código](coding-standards.md)
* [Runbook de Desenvolvimento](../10-runbooks/local-development.md)
