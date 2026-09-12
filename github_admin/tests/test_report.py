from pathlib import Path

from github_admin.cli import parser
from github_admin.report import audit_markdown, plan_markdown


def test_audit_markdown_contains_readable_sections():
    report = audit_markdown({
        "organization": {"login": "example", "plan": "team", "two_factor_requirement_enabled": True},
        "repositories": ["api"],
        "teams": ["backend"],
        "projects": ["Roadmap"],
        "details": {"api": {"visibility": "private", "default_branch": "main", "size_kb": 10, "archived": False, "open_issues": 2, "rulesets": ["main"], "environments": ["prod"], "labels": ["bug"]}},
    })

    assert "# Relatório de auditoria do GitHub" in report
    assert "## Repositórios (1)" in report
    assert "### `api`" in report


def test_plan_markdown_groups_changes_by_category():
    report = plan_markdown([
        {"category": "teams", "action": "create", "target": "Backend", "details": {"privacy": "closed"}},
        {"category": "teams", "action": "create", "target": "Frontend", "details": {}},
    ])

    assert "Total de alterações propostas: **2**" in report
    assert "## teams (2)" in report
    assert "| create | Backend |" in report


def test_audit_and_plan_default_to_markdown_files():
    command_parser = parser()

    assert command_parser.parse_args(["audit", "--config", "config.json"]).output == Path("audit-report.md")
    assert command_parser.parse_args(["plan", "--config", "config.json"]).output == Path("plan.md")


def test_plan_markdown_documents_legacy_and_deferred_scope():
    report = plan_markdown([], {
        "migration": {"legacy_repositories": ["legacy-api"]},
        "deferred_until_github_team": {"reason": "plano Free", "ruleset": {}},
    })

    assert "## Fora do escopo imediato" in report
    assert "`legacy-api`" in report
    assert "plano Free" in report
