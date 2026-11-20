# Evidências de execução — F3

**Data:** 2026-11-20  
**Escopo:** DB-008 e BE-007 — projetos, períodos e participação  
**Branches de trabalho:** `f3-db-008-projects-participation`, `f3-be-007-proposals`

## Entregas realizadas

- Modelo PostgreSQL para projetos, responsáveis, períodos, solicitações e participantes.
- Regras de integridade para mínimo de um responsável, janela de período, unicidade por termo e limites de participação por termo acadêmico.
- API JDBC/Spring para criar e consultar projetos, publicar/despublicar, arquivar/reabrir, criar período, solicitar participação, decidir, desistir e remover participante.
- Política de autorização por rota e escopo para docente, coordenação, aluno e responsável pelo projeto.
- Contrato OpenAPI atualizado para os endpoints entregues.

## Validações executadas

### Backend

Comando executado em `plataforma-backend`:

```text
mvn --batch-mode test
```

Resultado: **BUILD SUCCESS**, 66 testes executados, 0 falhas, 0 erros e 0 ignorados.

### Banco de dados

Comando executado em `plataforma-database`:

```text
make validate
```

Resultado: validações de schemas, migrações, integridade, RBAC, seeds, constraints e modelo de projetos concluídas com sucesso.

Também foi validada a regra de limite de participação por termo acadêmico após a correção da função da migration V0008, registrada em V0009.

### Consistência estática

- `git diff --check` sem ocorrências no backend e no banco.
- OpenAPI carregado com sucesso por parser YAML.

## Limitações conhecidas

- Ainda não foi executado E2E de navegador contra backend e banco reais nesta evidência.
- A configuração de e-mail permanece fora do escopo desta entrega, conforme decisão registrada.
- A integração de telas do frontend com os endpoints da F3 ainda é uma etapa posterior.
