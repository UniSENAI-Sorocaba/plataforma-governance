# ADR-002 — Estratégia de Persistência com Isolamento de Schemas no PostgreSQL Único

## Status
Accepted

## Context
Os módulos de negócio possuem fronteiras de domínio bem definidas. O uso de múltiplos bancos de dados RDS físicos aumentaria drasticamente o custo financeiro mensal da AWS e o esforço de manutenção. Por outro lado, misturar todas as tabelas em um único schema `public` geraria acoplamento descontrolado.

## Decision
Adotar **uma única instância gerenciada do Amazon RDS PostgreSQL 16**, particionada semanticamente através de **PostgreSQL Schemas isolados** (`auth`, `academic_pi`, `extension`, `assets`, `institutional`). Cada módulo do backend possui permissões restritas e deve acessar preferencialmente o seu respectivo schema.

## Alternatives Considered
1. **Banco por Microsserviço (Múltiplas instâncias RDS):** Rejeitado devido ao custo excessivo ($150+ apenas em instâncias RDS) e complexidade de manutenção de backups.
2. **Schema Único `public`:** Rejeitado pelo risco de joins acidentais entre domínios e perda de limites semânticos.

## Consequences
* **Positivas:**
  * Custo de persistência otimizado em uma única instância RDS Multi-AZ.
  * Isolamento semântico claro de tabelas e enums.
  * Possibilidade de integridade referencial nativa quando justificada.
  * Backups consolidados e rotinas de PITR unificadas.
* **Negativas:**
  * Requer configuração explícita de schemas nas ferramentas de ORM (Prisma/TypeORM).

## Related Documents
- [Arquitetura de Dados](../data-architecture.md)
- [Diretrizes de Banco de Dados](../../04-development/database-guidelines.md)
