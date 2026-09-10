---
id: POL-GOV-004
status: Approved
owner: Product Governance
approved_at: 2026-09-10
---

# Workflow de mudança normativa

1. Abrir Issue com motivação, artefatos afetados e impacto.
2. Criar branch e PR; nunca editar `main` diretamente.
3. Validar front matter, IDs, links, contratos e rastreabilidade.
4. Obter aprovação conforme o nível de governança.
5. Fazer squash merge e gerar changelog.
6. Publicar tag `governance-vMAJOR.MINOR.PATCH` apontando para SHA imutável.
7. Atualizar `.governance-baseline` dos consumidores por PR.

Sem evidência verificável, um conteúdo novo permanece `Draft` ou `Review`.
