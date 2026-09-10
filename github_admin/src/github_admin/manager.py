from __future__ import annotations

from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any, Iterable

from .backlog import parse_backlog
from .client import GitHubClient, GitHubError
from .config import Config


@dataclass(frozen=True)
class Change:
    category: str
    action: str
    target: str
    details: dict[str, Any]


class GitHubManager:
    def __init__(self, client: GitHubClient, config: Config) -> None:
        self.client, self.config, self.org = client, config, config.organization

    def audit(self) -> dict[str, Any]:
        org = self.client.get(f"/orgs/{self.client.quote(self.org)}")
        repos = self.client.paginate(f"/orgs/{self.client.quote(self.org)}/repos?type=all")
        teams = self.client.paginate(f"/orgs/{self.client.quote(self.org)}/teams")
        details: dict[str, Any] = {}
        for wanted in self.config.repositories:
            name = wanted["name"]
            repo = next((item for item in repos if item["name"].lower() == name.lower()), None)
            if not repo:
                continue
            envs = self._safe_get(f"/repos/{self.org}/{name}/environments")
            details[name] = {
                "visibility": repo.get("visibility"),
                "default_branch": repo.get("default_branch"),
                "rulesets": [item.get("name") for item in self._safe_list(f"/repos/{self.org}/{name}/rulesets")],
                "environments": [item.get("name") for item in envs.get("environments", [])],
                "labels": [item.get("name") for item in self.client.paginate(f"/repos/{self.org}/{name}/labels")],
            }
        return {
            "organization": {"login": org.get("login"), "plan": (org.get("plan") or {}).get("name", "not_exposed"), "two_factor_requirement_enabled": org.get("two_factor_requirement_enabled")},
            "repositories": sorted(item["name"] for item in repos),
            "teams": sorted(item["slug"] for item in teams),
            "projects": self._list_projects(),
            "details": details,
        }

    def plan(self, state: dict[str, Any] | None = None) -> list[Change]:
        state = state or self.audit()
        changes: list[Change] = []
        repos = {name.lower() for name in state["repositories"]}
        teams = {name.lower() for name in state["teams"]}
        for team in self.config.teams:
            slug = self._slug(team["name"])
            if slug not in teams:
                changes.append(Change("teams", "create", team["name"], team))
            for username in team.get("members", []):
                changes.append(Change("members", "ensure", f"{slug}/{username}", {"team": slug, "username": username}))
        for repo in self.config.repositories:
            name = repo["name"]
            if name.lower() not in repos:
                changes.append(Change("repositories", "create", name, repo))
            changes.append(Change("permissions", "ensure", f"{repo['team']}/{name}", {"team": repo["team"], "repository": name, "permission": "push"}))
            detail = state.get("details", {}).get(name, {})
            for label in self.config.data.get("labels", []):
                if label["name"] not in detail.get("labels", []):
                    changes.append(Change("labels", "create", f"{name}/{label['name']}", {"repository": name, **label}))
            for environment in self.config.data.get("environments", []):
                if environment not in detail.get("environments", []):
                    changes.append(Change("environments", "create", f"{name}/{environment}", {"repository": name, "environment": environment}))
            ruleset = self.config.data.get("ruleset")
            if ruleset and ruleset["name"] not in detail.get("rulesets", []):
                changes.append(Change("rulesets", "create", f"{name}/{ruleset['name']}", {"repository": name, **ruleset}))
        project = self.config.data.get("project", {})
        if project.get("create") and project.get("title") not in state.get("projects", []):
            changes.append(Change("project", "create", project["title"], project))
        return changes

    def apply(self, changes: Iterable[Change], only: set[str] | None = None) -> list[dict[str, str]]:
        order = {"teams": 1, "repositories": 2, "members": 3, "permissions": 4, "labels": 5, "environments": 6, "rulesets": 7, "project": 8}
        results: list[dict[str, str]] = []
        for change in sorted(changes, key=lambda item: order.get(item.category, 99)):
            if only and change.category not in only:
                continue
            try:
                self._apply_one(change)
                results.append({"category": change.category, "target": change.target, "result": "ok"})
            except GitHubError as exc:
                results.append({"category": change.category, "target": change.target, "result": "error", "message": str(exc)})
                break
        return results

    def import_backlogs(self, directory: Path) -> list[dict[str, str]]:
        results: list[dict[str, str]] = []
        for filename, repository in self.config.data.get("backlogs", {}).items():
            existing = self.client.paginate(f"/repos/{self.org}/{repository}/issues?state=all")
            titles = {item["title"] for item in existing if "pull_request" not in item}
            for item in parse_backlog(directory / filename):
                if item.issue_title in titles:
                    results.append({"target": item.work_id, "result": "exists"})
                    continue
                priority = item.priority_sprint.split("/", 1)[0]
                self.client.post(f"/repos/{self.org}/{repository}/issues", {"title": item.issue_title, "body": item.body, "labels": [f"priority:{priority}", "type:task"]})
                results.append({"target": item.work_id, "result": "created"})
        return results

    def _apply_one(self, change: Change) -> None:
        data = change.details
        if change.category == "teams":
            self.client.post(f"/orgs/{self.org}/teams", {"name": data["name"], "privacy": data.get("privacy", "closed")})
        elif change.category == "repositories":
            self.client.post(f"/orgs/{self.org}/repos", {"name": data["name"], "description": data.get("description", ""), "private": data.get("private", True), "has_issues": True, "has_wiki": False, "delete_branch_on_merge": True, "allow_squash_merge": True, "allow_merge_commit": False})
        elif change.category == "members":
            self.client.put(f"/orgs/{self.org}/teams/{data['team']}/memberships/{data['username']}", {"role": "member"})
        elif change.category == "permissions":
            self.client.put(f"/orgs/{self.org}/teams/{data['team']}/repos/{self.org}/{data['repository']}", {"permission": data["permission"]})
        elif change.category == "labels":
            self.client.post(f"/repos/{self.org}/{data['repository']}/labels", {"name": data["name"], "color": data["color"], "description": data.get("description", "")})
        elif change.category == "environments":
            self.client.put(f"/repos/{self.org}/{data['repository']}/environments/{data['environment']}", {})
        elif change.category == "rulesets":
            self.client.post(f"/repos/{self.org}/{data['repository']}/rulesets", self._ruleset_payload(data))
        elif change.category == "project":
            self._create_project(data["title"])
        else:
            raise GitHubError(f"Categoria não suportada: {change.category}")

    def _list_projects(self) -> list[str]:
        query = "query($login:String!){organization(login:$login){projectsV2(first:100){nodes{title}}}}"
        data = self.client.graphql(query, {"login": self.org})
        return [node["title"] for node in data["organization"]["projectsV2"]["nodes"]]

    def _create_project(self, title: str) -> None:
        query = "query($login:String!){organization(login:$login){id}}"
        owner_id = self.client.graphql(query, {"login": self.org})["organization"]["id"]
        mutation = "mutation($owner:ID!,$title:String!){createProjectV2(input:{ownerId:$owner,title:$title}){projectV2{id}}}"
        self.client.graphql(mutation, {"owner": owner_id, "title": title})

    def _safe_list(self, path: str) -> list[Any]:
        try:
            return self.client.paginate(path)
        except GitHubError:
            return []

    def _safe_get(self, path: str) -> dict[str, Any]:
        try:
            return dict(self.client.get(path))
        except GitHubError:
            return {}

    @staticmethod
    def _slug(name: str) -> str:
        return name.lower().replace(" ", "-")

    @staticmethod
    def _ruleset_payload(data: dict[str, Any]) -> dict[str, Any]:
        rules: list[dict[str, Any]] = [
            {"type": "deletion"},
            {"type": "non_fast_forward"},
            {"type": "pull_request", "parameters": {"required_approving_review_count": int(data.get("required_approvals", 1)), "dismiss_stale_reviews_on_push": True, "require_code_owner_review": True, "require_last_push_approval": False, "required_review_thread_resolution": True}},
        ]
        checks = data.get("required_checks", [])
        if checks:
            rules.append({"type": "required_status_checks", "parameters": {"strict_required_status_checks_policy": True, "do_not_enforce_on_create": True, "required_status_checks": [{"context": name} for name in checks]}})
        return {"name": data["name"], "target": data.get("target", "branch"), "enforcement": data.get("enforcement", "active"), "conditions": {"ref_name": {"include": ["refs/heads/main"], "exclude": []}}, "rules": rules, "bypass_actors": []}


def changes_as_dicts(changes: Iterable[Change]) -> list[dict[str, Any]]:
    return [asdict(change) for change in changes]
