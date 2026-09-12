from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

from .client import GitHubClient, GitHubError
from .config import ConfigError, load_config
from .env import load_dotenv
from .manager import GitHubManager, changes_as_dicts
from .report import audit_markdown, plan_markdown


def parser() -> argparse.ArgumentParser:
    root = argparse.ArgumentParser(prog="plataforma-github", description="Audita e configura a organização GitHub")
    commands = root.add_subparsers(dest="command", required=True)
    for name in ("validate", "audit", "audit-projects", "plan", "apply", "import-backlogs", "sync-project", "delete-legacy"):
        command = commands.add_parser(name)
        command.add_argument("--config", required=True, type=Path)
        if name in {"audit", "audit-projects", "plan"}:
            default_output = Path("audit-report.md" if name == "audit" else "project-inventory.json" if name == "audit-projects" else "plan.md")
            command.add_argument("--output", type=Path, default=default_output)
        if name in {"apply", "import-backlogs", "sync-project", "delete-legacy"}:
            command.add_argument("--confirm", required=True, help="Digite exatamente o login da organização")
        if name == "delete-legacy":
            command.add_argument("--confirm-delete", required=True, choices=["DELETE-LEGACY"])
        if name == "apply":
            command.add_argument("--only", action="append", choices=["teams", "repositories", "members", "permissions", "labels", "environments", "rulesets", "project"])
            command.add_argument("--team", action="append", help="Em members, limita a execução aos slugs informados")
        if name in {"import-backlogs", "sync-project"}:
            command.add_argument("--backlog-dir", type=Path, default=Path("../backlogs"))
        if name == "sync-project":
            command.add_argument("--stage", choices=["all", "structure", "fields", "issues", "assignments", "cleanup"], default="all")
            command.add_argument("--repository")
    return root


def write_result(value: Any, output: Path | None = None, markdown: str | None = None) -> None:
    text = markdown if output and output.suffix.lower() == ".md" and markdown is not None else json.dumps(value, ensure_ascii=False, indent=2) + "\n"
    if output:
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(text, encoding="utf-8")
        print(f"Relatório salvo em {output}")
    else:
        print(text, end="")


def main(argv: list[str] | None = None) -> int:
    args = parser().parse_args(argv)
    try:
        config = load_config(args.config)
        if args.command == "validate":
            write_result({"valid": True, "organization": config.organization, "repositories": len(config.repositories), "teams": len(config.teams)})
            return 0
        if getattr(args, "confirm", config.organization) != config.organization:
            raise ConfigError("--confirm deve ser exatamente igual a organization")
        load_dotenv()
        manager = GitHubManager(GitHubClient(), config)
        if args.command == "audit":
            audit = manager.audit()
            write_result(audit, args.output, audit_markdown(audit))
        elif args.command == "audit-projects":
            write_result(manager.project_inventory(), args.output)
        elif args.command == "plan":
            changes = changes_as_dicts(manager.plan())
            write_result(changes, args.output, plan_markdown(changes, config.data))
        elif args.command == "apply":
            only = set(args.only or [])
            changes = manager.member_changes(set(args.team or [])) if only == {"members"} and args.team else manager.plan()
            if args.team and only != {"members"}:
                selected_teams = {team.lower() for team in args.team}
                changes = [change for change in changes if change.category != "members" or str(change.details.get("team", "")).lower() in selected_teams]
            results = manager.apply(changes, only)
            write_result(results)
            return 1 if any(item["result"] == "error" for item in results) else 0
        elif args.command == "import-backlogs":
            results = manager.import_backlogs(args.backlog_dir.resolve())
            write_result(results)
        elif args.command == "sync-project":
            from .project_sync import ProjectSynchronizer
            result = ProjectSynchronizer(manager.client, config).sync(args.backlog_dir.resolve(), stage=args.stage, repository=args.repository)
            write_result(result, Path("project-sync-report.json"))
        elif args.command == "delete-legacy":
            results = manager.delete_legacy_repositories()
            write_result(results)
            return 1 if any(item["result"] == "error" for item in results) else 0
        return 0
    except (ConfigError, GitHubError, OSError, ValueError) as exc:
        print(f"erro: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
