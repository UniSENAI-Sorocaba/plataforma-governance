# Backlog — Qualidade, Testes & Segurança

| ID | P/S | SP | Responsável | Revisor | Entrega / aceite | Dep. |
| --- | --- | ---: | --- | --- | --- | --- |
| QA-001 | P0/S0 | 5 | Gabriel Ribeiro de Camargo Miranda | Gustavo Henrique Gouveia Gomes | Estratégia e matriz AC→evidência aprovadas | PG-006–012 |
| QA-002 | P0/S0 | 5 | Gustavo Henrique | Gabriel Ribeiro | Threat model lista ativos, fronteiras, ameaças e controles | ADR-006–011 |
| QA-003 | P0/S0 | 5 | Ahslam Mendes | Gabriel Ribeiro | Spec-compliance produz PASS/WARN/FAIL e bloqueia FAIL | PG-004 |
| QA-004 | P0/S0 | 5 | Bianca Cirilo | Gabriel Ribeiro | Templates de caso/evidência/defeito são utilizáveis | QA-001 |
| QA-005 | P0/S0 | 8 | Guilherme Aparecido de Arruda Garcia | Gustavo | CodeQL, SCA e dependency review rodam em PR teste | INF-003 |
| QA-006 | P0/S0 | 5 | Gabriel Camargo Gonçalves Silva | Gustavo | Push protection detecta segredo sintético | PG-014 |
| QA-007 | P0/S0 | 5 | Vitor Fazano | Gabriel Ribeiro | Gates/cobertura bloqueiam PR abaixo do limite | INF-003 |
| QA-008 | P0/S1 | 8 | Ahslam Mendes | Gustavo | API tests cobrem login, refresh, logout e reuse | BE-004–006 |
| QA-009 | P0/S1 | 5 | Bianca Cirilo | Gabriel Ribeiro | RBAC cobre allow/deny por perfil e rota | BE-010 |
| QA-010 | P0/S1 | 8 | Guilherme Aparecido | Gabriel Ribeiro | Contract test detecta breaking change OpenAPI | BE-003 |
| QA-011 | P0/S1 | 5 | Gabriel Camargo | Gabriel Ribeiro | Propostas/convites cobrem transições e concorrência | BE-007–008 |
| QA-012 | P0/S1 | 5 | Vitor Fazano | Gabriel Ribeiro | Editais/inscrições cobrem janela e duplicidade | BE-009 |
| QA-013 | P0/S2 | 8 | Ahslam Mendes | Gabriel Ribeiro | Bancas detectam conflito e avaliador inválido | BE-011 |
| QA-014 | P0/S2 | 8 | Bianca Cirilo | Gustavo | Upload testa tipo, tamanho, expiração e autorização | BE-012–013 |
| QA-015 | P0/S2 | 8 | Guilherme Aparecido | Gabriel Ribeiro | Horas cobrem decisão, total e auditoria | BE-014 |
| QA-016 | P0/S3 | 8 | Gabriel Camargo | Gabriel Ribeiro | Notas testam precisão, permissão e limites | BE-015 |
| QA-017 | P0/S3 | 5 | Vitor Fazano | Gustavo | Certificado testa hash, QR, adulteração e revogação | BE-017 |
| QA-018 | P0/S3 | 5 | Bianca Cirilo | Gabriel Ribeiro | Catálogo testa filtros, paginação, privacidade e vazio | BE-018 |
| QA-019 | P0/S4 | 13 | Ahslam Mendes | Gabriel Ribeiro | Playwright cobre jornadas P0 no staging | FE-004–016 |
| QA-020 | P0/S4 | 5 | Bianca Cirilo | Paola | WCAG cobre teclado, foco, nomes, contraste e leitor | FE-017 |
| QA-021 | P1/S4 | 5 | Guilherme Aparecido | Paola | Web Vitals medidos e dentro das metas | FE-019 |
| QA-022 | P0/S4 | 5 | Gabriel Camargo | Gustavo | Privacidade, auditoria e retenção têm evidência | DB-007, INF-012 |
| QA-023 | P0/S5 | 8 | Vitor Fazano | Gabriel Ribeiro | Regressão gera relatório e Issues por falha | QA-019–022 |
| QA-024 | P0/S5 | 8 | Guilherme Aparecido | José Eduardo | k6 valida 200 RPS e p95 <=500 ms | MVP integrado |
| QA-025 | P0/S5 | 8 | Gustavo Henrique | Gabriel Ribeiro | SAST/SCA/container/IaC sem High/Critical pendente | builds |
| QA-026 | P0/S5 | 8 | Gustavo Henrique | Gabriel Ribeiro | ZAP staging sem High/Critical pendente | INF-009 |
| QA-027 | P0/S5 | 5 | Gabriel Ribeiro | Luciano | Relatório consolida FAIL/WARN, owner, prazo e risco | QA-023–026 |
| QA-028 | P0/S6 | 8 | Gabriel Ribeiro | Fellipe | Regressão/smoke e parecer go/no-go têm evidências | correções |
| QA-029 | P0/S6 | 5 | Ahslam e Vitor | Gabriel Ribeiro | Smoke em produção valida jornadas e gatilho de rollback | INF-019 |
| QA-030 | P1/S6 | 3 | Bianca e Gabriel Camargo | Gabriel Ribeiro | Pacote final é íntegro, navegável e retido | QA-028–029 |
