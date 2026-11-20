# T23 — Configurar SAST, SCA, secrets, container e IaC scans

**Fase:** F6  | **Referências:** QA-005, QA-006, QA-025, INF-003

## Objetivo

Detectar e bloquear vulnerabilidades críticas em PR e release.

## Implementação

- Adicionar ferramentas
- criar baseline explícita
- bloquear High/Critical
- registrar exceção com owner/prazo/expiração.

## Dependências

T04, T05 e T27.

## Testes e validações

- Testar segredo sintético, dependência vulnerável, imagem vulnerável, Terraform inseguro e publicação de relatório.

## Agentes necessários

Executor: .agents/infrastructure-agent.md. Revisor: .agents/quality-security-agent.md. Aceite: .agents/governance-agent.md.

## Métrica e evidência de aceite

Zero High/Critical sem correção ou aceite formal.

## Critério de Done

Scans executam em PR e nenhum finding é ignorado sem registro.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
