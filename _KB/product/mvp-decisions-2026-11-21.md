---
title: "Decisões de fechamento do MVP — identidade, permissões e conteúdo"
status: "Approved"
owner: "Product Governance / Product Owner"
date: "2026-11-21"
---

# Decisões de fechamento do MVP

Este documento transforma os pontos abertos identificados na revisão do MVP em decisões operacionais. Foi aprovado pelo PO em 2026-11-21 e passa a orientar a implementação, os contratos e os testes do MVP.

## 1. Identidade e importação CSV

- O **CPF é o identificador oficial de login** e deve ser normalizado para 11 dígitos antes de qualquer consulta.
- O endpoint aceita `identifier` como campo canônico. Durante a transição dos fixtures existentes, aceita também `email` como alias técnico; a interface não oferece e-mail como caminho principal.
- O CPF deve passar validação estrutural e de dígitos verificadores. CPF inválido, desconhecido ou inativo recebe a mesma resposta genérica de credencial inválida.
- O CSV de provisionamento usa UTF-8, separador `;` e cabeçalho obrigatório: `cpf;full_name;email;role;course_code;class_code`.
- `cpf`, `full_name` e `role` são obrigatórios; `email`, `course_code` e `class_code` são opcionais conforme o papel.
- A importação é **pré-validada e transacional**: se houver erro, nenhuma linha é persistida. O resultado retorna linha, campo, código e mensagem de correção, sem exibir senha ou token.
- CPF duplicado dentro do arquivo ou já existente é erro. Reimportação não altera usuário existente no MVP.
- A conta criada sem senha fica `pending`; o primeiro acesso define a senha. Usuário inativo não autentica.
- Reset por coordenação/docente define senha temporária e marca `must_change_password`; sessões ativas são revogadas. O usuário deve trocar a senha antes de acessar funcionalidades.
- A política mínima de senha é 8 caracteres, com pelo menos uma letra e um número. Não há recuperação por e-mail como dependência do MVP.

## 2. Papéis e escopos

- Uma pessoa possui um cadastro por CPF e pode acumular os papéis `ALUNO`, `DOCENTE`, `COORDENADOR` e `ADMIN`.
- O servidor é a autoridade final; o menu do frontend é apenas uma representação da autorização.
- `ALUNO`: próprios pedidos, inscrições, atividades, entregáveis, horas, avaliações e certificados.
- `DOCENTE`: projetos em que é responsável, solicitações desses projetos, atividades desses projetos e avaliações atribuídas; pode adicionar avaliação de Extensão conforme vínculo.
- `COORDENADOR`: cadastros institucionais, períodos, editais, atribuição de responsáveis/avaliadores, revisão de publicação e operações administrativas explicitamente previstas.
- `ADMIN`: saúde técnica, configurações e gestão de acesso autorizada; não recebe permissão acadêmica automaticamente.
- `CPA` não é um papel operacional do MVP atual. A futura CPA/Ouvidoria terá uma decisão própria de papéis e confidencialidade.
- Qualquer ação sem regra explícita permanece negada por padrão.

## 3. Notas e avaliações

- A escala do MVP é de **0,00 a 10,00**.
- Pesos devem ser positivos e somar **100,00%**; uma rubrica incompleta não pode ser finalizada.
- O resultado é calculado com precisão decimal, arredondado para duas casas pelo método half-up.
- Avaliação ausente não compõe a média até ser lançada; a finalização exige que todas as avaliações obrigatórias estejam presentes.
- Estados: `DRAFT`, `IN_PROGRESS`, `FINALIZED`, `REOPENED` e `CORRECTED`.
- Somente o docente responsável finaliza, reabre ou corrige a avaliação do PI. Correção substitui o valor atual e não cria histórico de negócio.
- Avaliação individual docente é visível ao aluno avaliado e aos papéis autorizados do projeto; nota agregada do projeto pode ser pública.
- Alunos avaliadores só consultam a ficha atribuída e não veem a identidade ou nota de outros avaliadores, salvo decisão posterior do PO.

## 4. Certificados

- A coordenação emite o certificado após o aluno cumprir os critérios acadêmicos aprovados: participação ativa encerrada, horas exigidas aprovadas e avaliação final quando aplicável.
- O PDF contém: instituição, aluno, CPF mascarado, atividade/projeto, período, carga horária, data de emissão, identificador público, QR Code e hash SHA-256 do payload canônico.
- O payload canônico é serializado em JSON ordenado e armazenado junto ao certificado; a validação recalcula o hash do payload e compara com o hash persistido.
- O certificado pode estar `ACTIVE` ou `REVOKED`. Revogação exige motivo; reemissão gera novo identificador e invalida o anterior quando substituir o mesmo evento.
- A consulta pública informa apenas validade, dados institucionais, projeto/atividade e período necessários à conferência. CPF completo e dados internos nunca são públicos.
- O PDF e o payload devem ser mantidos no storage institucional com backup conforme a política operacional; restore deve comprovar a validação.

## 5. Arquivos e imagens

- Entregáveis do MVP aceitam PDF, DOCX, PNG e JPEG até 20 MiB por arquivo.
- O servidor valida extensão, MIME declarado, assinatura do arquivo e tamanho; arquivo inválido é rejeitado antes do storage.
- Arquivo fica privado por padrão. Download exige vínculo com o projeto ou permissão administrativa autorizada.
- O aluno pode substituir o arquivo até o início da avaliação; a substituição atualiza o objeto vigente sem histórico de negócio.
- Fotos só são públicas quando o docente responsável marca autorização de publicação. Sem autorização, a foto permanece privada ou é rejeitada do catálogo.
- Imagens de menores ou terceiros exigem confirmação de autorização pelo responsável antes da publicação.
- Retirada de publicação remove o item da API pública imediatamente e deve expurgar CDN/cache em até 15 minutos.
- O MVP não promete backup de arquivos se a política de infraestrutura não o suportar; antes do go-live, a retenção e o restore devem ser aprovados pelo owner operacional.

## 6. Impactos e catálogo público

- Impacto publicado exige: resumo, público beneficiado, período, território, resultado observado, evidência textual e responsável pela aprovação.
- Indicadores mínimos: `beneficiarios_atendidos` (inteiro não negativo), `horas_atividade` (decimal positivo), `parceiros_envolvidos` (inteiro não negativo) e `ods_codes`.
- Os dados são declarados pelo responsável do projeto e aprovados pela coordenação; a plataforma não inventa estimativas nem calcula impacto por IA no MVP.
- O catálogo público expõe somente título, resumo, classificação, curso, semestre, ODS, responsáveis autorizados, impacto aprovado e nota agregada quando publicada.
- Não expõe CPF, e-mail, horas individuais, notas individuais, solicitações, justificativas, arquivos internos ou dados identificáveis de beneficiários.
- Relatos e imagens com pessoas exigem autorização; dados de beneficiários devem ser agregados ou anonimizados.
- Correção substitui o conteúdo vigente após nova aprovação. Retirada deixa o conteúdo indisponível na API em até 1 minuto e no CDN em até 15 minutos.

## 7. Critério de aprovação

O PO deve revisar esta proposta e aprovar ou alterar cada seção. Depois da aprovação:

1. atualizar as SPECs relacionadas;
2. atualizar OpenAPI, migrations/contratos e telas;
3. adicionar testes de regra e de experiência;
4. anexar evidência ao plano MVP/V1;
5. remover o status `Draft` apenas das SPECs efetivamente cobertas.

## Rastreabilidade

- [Regras oficiais](./official-validation-decisions.md)
- [Revisão de produto e plano](../../docs/product-review/2026-11-21-mvp-futuro-experiencias-e-plano.md)
- [SPEC AUTH-001](../specs/SPEC-AUTH-001-login.md)
- [SPEC AUTH-003](../specs/SPEC-AUTH-003-rbac.md)
- [SPEC PI-003](../specs/SPEC-PI-003-grades.md)
- [SPEC EXT-003](../specs/SPEC-EXT-003-certificates.md)
- [SPEC PORTAL-001](../specs/SPEC-PORTAL-001-catalog.md)
- [SPEC PORTAL-002](../specs/SPEC-PORTAL-002-impact.md)
