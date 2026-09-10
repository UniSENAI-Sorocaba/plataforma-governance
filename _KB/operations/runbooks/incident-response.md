---
title: "Runbook: Resposta a Incidentes e Indisponibilidade"
domain: "runbooks"
status: "accepted"
owner: "Luciano Jr / Fazano / Marco"
last_updated: "2026-08-27"
---

# 📖 Runbook: Resposta a Incidentes & Indisponibilidade

Procedimento padrão de triagem, comunicação, mitigação e resolução de incidentes críticos em produção (SEV-1 e SEV-2).

---

## 1. Níveis de Severidade de Incidentes

| Nível | Definição | SLA de Resposta | Responsável pela Ação |
| :--- | :--- | :--- | :--- |
| **SEV-1 (Crítico)** | Sistema completamente fora do ar ou perda/vazamento iminente de dados. | $\le 15\text{ min}$ | Luciano Jr, Fazano e Marco |
| **SEV-2 (Alto)** | Funcionalidade crítica inoperante (ex: login impossível ou notas não salvam). | $\le 30\text{ min}$ | Tech Lead do Módulo + Squad |
| **SEV-3 (Médio)** | Erro em funcionalidade secundária com contorno disponível (workaround). | $\le 4\text{ horas}$ | Squad responsável |

---

## 2. Fluxo de Ação em Incidentes SEV-1 (Queda da API)

1. **Identificação e Alerta:** O alarme do CloudWatch notifica o canal `#incidents-alerts` no Slack/Discord.
2. **War Room:** O Cloud Lead (Fazano) e o Tech Lead Geral (Luciano Jr) abrem chamada de emergência.
3. **Triagem Rápida:**
   * Verificar se as tasks do ECS estão reiniciando em loop (*CrashLoop*):
     ```bash
     aws ecs describe-services --cluster plataforma-cluster-prod --services plataforma-api-prod
     ```
   * Consultar logs de erro recentes no CloudWatch:
     ```bash
     aws logs filter-log-events --log-group-name /aws/ecs/plataforma-api-prod --filter-pattern "ERROR"
     ```
4. **Ação de Mitigação Imediata:**
   * Se o erro ocorreu logo após um deploy recente: **Executar Rollback Imediato** para a versão anterior.
   * Se o problema for sobrecarga de CPU/banco: Aumentar a contagem de tasks ECS ou reiniciar instâncias zumbis.
5. **Comunicação:** O PO (Fellipe Raszejas) publica aviso de instabilidade para os usuários.
6. **Post-Mortem:** Em até 48 horas após a normalização, redigir o documento de análise de causa-raiz e melhorias preventivas.

---

## 3. Documentos Relacionados
* [Runbook de Rollback](rollback.md)
* [Observabilidade](../../engineering/observability.md)
* [Disaster Recovery](../infrastructure.md)
