# Tasks individuais do MVP/V1

Cada arquivo abaixo representa uma unidade de trabalho executável. A task só pode ser encerrada quando o PR estiver integrado, os testes passarem, as evidências forem anexadas e o revisor registrar a aprovação.

## Grupo 0 — Preparação e integração

- [T01 — Consolidar baseline e plano de integração](./T01-baseline-integracao.md)
- [T02 — Congelar contratos de API e erros](./T02-contratos-api-erros.md)
- [T03 — Tornar migrations e seeds reproduzíveis](./T03-migrations-seeds.md)
- [T04 — Preparar pipeline mínimo de CI](./T04-pipeline-ci.md)

## Grupo 1 — Fundação e IAM

- [T05 — Padronizar backend, observabilidade base e healthcheck](./T05-backend-healthcheck.md)
- [T06 — Implementar identidade, vínculo institucional e credenciais](./T06-identidade-credenciais.md)
- [T07 — Implementar login JWT RS256](./T07-login-jwt.md)
- [T08 — Implementar sessão, refresh, logout e recuperação](./T08-sessao-refresh-recuperacao.md)
- [T09 — Implementar RBAC e autorização por rota](./T09-rbac-autorizacao.md)
- [T10 — Implementar logs técnicos sanitizados](./T10-auditoria.md)

## Grupo 2 — Projetos Integradores

- [T11 — Criar modelo de propostas e participação](./T11-propostas.md)
- [T12 — Implementar solicitações e gestão de equipe](./T12-equipes.md)
- [T13 — Implementar entregáveis e upload seguro](./T13-entregaveis-upload.md)

## Grupo 3 — Extensão, avaliação e certificados

- [T14 — Implementar editais e inscrições](./T14-editais-inscricoes.md)
- [T15 — Implementar atividades e horas de extensão](./T15-atividades-horas.md)
- [T16 — Implementar avaliações e vínculos](./T16-bancas-conflitos.md)
- [T17 — Implementar rubricas e cálculo de notas](./T17-rubricas-notas.md)
- [T18 — Emitir e validar certificado](./T18-certificados.md)

## Grupo 4 — Portal público

- [T19 — Implementar catálogo, filtros e paginação](./T19-catalogo-filtros.md)
- [T20 — Implementar workflow de impacto publicado](./T20-impacto-publicado.md)
- [T21 — Implementar SEO, acessibilidade e Web Vitals](./T21-seo-acessibilidade.md)

## Grupo 5 — V1, segurança e operação

- [T22 — Criar suíte E2E das jornadas P0](./T22-e2e-p0.md)
- [T23 — Configurar SAST, SCA, secrets, container e IaC scans](./T23-scans-seguranca.md)
- [T24 — Executar teste de carga e corrigir gargalos](./T24-teste-carga.md)
- [T25 — Implantar observabilidade e alertas](./T25-observabilidade.md)
- [T26 — Implementar backup, restore e retenção](./T26-backup-restore.md)
- [T27 — Ensaiar deploy, smoke e rollback](./T27-deploy-rollback.md)
- [T28 — Fechar pacote de homologação e go/no-go](./T28-go-no-go.md)

## Regra comum

Toda task deve possuir Issue, PR, commit integrado, testes executados, evidência de aceite, revisor e risco residual documentado.
