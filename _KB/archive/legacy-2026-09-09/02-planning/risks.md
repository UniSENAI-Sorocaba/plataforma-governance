---
title: "Gestão de Riscos e Matriz de Contingência"
domain: "planning"
status: "accepted"
owner: "Luciano Jr / Fellipe Raszejas"
last_updated: "2026-08-27"
---

# ⚠️ Gestão de Riscos & Matriz de Contingência

Registro de riscos do projeto (Risk Register) com probabilidades, impactos, severidade ponderada, ações preventivas e planos de contingência operacional.

---

## 1. Matriz de Riscos (Risk Register)

| ID | Risco Identificado | Probabilidade | Impacto | Severidade | Ação Preventiva (Mitigação) | Plano de Contingência |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| **R01** | **Escopo excessivo para 14 semanas** | Alta | Alta | **Crítica** | Corte estrito de escopo: isolamento rígido do Core MVP nas Sprints 0-4; expansão apenas após homologação da v1.0. | Congelar módulos secundários (Patrimônio e CPA) caso o MVP atrase na Sprint 3. |
| **R02** | **Sobrecarga de Luciano Jr como gargalo** | Alta | Alta | **Crítica** | Modelo de governança por delegação com owners técnicos claros para cada frente (RACI formal). | Líderes de área (Marco, Fazano, Nicolas, Nicolle, Isabelly) assumem aprovações táticas diretamente. |
| **R03** | **Custos AWS acima do orçamento semestral** | Média | Alta | **Alta** | AWS Budgets com alarmes rígidos de $120/mês + auto-stop de contêineres de Staging fora do horário comercial. | Reduzir instâncias para single-task, desabilitar NAT Gateway redundante e expirar logs CloudWatch em 7 dias. |
| **R04** | **Falha de integração ou quebra de schema no banco** | Média | Alta | **Alta** | Regra de migrations retrocompatíveis (*Expand and Contract*) + validação pré-merge via Testcontainers. | Rollback imediato da migration via script versionado e restauração de snapshot RDS PITR. |
| **R05** | **Desalinhamento de contratos entre Front e Back** | Média | Média | **Média** | Compartilhamento obrigatório de DTOs e tipos TypeScript através do pacote `packages/shared-types`. | Geração automatizada de SDK cliente via Orval / OpenAPI Generator. |
| **R06** | **Vulnerabilidade de segurança ou vazamento de segredos** | Baixa | Alta | **Alta** | Verificação SAST (Trivy), pre-commit com Gitleaks, chaves RSA no AWS Secrets Manager e TLS 1.3 forçado. | Revogação imediata de tokens e rotação emergencial de chaves RSA via Secrets Manager. |

---

## 2. Documentos Relacionados
* [Mapeamento de Dependências](dependencies.md)
* [Matriz RACI](../09-governance/raci.md)
* [FinOps e Custos](../07-devops/finops.md)
