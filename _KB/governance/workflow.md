---
id: POL-GOV-004
status: Approved
owner: Product Governance
approved_at: 2026-09-10
---

# Workflow de mudança normativa

1. Abrir Issue com motivação, artefatos afetados e impacto.
2. Criar branch e abrir o PR com `develop` como branch de destino; nunca editar `develop` ou `main` diretamente.
3. Validar front matter, IDs, links, contratos e rastreabilidade.
4. Obter aprovação conforme o nível de governança.
5. Fazer squash merge em `develop` e gerar changelog.
6. Promover `develop` para `main` por PR aprovado após a validação dos gates.
7. Publicar tag `governance-vMAJOR.MINOR.PATCH` apontando para SHA imutável.
8. Atualizar `.governance-baseline` dos consumidores por PR.

Sem evidência verificável, um conteúdo novo permanece `Draft` ou `Review`.
