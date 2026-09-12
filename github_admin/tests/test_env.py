import os
from pathlib import Path

import pytest

from github_admin.env import load_dotenv


def dotenv(monkeypatch, content: str) -> Path:
    env_file = Path("virtual.env")
    monkeypatch.setattr(Path, "is_file", lambda self: self == env_file)
    monkeypatch.setattr(Path, "read_text", lambda self, **kwargs: content)
    return env_file


def test_loads_token_from_dotenv(monkeypatch):
    monkeypatch.delenv("GH_TOKEN", raising=False)
    env_file = dotenv(monkeypatch, "# local secret\nGH_TOKEN='github-token'\n")

    assert load_dotenv(env_file) == env_file
    assert os.environ["GH_TOKEN"] == "github-token"


def test_process_environment_has_precedence(monkeypatch):
    monkeypatch.setenv("GH_TOKEN", "process-token")
    env_file = dotenv(monkeypatch, "GH_TOKEN=file-token\n")

    load_dotenv(env_file)

    assert os.environ["GH_TOKEN"] == "process-token"


def test_rejects_invalid_dotenv_line(monkeypatch):
    env_file = dotenv(monkeypatch, "invalid-line\n")

    with pytest.raises(ValueError, match="Linha inválida"):
        load_dotenv(env_file)
