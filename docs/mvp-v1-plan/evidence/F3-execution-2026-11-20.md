# Evidências de execução — F3

**Data:** 2026-11-20  
**Escopo:** DB-008/DB-011, BE-007/BE-011 e FE-009 — projetos, participação e entregáveis
**Branches de trabalho:** `f3-db-011-deliverables`, `f3-be-011-deliverables`, `f3-fe-009-deliverables`, `f3-inf-010-storage`, `f6-qa-browser-e2e`, `f6-inf-008-secrets`

## Entregas realizadas

- Modelo PostgreSQL para projetos, responsáveis, períodos, solicitações e participantes.
- Regras de integridade para mínimo de um responsável, janela de período, unicidade por termo e limites de participação por termo acadêmico.
- API JDBC/Spring para criar e consultar projetos, publicar/despublicar, arquivar/reabrir, criar período, solicitar participação, decidir, desistir e remover participante.
- Política de autorização por rota e escopo para docente, coordenação, aluno e responsável pelo projeto.
- Contrato OpenAPI atualizado para os endpoints entregues.
- Migration V0011 para metadados de entregáveis, hashes de tokens, lifecycle e vínculo ao participante.
- API de upload/download temporário com validação de extensão/MIME/tamanho, SHA-256 e storage local configurável.
- Interface de upload para aluno aprovado, com cancelamento e estados acessíveis.
- Módulo Terraform de bucket privado, versionado, cifrado com KMS, com lifecycle e política TLS.

## Validações executadas

### Backend

Comando executado em `plataforma-backend`:

```text
mvn --batch-mode verify -q
```

Resultado: **BUILD SUCCESS**, incluindo a cobertura unitária da regra de negócio de upload.

### Banco de dados

Comando executado em `plataforma-database`:

```text
make validate
```

Resultado: validações de schemas, migrações, integridade, RBAC, seeds, constraints e modelo de projetos concluídas com sucesso.

Também foi aplicada a V0011 no banco local e validado o vínculo obrigatório do entregável a participante/período.

### Frontend e infraestrutura

- `npm run check` em `plataforma-frontend`: lint, typecheck, 21 testes e build aprovados.
- `make validate` em `plataforma-infrastructure`: formatação e validação Terraform aprovadas para roots e módulos.
- `make up && make init && make plan` em `plataforma-infrastructure`: plano local do root de development aprovado com 11 recursos para criação, incluindo KMS, Secrets Manager e storage.

### E2E com banco real

Fluxo executado contra backend local configurado com JWT e PostgreSQL real:

1. autenticação de aluno e coordenador;
2. criação de período vigente;
3. aprovação da solicitação de participação;
4. emissão da URL temporária de upload para o participante;
5. envio de arquivo PDF;
6. confirmação de status `AVAILABLE`, hash SHA-256 e URL temporária de download;
7. download do mesmo conteúdo e comparação do payload.

Resultado: fluxo aprovado sem alteração manual no banco.

### E2E de navegador

Comando executado em `plataforma-quality`:

```text
npm run test:e2e:t13
```

Resultado: **passed** contra backend, PostgreSQL e frontend reais, cobrindo login, visualização da solicitação aprovada, seleção do arquivo, upload e confirmação visual `Arquivo enviado com segurança.`.

### Consistência estática

- `git diff --check` sem ocorrências no backend e no banco.
- OpenAPI carregado com sucesso por parser YAML.

## Limitações conhecidas

- A configuração de e-mail permanece fora do escopo desta entrega, conforme decisão registrada.
- O apply contra AWS não foi executado; a configuração foi validada e o root de development foi planejado no MiniStack. O material secreto não é versionado.

## Integração

- Backend: PR [#61](https://github.com/UniSENAI-Sorocaba/plataforma-backend/pull/61), merge `9eda99d`, e follow-up [#62](https://github.com/UniSENAI-Sorocaba/plataforma-backend/pull/62), merge `1b1172f`.
- Database: PR [#46](https://github.com/UniSENAI-Sorocaba/plataforma-database/pull/46), merge `891200f`.
- Frontend: PR [#64](https://github.com/UniSENAI-Sorocaba/plataforma-frontend/pull/64), merge `6a1d3f9`.
- Infrastructure: PR [#35](https://github.com/UniSENAI-Sorocaba/plataforma-infrastructure/pull/35), merge `7aefc2c`.
- Quality: PR [#62](https://github.com/UniSENAI-Sorocaba/plataforma-quality/pull/62), merge `c71ba084`.
- Infrastructure: PR [#36](https://github.com/UniSENAI-Sorocaba/plataforma-infrastructure/pull/36), merge `3ca05c5`.
