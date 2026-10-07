---
id: ADR-011
status: Accepted
date: 2026-09-10
owners: [Cloud & DevOps, Database]
---

# Isolamento de ambientes AWS

Production é isolado de non-production e nunca compartilha banco lógico/dados. Development e staging podem compartilhar recursos apenas sem comprometer segurança, integridade e testabilidade.

Nota (2026-10-07): com o ADR-012, apenas production existe na AWS; development e a validação efêmera executam fora da nuvem, e o isolamento é garantido por construção.
