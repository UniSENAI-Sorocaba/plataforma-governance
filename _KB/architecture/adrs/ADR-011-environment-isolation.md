---
id: ADR-011
status: Accepted
date: 2026-09-10
owners: [Cloud & DevOps, Database]
---

# Isolamento de ambientes AWS

Production é isolado de non-production e nunca compartilha banco lógico/dados. Development e staging podem compartilhar recursos apenas sem comprometer segurança, integridade e testabilidade.
