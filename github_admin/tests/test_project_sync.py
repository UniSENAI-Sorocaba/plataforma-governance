from types import SimpleNamespace

from github_admin.project_sync import ProjectSynchronizer


def test_resolves_abbreviated_and_composite_assignees():
    config = SimpleNamespace(organization="org", data={"people": {
        "Giovani Bernardo Miamoto Santos": "giovani",
        "Swell Gomes Nunes": "swell",
    }})
    sync = ProjectSynchronizer(None, config)

    assert sync._resolve_assignees("Giovani e Swell") == ["giovani", "swell"]


def test_unknown_assignee_is_not_guessed():
    config = SimpleNamespace(organization="org", data={"people": {"Paulo Silva": "paulo"}})
    sync = ProjectSynchronizer(None, config)

    assert sync._resolve_assignees("Paola") == []
