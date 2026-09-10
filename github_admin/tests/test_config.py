import json

from github_admin.config import load_config, validate_config


def test_example_config_is_valid():
    config = load_config("config/github.example.json")
    assert config.organization == "unisenaisorocaba"
    assert len(config.repositories) == 6
    assert len(config.teams) == 8


def test_duplicate_repository_is_rejected():
    data = {"organization": "org", "repositories": [{"name": "repo"}, {"name": "repo"}]}
    assert "repositório duplicado: repo" in validate_config(data)


def test_unknown_backlog_repository_is_rejected():
    data = {"organization": "org", "repositories": [], "backlogs": {"a.md": "missing"}}
    assert any("missing" in error for error in validate_config(data))
