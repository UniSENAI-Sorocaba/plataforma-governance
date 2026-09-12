from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any


class ConfigError(ValueError):
    pass


@dataclass(frozen=True)
class Config:
    path: Path
    data: dict[str, Any]

    @property
    def organization(self) -> str:
        return str(self.data["organization"])

    @property
    def repositories(self) -> list[dict[str, Any]]:
        return list(self.data.get("repositories", []))

    @property
    def teams(self) -> list[dict[str, Any]]:
        return list(self.data.get("teams", []))


def load_config(path: str | Path) -> Config:
    config_path = Path(path).resolve()
    try:
        data = json.loads(config_path.read_text(encoding="utf-8"))
    except FileNotFoundError as exc:
        raise ConfigError(f"Configuração não encontrada: {config_path}") from exc
    except json.JSONDecodeError as exc:
        raise ConfigError(f"JSON inválido em {config_path}: {exc}") from exc
    errors = validate_config(data)
    if errors:
        raise ConfigError("; ".join(errors))
    return Config(config_path, data)


def validate_config(data: Any) -> list[str]:
    if not isinstance(data, dict):
        return ["a raiz deve ser um objeto JSON"]
    errors: list[str] = []
    org = data.get("organization")
    if not isinstance(org, str) or not org.strip():
        errors.append("organization é obrigatório")
    repos = data.get("repositories", [])
    if not isinstance(repos, list):
        errors.append("repositories deve ser uma lista")
        repos = []
    repo_names: set[str] = set()
    for index, repo in enumerate(repos):
        if not isinstance(repo, dict) or not repo.get("name"):
            errors.append(f"repositories[{index}].name é obrigatório")
            continue
        name = str(repo["name"])
        if name in repo_names:
            errors.append(f"repositório duplicado: {name}")
        repo_names.add(name)
    teams = data.get("teams", [])
    if not isinstance(teams, list):
        errors.append("teams deve ser uma lista")
        teams = []
    team_names: set[str] = set()
    for index, team in enumerate(teams):
        if not isinstance(team, dict) or not team.get("name"):
            errors.append(f"teams[{index}].name é obrigatório")
            continue
        name = str(team["name"])
        if name in team_names:
            errors.append(f"team duplicado: {name}")
        team_names.add(name)
    valid_permissions = {"pull", "triage", "push", "maintain", "admin"}
    for repo_index, repo in enumerate(repos):
        if not isinstance(repo, dict):
            continue
        access = repo.get("access")
        if access is None:
            if repo.get("team") not in team_names:
                errors.append(f"repositories[{repo_index}].team referencia team ausente")
            continue
        if not isinstance(access, list) or not access:
            errors.append(f"repositories[{repo_index}].access deve ser uma lista não vazia")
            continue
        for access_index, grant in enumerate(access):
            if not isinstance(grant, dict) or grant.get("team") not in team_names:
                errors.append(f"repositories[{repo_index}].access[{access_index}].team referencia team ausente")
            if not isinstance(grant, dict) or grant.get("permission") not in valid_permissions:
                errors.append(f"repositories[{repo_index}].access[{access_index}].permission é inválida")
    mapping = data.get("backlogs", {})
    if not isinstance(mapping, dict):
        errors.append("backlogs deve ser um objeto")
    else:
        unknown = sorted(set(mapping.values()) - repo_names)
        if unknown:
            errors.append("backlogs referenciam repositórios ausentes: " + ", ".join(unknown))
    return errors
