---
title: "Cerimônias e Ritos Scrum"
domain: "governance"
status: "accepted"
owner: "Fellipe Raszejas / Luciano Jr"
last_updated: "2026-08-27"
---

# 🔄 Cerimônias & Ritos Scrum

Especificação dos ritos ágeis quinzenais, sua periodicidade, duração, participantes, entradas e saídas esperadas.

```
+--------------------------------------------------------------------------------------------------------------------+
| CERIMÔNIA          | FREQUÊNCIA / DIA    | DURAÇÃO | PARTICIPANTES      | ENTRADAS          | SAÍDAS               |
+--------------------+---------------------+---------+--------------------+-------------------+----------------------+
| **Sprint Planning**| 1º dia da Sprint    | 2h00    | Time Completo (25) | Backlog Refinado  | Sprint Backlog e Goal|
| **Daily Scrum**    | Seg a Sex (início)  | 15 min  | Por Squad (5-6 dev)| Tarefas do dia    | Alinhamento / Bloqueios|
| **Backlog Refine** | Meio da Sprint      | 1h30    | POs + Tech Leads   | Rascunhos de US   | User Stories com DoR |
| **Sprint Review**  | Último dia (tarde)  | 1h00    | Time + Professores | Incremento Pronto | Validação do Produto |
| **Retrospective**  | Último dia (após)   | 45 min  | Time Completo (25) | Métricas da Sprint| Plano de Ação Melhoria|
+--------------------------------------------------------------------------------------------------------------------+
```

---

## 1. Detalhamento Operacional de Cada Cerimônia

### 1.1 Sprint Planning (Planejamento da Sprint)
* **Objetivo:** Definir o **Sprint Goal** e selecionar as User Stories do topo do backlog que atendem à Definition of Ready (DoR).
* **Dinâmica:** O PO apresenta as prioridades; os squads quebram as histórias em tarefas técnicas e estimam em Story Points.

### 1.2 Daily Scrum (Reunião Diária)
* **Dinâmica:** Realizada internamente por cada squad (15 min) respondendo:
  1. *O que concluí desde a última Daily?*
  2. *O que pretendo concluir hoje?*
  3. *Há algum impedimento travando meu progresso?*

### 1.3 Sprint Review (Revisão da Sprint)
* **Dinâmica:** Demonstração ao vivo do incremento de software funcionando no ambiente **AWS Staging** para os professores orientadores e stakeholders.

### 1.4 Sprint Retrospective (Retrospectiva)
* **Dinâmica:** Análise de melhoria contínua do time:
  * *O que correu muito bem?*
  * *O que gerou atrito ou atraso?*
  * *Quais ações práticas adotaremos na próxima Sprint?*

---

## 2. Documentos Relacionados
* [Metodologia Scrum](scrum.md)
* [Definition of Ready](definition-of-ready.md)
* [Definition of Done](definition-of-done.md)
