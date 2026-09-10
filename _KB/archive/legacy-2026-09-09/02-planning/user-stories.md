---
title: "Especificação Detalhada de User Stories"
domain: "planning"
status: "accepted"
owner: "Fellipe Raszejas / Luciano Jr"
last_updated: "2026-08-27"
---

# 📝 Especificação Detalhada de User Stories

User Stories detalhadas do Core MVP contendo descrição, critérios de aceite em sintaxe BDD/Gherkin, estimativas e riscos.

---

## US01 — Autenticação Centralizada e Emissão de Tokens (IAM)
* **Como** usuário cadastrado (Aluno, Docente, Coordenador, Admin, CPA),
* **Quero** autenticar com minhas credenciais institucionais em uma interface única de login,
* **Para** obter acesso seguro e unificado aos módulos autorizados da plataforma.

### Critérios de Aceite (Gherkin):
```gherkin
Cenário: Autenticação bem-sucedida
  Dado que o usuário possui conta ativa com e-mail "aluno@universidade.edu.br" e senha válida
  Quando envia a requisição POST para "/api/v1/auth/login" com as credenciais corretas
  Então a resposta deve retornar HTTP 200
  E o corpo da resposta deve conter um "accessToken" (JWT RS256, expiração de 15 minutos)
  E um cookie "refreshToken" seguro (HttpOnly, Secure, SameSite=Strict, expiração de 7 dias)
  E um evento de auditoria "AUTH_SUCCESS" deve ser registrado no banco.

Cenário: Tentativa com credenciais inválidas
  Dado que o usuário informa uma senha incorreta
  Quando envia a requisição POST para "/api/v1/auth/login"
  Então a resposta deve retornar HTTP 401 Unauthorized
  E a mensagem de erro deve ser genérica: "Credenciais inválidas"
  E após 5 tentativas consecutivas falhas, o IP/usuário deve sofrer rate-limiting de 15 minutos.
```
* **Metadados:** Prioridade: **P0** | Estimativa: **5 SP** | Squad: **Squad Core** | Sprint: **Sprint 1**
* **Dependências:** Tabela `auth.users` e par de chaves RSA provisionado no AWS Secrets Manager.
* **Riscos:** Vazamento de tokens por falha de configuração de CORS ou cookies. *Mitigado por flags HttpOnly, Secure e CSP rigorosa.*

---

## US05 — Cadastro de Propostas de PI e Formação de Equipes
* **Como** Aluno regularmente matriculado,
* **Quero** cadastrar o título, descrição e tema da proposta de Projeto Integrador e convidar outros discentes para o grupo,
* **Para** formalizar a composição da equipe perante a coordenação e orientadores.

### Critérios de Aceite (Gherkin):
```gherkin
Cenário: Cadastro de proposta com sucesso
  Dado que o aluno líder está autenticado com papel "STUDENT"
  Quando preenche o formulário com título "Sistema IoT", descrição e semestre "2026.2"
  Então o projeto é salvo com status "PROPOSED" no schema `academic_pi`
  E o aluno criador é vinculado automaticamente como líder da equipe.

Cenário: Convidar integrante para o grupo
  Dado que o líder envia o e-mail institucional de outro aluno válido
  Quando o sistema valida que o aluno convidado não possui outro PI ativo no mesmo semestre
  Então grava o vínculo em `academic_pi.project_members`
  E envia notificação de confirmação ao aluno convidado.
```
* **Metadados:** Prioridade: **P0** | Estimativa: **5 SP** | Squad: **Squad Acadêmico** | Sprint: **Sprint 1**
* **Dependências:** US01 (Auth).

---

## US07 — Lançamento de Notas de Projetos Integradores por Rubricas
* **Como** Docente Avaliador membro da banca examinadora de um Projeto Integrador,
* **Quero** preencher as notas individuais em cada critério avaliativo (rubrica) e emitir parecer,
* **Para** que a média ponderada final do grupo e as atas de avaliação sejam consolidadas automaticamente.

### Critérios de Aceite (Gherkin):
```gherkin
Cenário: Lançamento de notas por avaliador autorizado
  Dado que o docente está autenticado e alocado formalmente na banca do projeto "PI-2026-G04"
  E o período de avaliação da banca encontra-se no status "EM_AVALIACAO"
  Quando o docente envia a pontuação de 0 a 10 para os critérios [Domínio Técnico, Apresentação, Artefato]
  Então a API deve validar os limites de nota
  E salvar a avaliação individual no schema `academic_pi`
  E recalcular a média consolidada do projeto se todos os avaliadores tiverem submetido.

Cenário: Tentativa de avaliação por docente não pertencente à banca
  Dado que um docente autenticado tenta submeter notas para o projeto "PI-2026-G04" sem estar alocado
  Quando envia a requisição POST para "/api/v1/academic/evaluations"
  Então a API deve retornar HTTP 403 Forbidden com código de erro "ACCESS_DENIED_NOT_IN_BOARD".
```
* **Metadados:** Prioridade: **P0** | Estimativa: **8 SP** | Squad: **Squad Acadêmico** | Sprint: **Sprint 3**
* **Dependências:** US01 (Auth), US06 (Bancas cadastradas).
* **Riscos:** Condição de corrida no cálculo da média final. *Mitigado por transação ACID isolada no PostgreSQL com `SELECT FOR UPDATE`.*

---

## US10 — Submissão e Validação de Atividades de Extensão
* **Como** Aluno vinculado a um projeto de extensão aprovado,
* **Quero** registrar o relatório de execução com comprovação de carga horária e evidências,
* **Para** que o docente orientador valide e credite as horas curriculares no meu histórico.

### Critérios de Aceite (Gherkin):
```gherkin
Cenário: Submissão de atividade com sucesso
  Dado que o aluno está regularmente matriculado e inscrito no projeto de extensão "EXT-2026-01"
  Quando o aluno faz upload do relatório comprobatório (PDF máx. 10MB) e informa "20 horas"
  Então o arquivo deve ser armazenado no S3 privado sob caminho assinado
  E o status da atividade deve mudar para "AGUARDANDO_VALIDACAO"
  E o orientador do projeto deve ser notificado.

Cenário: Validação e cômputo de horas pelo orientador
  Dado que o orientador acessa a fila de validações pendentes
  Quando clica em "Aprovar Atividade" confirmando 20 horas
  Então o status muda para "DEFERIDO"
  E o saldo de horas de extensão do aluno é incrementado atomicamente no banco.
```
* **Metadados:** Prioridade: **P0** | Estimativa: **8 SP** | Squad: **Squad Extensão & Portal** | Sprint: **Sprint 2**
* **Dependências:** US01 (Auth), US09 (Editais ativos), Bucket S3 configurado.

---

## US11 — Emissão e Validação Pública de Certificados de Extensão
* **Como** Aluno que integralizou a carga horária mínima exigida em uma ação extensionista,
* **Quero** emitir o certificado digital oficial em formato PDF com chave de autenticidade,
* **Para** comprovar a realização das horas de extensão perante a coordenação ou órgãos externos.

### Critérios de Aceite (Gherkin):
```gherkin
Cenário: Emissão de certificado com validação criptográfica
  Dado que o aluno cumpriu 100% das horas aprovadas em um projeto de extensão concluído
  Quando o aluno clica em "Emitir Certificado"
  Então o backend deve gerar o PDF contendo: Nome do Aluno, CPF mascarado, Título do Projeto, Carga Horária, Data de Conclusão e Hash SHA-256
  E registrar o hash e a URL do certificado na tabela `extension.certificates`.

Cenário: Validação pública do certificado
  Dado que qualquer pessoa acessa o endpoint público "/portal/validar-certificado"
  Quando informa o código hash do certificado ou escaneia o QR Code impresso no documento
  Então o sistema deve exibir os dados oficiais do certificado e status "AUTÊNTICO E VÁLIDO".
```
* **Metadados:** Prioridade: **P0** | Estimativa: **5 SP** | Squad: **Squad Extensão & Portal** | Sprint: **Sprint 3**
* **Dependências:** US10 (Horas validadas), Serviço de geração de PDFs no backend.

---

## 2. Documentos Relacionados
* [Backlog Geral](backlog.md)
* [Definition of Ready](../09-governance/definition-of-ready.md)
* [Definition of Done](../09-governance/definition-of-done.md)
