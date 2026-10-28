import json
from pathlib import Path

from github_admin.config import load_config, validate_config


def test_example_config_is_valid():
    config_path = Path(__file__).parents[1] / "config" / "github.example.json"
    config = load_config(config_path)
    assert config.organization == "UniSENAI-Sorocaba"
    assert len(config.repositories) == 6
    assert len(config.teams) == 9


def test_duplicate_repository_is_rejected():
    data = {"organization": "org", "repositories": [{"name": "repo"}, {"name": "repo"}]}
    assert "repositório duplicado: repo" in validate_config(data)


def test_unknown_backlog_repository_is_rejected():
    data = {"organization": "org", "repositories": [], "backlogs": {"a.md": "missing"}}
    assert any("missing" in error for error in validate_config(data))


def test_unknown_access_team_is_rejected():
    data = {
        "organization": "org",
        "teams": [{"name": "backend"}],
        "repositories": [{"name": "api", "access": [{"team": "missing", "permission": "push"}]}],
    }

    assert any("team referencia team ausente" in error for error in validate_config(data))


def test_invalid_repository_permission_is_rejected():
    data = {
        "organization": "org",
        "teams": [{"name": "backend"}],
        "repositories": [{"name": "api", "access": [{"team": "backend", "permission": "owner"}]}],
    }

    assert any("permission é inválida" in error for error in validate_config(data))
