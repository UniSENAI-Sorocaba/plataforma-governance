# 03 — Projetos, Extensão, Avaliação e Certificação

## Objetivo

Entregar o núcleo de valor acadêmico em fatias verticais, mantendo banco, API, interface, regras de autorização e testes alinhados.

## Subfase A — Propostas e equipes

### Etapa A1 — Schema e integridade

**Itens:** `DB-008`, `DB-012`.  
**Aceite:** projeto, proposta, responsável, período/semestre, solicitação de participação, inscrição e participante possuem FK, unicidade, status e índices conforme o contrato aprovado; estados inválidos são rejeitados no banco ou domínio; transições proibidas têm teste. Não existe entidade de convite individual.

### Etapa A2 — Proposta em rascunho e publicação

**Itens:** `BE-007`, `FE-006`.  
**Aceite:** docente autorizado salva rascunho ou escolhe publicação no cadastro; campos obrigatórios aprovados são validados no ponto contratado; não existe estado `SUBMITTED` sem decisão de produto; proposta publicada não pode ser editada fora dos campos e permissões aprovados; API e frontend exibem feedback determinístico.

### Etapa A3 — Solicitações e equipe

**Itens:** `BE-008`, `FE-007`, `FE-009`, `QA-011`.  
**Aceite:** aluno elegível solicita participação durante período vigente; docente responsável aprova ou nega; retirada, reenvio e remoção seguem os estados formais; aluno inelegível, docente fora do escopo e projeto diferente são rejeitados; duplicidade e corrida concorrente retornam `409 Conflict` sem alteração parcial; limite de PI/Extensão é aplicado transacionalmente; remoção exige justificativa. Não há convite, aceite ou recusa de convite.

## Subfase B — Entregáveis e extensão

### Etapa B1 — Upload seguro

**Itens:** `BE-012`, `BE-013`, `DB-011`, `FE-011`, `QA-014`.  
**Aceite:** tipo e tamanho inválidos falham; URL é curta e temporária; hash, owner e lifecycle são persistidos; download não autorizado falha; cancelamento e progresso são visíveis no frontend.

### Etapa B2 — Atividades e horas

**Itens:** `BE-014`, `DB-013`, `FE-012`, `QA-015`.  
**Aceite:** aluno envia atividade; docente responsável aprova ou rejeita com motivo; total aprovado é calculado sem duplicidade; logs técnicos não expõem segredos; não há auditoria de negócio nem histórico de valores anteriores de horas.

### Etapa B3 — Editais e inscrições

**Itens:** `BE-009`, `DB-012`, `FE-008`, `QA-012`.  
**Aceite:** inscrição fora da janela é rejeitada; duplicidade é impedida; elegibilidade é validada; frontend apresenta janela, status e resultado da inscrição.

## Subfase C — Avaliação e notas

### Etapa C1 — Avaliações e avaliadores

**Itens:** `BE-011`, `DB-009`, `FE-010`, `QA-013`.  
**Aceite:** vínculo e autorização de avaliador inválidos são rejeitados; atribuição de avaliadores e datas segue o contrato aprovado; não há entidade de banca, agenda, sala ou link; ausência, prazos e regras adicionais ficam bloqueados até decisão de produto.

### Etapa C2 — Rubricas e cálculo

**Itens:** `BE-015`, `DB-010`, `FE-013`, `QA-016`.  
**Aceite:** rubrica possui versão e pesos válidos; cálculo é determinístico; precisão e arredondamento estão documentados; permissões e limites são testados; resultado pode ser reproduzido a partir dos dados auditados.

## Subfase D — Certificação

### Etapa D1 — Emissão

**Itens:** `BE-017`, `FE-014`, `QA-017`.  
**Aceite:** somente papel autorizado emite; certificado contém identificador, titular, carga horária, hash e QR; emissão duplicada segue regra explícita; PDF/representação visual é baixável.

### Etapa D2 — Validação e revogação

**Aceite:** URL pública valida certificado legítimo; hash alterado falha; certificado revogado é identificado; endpoint público não revela dados além do necessário; logs não expõem documento sensível.

## Gate funcional da fase

Um cenário de teste deve executar, em ordem:

1. autenticar aluno e docente;
2. criar proposta;
3. solicitar participação como aluno e aprovar como docente;
4. submeter entregável;
5. registrar e aprovar horas;
6. avaliar por rubrica;
7. consolidar nota;
8. emitir certificado;
9. validar certificado sem login.

O gate passa somente com 100% das etapas contratadas, sem acesso manual ao banco e com evidência de request/response e tela. A evidência não deve exigir auditoria de negócio; deve demonstrar logs técnicos sanitizados quando necessário.
