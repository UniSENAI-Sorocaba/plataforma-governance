from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

from .client import GitHubClient, GitHubError
from .config import ConfigError, load_config
from .manager import GitHubManager, changes_as_dicts


def parser() -> argparse.ArgumentParser:
    root = argparse.ArgumentParser(prog="plataforma-github", description="Audita e configura a organização GitHub")
    commands = root.add_subparsers(dest="command", required=True)
    for name in ("validate", "audit", "plan", "apply", "import-backlogs"):
        command = commands.add_parser(name)
        command.add_argument("--config", required=True, type=Path)
        if name in {"audit", "plan"}:
            command.add_argument("--output", type=Path)
        if name in {"apply", "import-backlogs"}:
            command.add_argument("--confirm", required=True, help="Digite exatamente o login da organização")
        if name == "apply":
            command.add_argument("--only", action="append", choices=["teams", "repositories", "members", "permissions", "labels", "environments", "rulesets", "project"])
        if name == "import-backlogs":
            command.add_argument("--backlog-dir", type=Path, default=Path("../backlogs"))
    return root


def write_result(value: Any, output: Path | None = None) -> None:
    text = json.dumps(value, ensure_ascii=False, indent=2) + "\n"
    if output:
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
        manager = GitHubManager(GitHubClient(), config)
        if args.command == "audit":
            write_result(manager.audit(), args.output)
        elif args.command == "plan":
            write_result(changes_as_dicts(manager.plan()), args.output)
        elif args.command == "apply":
            results = manager.apply(manager.plan(), set(args.only or []))
            write_result(results)
            return 1 if any(item["result"] == "error" for item in results) else 0
        elif args.command == "import-backlogs":
            results = manager.import_backlogs(args.backlog_dir.resolve())
            write_result(results)
        return 0
    except (ConfigError, GitHubError, OSError, ValueError) as exc:
        print(f"erro: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
