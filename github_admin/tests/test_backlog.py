from pathlib import Path

from github_admin.backlog import parse_backlog


def test_parses_real_backlogs():
    root = Path(__file__).parents[2] / "backlogs"
    items = [item for path in root.glob("*.md") for item in parse_backlog(path)]
    assert len(items) == 141
    assert len({item.work_id for item in items}) == 141
    assert all(item.title and item.assignee and item.reviewer for item in items)


def test_issue_body_preserves_assignment():
    path = Path(__file__).parents[2] / "backlogs" / "product-governance.md"
    item = parse_backlog(path)[0]
    assert item.issue_title.startswith("[PG-001]")
    assert "Luciano Menezes Júnior" in item.body
    assert "Fellipe Raszejas" in item.body
