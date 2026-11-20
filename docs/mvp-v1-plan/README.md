# Plano de Implementação — MVP e V1 Funcional

**Versão:** 1.0  
**Data de elaboração:** 2026-11-19  
**Status:** Proposta operacional para execução e revisão do PO  
**Escopo:** SSO/IAM, Projetos Integradores, Extensão, Portal Público, plataforma operacional e qualidade

## Objetivo

Conduzir os seis repositórios da Plataforma Digital — backend, database, frontend, governance, infrastructure e quality — de um estado de bootstrap e funcionalidades parcialmente integradas para uma versão MVP funcional, operável e implantável em staging, seguida da V1 com gates de segurança, performance, operação e go/no-go. A evidência usa logs técnicos sanitizados; não há auditoria persistente de negócio.

Este pacote transforma o [MVP baseline](../../_KB/product/mvp-baseline.md) em uma sequência de execução com fases, subfases, etapas, responsáveis, métricas de aceite, evidências e dependências.

## Documentos do pacote

1. [Plano mestre e roadmap de fases](./00-plano-mestre.md)
2. [Modelo de agentes, governança e operação](./01-agentes-e-governanca.md)
3. [Fundação, IAM e integração inicial](./02-fundacao-e-iam.md)
4. [Projetos, extensão e certificação](./03-projetos-extensao-e-certificacao.md)
5. [Portal público e experiência de usuário](./04-portal-publico.md)
6. [Release V1, DevSecOps e go/no-go](./05-release-v1-e-go-no-go.md)
7. [Matriz de métricas, aceite e evidências](./06-matriz-de-aceite.md)
8. [Catálogo operacional de tasks](./07-catalogo-de-tasks.md)
9. [Template de Issue e Pull Request](./08-template-de-issue-e-pr.md)
10. [Índice de tasks individuais](./tasks/README.md)

## Regra de uso

Uma etapa só pode ser marcada como concluída quando possuir código integrado, testes executados, evidência versionada e revisão pelo agente revisor. Documento, issue fechada ou branch existente não constituem aceite funcional isoladamente.

## Agentes utilizados

As fases e tasks deste pacote usam os agentes especializados definidos na raiz em [`../../../.agents/README.md`](../../../.agents/README.md). A atribuição detalhada está nos arquivos individuais de task; os caminhos `.agents/*.md` são a referência operacional do executor, revisor e validador.

## Fora do MVP/V1

Gestão patrimonial, carreiras/oportunidades, iniciação científica, CPA/ouvidoria, login social, MFA avançado, biometria e aplicativo mobile permanecem em Future/2027.1.
