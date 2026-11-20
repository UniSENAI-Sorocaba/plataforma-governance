---
title: "Personas do Sistema e Perfis de Usuário"
domain: "product"
status: "accepted"
owner: "Fellipe Raszejas / Luciano Jr"
last_updated: "2026-08-27"
---

# 🧑‍💻 Personas do Sistema e Perfis de Usuário

Mapeamento detalhado das personas representativas dos usuários da plataforma, suas dores atuais e jornadas ideais de uso.

---

## 1. Persona 1: Aluno de Graduação (Lucas, 21 anos)
* **Perfil:** Estudante de Ciência da Computação / Engenharia, necessita submeter seu Projeto Integrador semestral e integralizar 100 horas obrigatórias de extensão universitária para se formar.
* **Dores:**
  * Não sabe quantas horas de extensão já foram deferidas pela coordenação.
  * Envio de comprovantes em formulários de papel ou pastas soltas no Google Drive.
  * Dificuldade de encontrar parceiros de grupo com competências complementares.
* **Jornada na Plataforma:**
  1. Acessa o sistema via login único (SSO).
  2. Consulta projetos e solicita participação durante o período de inscrição.
  3. Inscreve-se em um edital de extensão e faz upload do relatório de atividades.
  4. Acompanha a barra de progresso de horas curriculares e emite o certificado autenticado em PDF.

---

## 2. Persona 2: Docente & Orientador (Profª Dra. Helena, 45 anos)
* **Perfil:** Professora responsável pela orientação de projetos integradores e pelas avaliações sob sua responsabilidade.
* **Dores:**
  * Lançamento manual de notas em planilhas Excel despadronizadas.
  * Cálculo manual de médias ponderadas entre avaliações.
  * Sobrecarga para validar centenas de horas de extensão no final do semestre.
* **Jornada na Plataforma:**
  1. Consulta solicitações de participação e decide aprovar ou negar.
  2. Preenche avaliações via rubricas digitais.
  3. O sistema calcula a nota final automaticamente.
  4. Valida relatórios de extensão com apenas 1 clique (*Aprovar / Recusar com justificativa*).

---

## 3. Persona 3: Coordenador de Curso (Prof. Carlos, 52 anos)
* **Perfil:** Coordenador acadêmico encarregado do cumprimento das diretrizes curriculares do MEC e alocação de recursos físicos.
* **Dores:**
  * Risco de reprovação de alunos por falta de horas de extensão no momento da colação de grau.
  * Dificuldade de consolidar avaliações e acompanhar horas de extensão.
* **Jornada na Plataforma:**
  1. Acessa o Dashboard Acadêmico com a visão macro do status de todos os grupos de PI.
  2. Exporta relatórios auditáveis de extensão com conformidade regulatória.
  3. Consulta indicadores acadêmicos e acompanha os projetos sob sua coordenação.

---

## 4. Persona 4: Membro da CPA / Ouvidor (Dra. Vanessa, 39 anos)
* **Perfil:** Responsável pela autoavaliação institucional periódica e acolhimento de manifestações da comunidade acadêmica.
* **Dores:**
  * Baixa adesão dos alunos aos questionários de avaliação por medo de quebra de anonimato.
  * Dificuldade de compilar feedbacks sobre cantina, atendimento e infraestrutura.
* **Jornada na Plataforma:**
  1. Publica questionários institucionais periódicos com garantia criptográfica de sigilo.
  2. Recebe relatos confidenciais e tramita com status (*Em Análise*, *Respondido*, *Encaminhado*).
  3. Visualiza gráficos consolidados para o relatório anual do MEC.

---

## 5. Persona 5: Visitante Externo / Recrutador (Mariana, 30 anos)
* **Perfil:** Gerente de RH de uma empresa de tecnologia parceira que busca estagiários e projetos inovadores para patrocínio.
* **Dores:**
  * Falta de visibilidade dos projetos de ponta produzidos pela universidade.
* **Jornada na Plataforma:**
  1. Acessa o Portal Público sem necessidade de login.
  2. Filtra projetos por área temática, tecnologia ou Objetivo de Desenvolvimento Sustentável (ODS).
  3. Visualiza a página pública do projeto com links para o GitHub, vídeo de demonstração e contato dos alunos.

---

## 6. Documentos Relacionados
* [Módulos do Sistema](modules.md)
* [User Stories](../specs/README.md)
* [Matriz de Permissões RBAC](../security/policy.md)
