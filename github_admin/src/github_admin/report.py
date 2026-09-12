from __future__ import annotations

import json
from typing import Any


def _cell(value: Any) -> str:
    if isinstance(value, bool):
        text = "sim" if value else "não"
    elif value is None:
        text = "—"
    elif isinstance(value, (dict, list)):
        text = json.dumps(value, ensure_ascii=False, sort_keys=True)
    else:
        text = str(value)
    return text.replace("|", "\\|").replace("\n", " ")


def audit_markdown(audit: dict[str, Any]) -> str:
    organization = audit.get("organization", {})
    lines = [
        "# Relatório de auditoria do GitHub",
        "",
        "## Organização",
        "",
        "| Campo | Valor |",
        "|---|---|",
        f"| Login | {_cell(organization.get('login'))} |",
        f"| Plano | {_cell(organization.get('plan'))} |",
        f"| Exigência de 2FA | {_cell(organization.get('two_factor_requirement_enabled'))} |",
    ]
    for title, key in (("Repositórios", "repositories"), ("Times", "teams"), ("Projetos", "projects")):
        values = audit.get(key, [])
        lines.extend(["", f"## {title} ({len(values)})", ""])
        lines.extend([f"- `{_cell(value)}`" for value in values] or ["Nenhum encontrado."])

    lines.extend(["", "## Detalhes dos repositórios", ""])
    for name, detail in sorted(audit.get("details", {}).items()):
        lines.extend([
            f"### `{_cell(name)}`",
            "",
            "| Campo | Valor |",
            "|---|---|",
            f"| Visibilidade | {_cell(detail.get('visibility'))} |",
            f"| Branch padrão | {_cell(detail.get('default_branch'))} |",
            f"| Tamanho informado pela API (KB) | {_cell(detail.get('size_kb'))} |",
            f"| Arquivado | {_cell(detail.get('archived'))} |",
            f"| Issues abertas | {_cell(detail.get('open_issues', 0))} |",
            f"| Rulesets | {_cell(detail.get('rulesets', []))} |",
            f"| Environments | {_cell(detail.get('environments', []))} |",
            f"| Labels | {_cell(detail.get('labels', []))} |",
            "",
        ])
    if not audit.get("details"):
        lines.append("Nenhum repositório configurado foi encontrado.")
    return "\n".join(lines).rstrip() + "\n"


def plan_markdown(changes: list[dict[str, Any]], context: dict[str, Any] | None = None) -> str:
    context = context or {}
    lines = [
        "# Plano de alterações do GitHub",
        "",
        f"Total de alterações propostas: **{len(changes)}**.",
        "",
    ]
    migration = context.get("migration", {})
    deferred = context.get("deferred_until_github_team", {})
    if migration or deferred:
        lines.extend(["## Fora do escopo imediato", ""])
        legacy = migration.get("legacy_repositories", [])
        if legacy:
            lines.append("- Os repositórios legados não serão alterados ou excluídos: " + ", ".join(f"`{_cell(name)}`" for name in legacy) + ".")
            lines.append("- A exclusão dos legados será manual e somente após a validação dos novos repositórios.")
        deleted = migration.get("deleted_repositories", [])
        if deleted:
            lines.append("- Migração concluída: os repositórios legados já foram excluídos: " + ", ".join(f"`{_cell(name)}`" for name in deleted) + ".")
        if deferred:
            reason = deferred.get("reason", "Recurso adiado")
            features = [key for key in deferred if key != "reason"]
            lines.append(f"- Configurações adiadas: **{_cell(features)}**. Motivo: {_cell(reason)}.")
        lines.append("")
    if not changes:
        lines.append("Nenhuma alteração necessária.")
        return "\n".join(lines) + "\n"

    categories: dict[str, list[dict[str, Any]]] = {}
    for change in changes:
        categories.setdefault(str(change.get("category", "outros")), []).append(change)
    for category, items in categories.items():
        lines.extend([
            f"## {category} ({len(items)})",
            "",
            "| Ação | Alvo | Detalhes |",
            "|---|---|---|",
        ])
        for item in items:
            lines.append(f"| {_cell(item.get('action'))} | {_cell(item.get('target'))} | {_cell(item.get('details', {}))} |")
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"
