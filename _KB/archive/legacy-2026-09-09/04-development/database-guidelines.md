---
title: "Diretrizes de Modelagem e Migrations de Banco de Dados"
domain: "development"
status: "accepted"
owner: "Luciano Jr / Isabelly"
last_updated: "2026-08-27"
---

# 🗄️ Diretrizes de Banco de Dados & Migrations

Boas práticas para modelagem relacional, criação de índices, migrations e consultas de alta performance no PostgreSQL.

---

## 1. Padrões de Modelagem e Nomenclatura
* **Chaves Primárias:** Todas as tabelas de negócio utilizam UUID v4 (`UUID PRIMARY KEY DEFAULT gen_random_uuid()`) para prevenir enumeração de recursos e facilitar sharding futuro. Tabelas puramente associativas podem usar chave composta.
* **Timestamps Obrigatórios:** Toda tabela deve possuir `created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP` e `updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP`.
* **Soft Delete:** Para entidades com relevância histórica ou auditoria acadêmica, utilize a coluna `deleted_at TIMESTAMP WITH TIME ZONE NULL`.
* **Constraints Explícitas:** Sempre declare `CHECK`, `NOT NULL` e `UNIQUE` a nível de banco para garantir consistência de dados independentemente do backend.

---

## 2. Regras de Ouro para Migrations
1. **Migrations Nunca Destrutivas:** Proibido executar `DROP COLUMN` ou `ALTER COLUMN TYPE` direto em produção. Aplique o padrão **Expand and Contract**:
   * *Fase 1 (Expand):* Adicione a nova coluna com suporte a nulos.
   * *Fase 2 (Transition):* Backend escreve em ambas e migra os dados em background.
   * *Fase 3 (Contract):* Remove a coluna antiga em release posterior.
2. **Índices Concorrentes em Tabelas Grandes:** Use `CREATE INDEX CONCURRENTLY` para evitar lock de escrita.
3. **Idempotência de Seeds:** Scripts de seed devem usar `INSERT ... ON CONFLICT DO NOTHING` ou `UPSERT` para permitir reexecução segura.

---

## 3. Documentos Relacionados
* [Arquitetura de Dados](../03-architecture/data-architecture.md)
* [ADR-002 — Isolamento por Schemas](../03-architecture/adr/ADR-002-postgresql-schema-isolation.md)
* [Runbook de Rollback de Migrations](../10-runbooks/rollback.md)
