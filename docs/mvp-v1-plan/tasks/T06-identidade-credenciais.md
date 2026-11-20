# T06 — Implementar identidade, vínculo institucional e credenciais

**Fase:** F2  | **Referências:** DB-004, BE-004, BE-005

## Objetivo

Persistir usuários e credenciais com segurança e vínculo institucional único.

## Implementação

- Criar usuário, vínculo e credencial
- aplicar unicidade
- usar Argon2id documentado
- separar identificação de autenticação
- nunca persistir senha em claro.

## Dependências

T03 e T05.

## Testes e validações

- Testar criação, lookup, senha correta/incorreta, duplicidade, hash diferente para mesma senha e inspeção de logs/configuração.

## Agentes necessários

Executor: .agents/database-agent.md + .agents/backend-agent.md. Revisor: .agents/architecture-agent.md. Validação: .agents/quality-security-agent.md. Aceite: PO.

## Métrica e evidência de aceite

100% das credenciais são Argon2id; zero segredo em logs.

## Critério de Done

Identidade funciona contra banco de teste e regras de segurança passam.

- código integrado na branch de integração;
- testes e validações executados;
- PR, commit e evidências vinculados à Issue;
- risco residual atualizado;
- revisão registrada pelo agente responsável.
