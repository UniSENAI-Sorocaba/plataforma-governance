---
title: "Matriz de Perfis e Permissões IAM / RBAC"
domain: "security"
status: "accepted"
owner: "Luciano Jr"
last_updated: "2026-08-27"
---

# 👥 Matriz de Perfis e Permissões IAM / RBAC

Definição formal dos papéis de usuário (`UserRole`) e matriz de direitos de acesso a recursos e operações do sistema.

---

## 1. Definição dos Perfis de Usuário (Roles)
* `STUDENT` (Aluno): Acesso a submissões próprias de PI, envio de atividades de extensão, emissão de certificados e reserva de notebooks.
* `PROFESSOR` (Docente): Acesso a bancas examinadoras alocadas, lançamento de notas, orientação de projetos e deferimento de horas.
* `COORDINATOR` (Coordenação): Visão macro e analítica dos cursos, homologação de turmas, relatórios MEC e gestão de salas.
* `CPA` (Membro CPA / Ouvidoria): Gestão de pesquisas institucionais, relatórios consolidados e tramitação confidencial de relatos.
* `ADMIN` (Administrador de TI): Controle total de usuários, papéis, auditoria de logs e configurações da plataforma.

---

## 2. Matriz de Permissões por Operação

| Módulo / Operação | STUDENT | PROFESSOR | COORDINATOR | CPA | ADMIN |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Criar Proposta de PI** | Próprio | Leitura | Leitura | - | Total |
| **Alocar Bancas de PI** | - | - | Total | - | Total |
| **Avaliar Banca de PI** | - | Se Alocado | Leitura | - | Total |
| **Submeter Horas Extensão** | Próprio | Leitura | Leitura | - | Total |
| **Validar Horas Extensão** | - | Orientador | Total | - | Total |
| **Emitir Certificados** | Próprio | - | Validação | - | Total |
| **Gestão de Notebooks (QR)** | Empréstimo | Empréstimo | Gestão | - | Total |
| **Reserva de Salas** | Solicitar | Solicitar | Aprovar | - | Total |
| **Formulários CPA / Ouvidoria**| Responder | Responder | Responder | Total | Total |
| **Gestão de Usuários / IAM** | - | - | - | - | **Total** |
| **Auditoria de Logs** | - | - | - | - | **Total** |

---

## 3. Documentos Relacionados
* [Autorização](authorization.md)
* [Autenticação](authentication.md)
* [Threat Modeling](threat-model.md)
