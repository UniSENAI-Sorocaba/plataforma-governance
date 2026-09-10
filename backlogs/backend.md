# Backlog — Backend

| ID | P/S | SP | Responsável | Revisor | Entrega / aceite | Dep. |
| --- | --- | ---: | --- | --- | --- | --- |
| BE-001 | P0/S0 | 5 | Victor Hugo Geroto Toledo | João Victor de Souza Santos | Spring Boot 3/Java 21 compila, healthcheck responde e módulos estão documentados | ADR-007 |
| BE-002 | P0/S0 | 5 | João Victor | Victor | Padrão modular, erros, logs e observabilidade base validados | BE-001 |
| BE-003 | P0/S0 | 5 | Pedro Henrique Dias | João | OpenAPI 3.1 valida no CI e gera mock consumível | ADR-009 |
| BE-004 | P0/S1 | 8 | João Victor | Victor | Login institucional emite JWT RS256 e rejeita credencial inválida | DB-004, INF-008 |
| BE-005 | P0/S1 | 5 | Ana Paula Maximo | João | Argon2id configurado; senha/token não aparecem em log | BE-004 |
| BE-006 | P0/S1 | 8 | Carlos Eduardo Pereira | João | Refresh rotativo/logout revogam sessão e detectam reuse | DB-005 |
| BE-007 | P0/S1 | 8 | Johann Arruda Andrade | Victor | CRUD de propostas valida papéis, campos e transições | DB-008 |
| BE-008 | P0/S1 | 5 | Lucas Miguel Leite | Johann | Convites aceitam/recusam sem duplicidade | BE-007 |
| BE-009 | P0/S1 | 8 | Marco Antônio da Costa Silva | João | Editais/inscrições respeitam janela e elegibilidade | DB-012 |
| BE-010 | P0/S2 | 8 | Pedro Henrique | João | RBAC server-side cobre todos os endpoints protegidos | BE-004, DB-006 |
| BE-011 | P0/S2 | 8 | Julio Cesar Boteccio | Victor | Bancas impedem conflito de horário e vínculo inválido | DB-009 |
| BE-012 | P0/S2 | 5 | Ana Paula | João | URL S3 é curta, restrita e valida tipo/tamanho | INF-010 |
| BE-013 | P0/S2 | 8 | Carlos Eduardo | Victor | Entregáveis guardam hash/metadados e respeitam autorização | BE-012, DB-011 |
| BE-014 | P0/S2 | 8 | Johann Arruda | Victor | Horas suportam submissão, decisão, motivo e total | DB-013 |
| BE-015 | P0/S3 | 13 | João Victor | Victor e Isabelly | Rubricas/notas calculam resultado determinístico e auditável | BE-011, DB-010 |
| BE-016 | P1/S3 | 5 | Lucas Miguel | João | Auditoria registra ator, ação, alvo, instante e correlação | DB-007 |
| BE-017 | P0/S3 | 8 | Marco Antônio | Victor | Certificado possui hash/QR verificável e emissão autorizada | BE-014 |
| BE-018 | P0/S3 | 8 | Julio Cesar | João | Catálogo pagina/filtra sem expor dados privados | DB-014 |
| BE-019 | P1/S4 | 5 | Pedro Henrique | Victor | API de impacto publica apenas conteúdo aprovado | DB-015 |
| BE-020 | P0/S1–4 | 5 | Ana Paula | João | CI comprova cobertura 80/70 e crítica 90/80 | todos BE |
| BE-021 | P0/S5 | 8 | Victor | Gustavo | Findings são corrigidos ou têm risco formalmente aceito | QA-024–027 |
| BE-022 | P1/S6 | 3 | Carlos Eduardo | Victor | Runbook API e troubleshooting revisados | BE-021 |
| BE-023 | P2/Future | 13 | Johann Arruda | Victor | Spike patrimônio produz contrato Draft e riscos | PG-019 |
| BE-024 | P3/Future | 13 | Lucas Miguel | João | Spike carreira/IC define fronteiras e estimativa | PG-019 |
| BE-025 | P2/Future | 13 | Marco Antônio | Gustavo | Spike CPA/ouvidoria preserva anonimato | PG-019 |
