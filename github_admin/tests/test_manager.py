from types import SimpleNamespace

from github_admin.manager import GitHubManager


def test_ruleset_payload_protects_main():
    payload = GitHubManager._ruleset_payload({"name": "protect-main", "required_approvals": 1, "required_checks": ["test"]})
    assert payload["conditions"]["ref_name"]["include"] == ["refs/heads/main"]
    assert any(rule["type"] == "pull_request" for rule in payload["rules"])
    assert any(rule["type"] == "required_status_checks" for rule in payload["rules"])


def test_slug_is_stable():
    assert GitHubManager._slug("Cloud DevOps") == "cloud-devops"


def test_delete_legacy_is_limited_to_configured_repositories():
    class Client:
        def __init__(self):
            self.deleted = []

        def delete(self, path):
            self.deleted.append(path)

    client = Client()
    config = SimpleNamespace(
        organization="org",
        repositories=[{"name": "new-repo"}],
        data={"migration": {"legacy_repositories": ["old-repo"]}},
    )
    manager = GitHubManager(client, config)

    assert manager.delete_legacy_repositories() == [{"target": "old-repo", "result": "deleted"}]
    assert client.deleted == ["/repos/org/old-repo"]
