# Backlog — Cloud & DevOps

| ID | P/S | SP | Responsável | Revisor | Entrega / aceite | Dep. |
| --- | --- | ---: | --- | --- | --- | --- |
| INF-001 | P0/S0 | 5 | Felipe Marques | José Eduardo de Oliveira Junior | Terraform remoto tem lock, criptografia e acesso mínimo | ADR-011 |
| INF-002 | P0/S0 | 8 | José Eduardo | Felipe Marques | VPC/subnets/routes/SG passam validate e scan | INF-001 |
| INF-003 | P0/S0 | 8 | Felipe Nunes Ramalho | José Eduardo | Workflows reutilizáveis executam gates em PR | PG-014 |
| INF-004 | P0/S0 | 5 | Nicolle Carolina da Rocha | José Eduardo | OIDC assume roles sem access key persistente | INF-001 |
| INF-005 | P0/S0 | 8 | Ryan Amorim Carvalho | Felipe Marques | PostgreSQL 16 isolado, cifrado e não público | INF-002 |
| INF-006 | P0/S0 | 5 | Guilherme Bueno Caetano | José Eduardo | ECR aplica scan, lifecycle e tag imutável | INF-004 |
| INF-007 | P0/S0 | 8 | Felipe Nunes | José Eduardo | Runtime backend tem healthcheck, logs e rollback | INF-002, INF-006 |
| INF-008 | P0/S0 | 5 | Nicolle Carolina | Gustavo | Secrets Manager usado sem vazamento em logs/outputs | INF-004 |
| INF-009 | P0/S1 | 8 | Ryan Amorim | Felipe Marques | Validação efêmera no CI publica artefato imutável | INF-005–008 |
| INF-010 | P0/S1 | 5 | Guilherme Bueno | José Eduardo | S3 bloqueia público, cifra e aplica lifecycle | INF-002, INF-004 |
| INF-011 | P0/S2 | 8 | José Eduardo | Felipe Marques | Runtime Next.js SSR/CDN passa smoke de SSR/cache | FE-001 |
| INF-012 | P1/S3 | 8 | Felipe Nunes | José Eduardo | Logs/métricas/traces correlacionam request | INF-009, INF-011 |
| INF-013 | P1/S3 | 5 | Nicolle Carolina | Felipe Marques | Alarmes de p95, erro, disponibilidade e banco notificam | INF-012 |
| INF-014 | P1/S0 | 3 | Ryan Amorim | Felipe Marques | Budget USD 120 e alertas 50/80/100% testados | INF-004 |
| INF-015 | P0/S3 | 5 | Guilherme Bueno | José Eduardo | Backup diário/14 dias e retenções aplicados | INF-005 |
| INF-016 | P0/S5 | 8 | Felipe Marques | Isabelly | Restore em instância temporária registra tempo e integridade | INF-015 |
| INF-017 | P0/S5 | 8 | José Eduardo | Felipe Marques | Autoscaling/pool ajustados com evidência k6 | QA-024 |
| INF-018 | P0/S5 | 5 | Felipe Nunes | José Eduardo | Rollback ensaiado recupera versão anterior | INF-009 |
| INF-019 | P0/S6 | 8 | Felipe Marques | Fellipe e Gabriel Ribeiro | Produção só após go/no-go e aprovação registrada | PG-018, QA-028 |
| INF-020 | P0/S6 | 5 | Nicolle Carolina | José Eduardo | Smoke pós-deploy e decisão de rollback registrados | INF-019 |
| INF-021 | P1/S6 | 5 | Guilherme Bueno | Felipe Marques | Runbooks de deploy, rollback e incidente testados | INF-018–020 |
