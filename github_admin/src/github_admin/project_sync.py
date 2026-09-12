from __future__ import annotations

import json
import re
import unicodedata
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from typing import Any, Iterable

from .backlog import BacklogItem, parse_backlog
from .client import GitHubClient, GitHubError
from .config import Config


SQUADS = {
    "product-governance.md": "Product",
    "backend.md": "Backend",
    "frontend.md": "Frontend",
    "database.md": "Database",
    "cloud-devops.md": "Cloud & DevOps",
    "quality-security.md": "Quality & Security",
}


def _normalized(value: str) -> str:
    decomposed = unicodedata.normalize("NFKD", value)
    return " ".join("".join(char for char in decomposed if not unicodedata.combining(char)).casefold().split())


def _chunks(values: list[Any], size: int) -> Iterable[list[Any]]:
    for index in range(0, len(values), size):
        yield values[index:index + size]


class ProjectSynchronizer:
    def __init__(self, client: GitHubClient, config: Config) -> None:
        self.client = client
        self.config = config
        self.org = config.organization

    def sync(self, backlog_dir: Path, *, stage: str = "all", repository: str | None = None) -> dict[str, Any]:
        projects = self._projects()
        title = self.config.data["project"]["title"]
        target = next((project for project in projects if project["title"] == title), None)
        if not target:
            raise GitHubError(f"Project não encontrado: {title}")

        expected = self._expected(backlog_dir)
        issues, missing, extra = self._issues(expected)
        if missing:
            raise GitHubError("Issues ausentes antes do sync: " + ", ".join(sorted(missing)))

        fields = self._ensure_fields(target["id"], target["fields"]["nodes"], expected)
        content_to_item = self._project_items(target["id"])
        if stage in {"all", "structure"}:
            self._ensure_status(fields)
            self._ensure_views(target, target["views"]["nodes"])
            missing_content = [issue["node_id"] for issue in issues.values() if issue["node_id"] not in content_to_item]
            self._add_items(target["id"], missing_content)
            content_to_item = self._project_items(target["id"])
        selected = {work_id: data for work_id, data in expected.items() if repository is None or data[1] == repository}
        if stage in {"all", "fields"}:
            self._set_fields(target["id"], fields, selected, issues, content_to_item)
        issue_updates = {"updated": 0}
        if stage in {"all", "issues"}:
            self._ensure_labels(repository)
            issue_updates = self._update_issues(selected, issues)
        assignment = self._assign_issues(selected, issues) if stage in {"all", "assignments"} else {"assigned": 0, "unresolved": [], "failed": []}

        deleted: list[str] = []
        if stage in {"all", "cleanup"}:
            for project in projects:
                if project["id"] == target["id"] or project["items"]["totalCount"] != 0:
                    continue
                mutation = "mutation($id:ID!){deleteProjectV2(input:{projectId:$id}){projectV2{id}}}"
                self.client.graphql(mutation, {"id": project["id"]})
                deleted.append(project["title"])

        return {
            "project": {"number": target["number"], "title": title},
            "stage": stage,
            "repository": repository,
            "expected_tasks": len(expected),
            "linked_items": len(content_to_item),
            "missing_tasks": sorted(missing),
            "extra_issues": sorted(extra),
            "assignments": assignment,
            "issue_updates": issue_updates,
            "deleted_empty_projects": deleted,
        }

    def _projects(self) -> list[dict[str, Any]]:
        query = """query($login:String!){organization(login:$login){projectsV2(first:100){nodes{
        id number title items{totalCount} views(first:50){nodes{id number name layout filter}}
        fields(first:50){nodes{... on ProjectV2Field{id name dataType} ... on ProjectV2SingleSelectField{id name dataType options{id name}}}}
        }}}}"""
        return list(self.client.graphql(query, {"login": self.org})["organization"]["projectsV2"]["nodes"])

    def _expected(self, directory: Path) -> dict[str, tuple[BacklogItem, str, str]]:
        result: dict[str, tuple[BacklogItem, str, str]] = {}
        for filename, repository in self.config.data["backlogs"].items():
            for item in parse_backlog(directory / filename):
                result[item.work_id] = (item, repository, SQUADS[filename])
        return result

    def _issues(self, expected: dict[str, tuple[BacklogItem, str, str]]) -> tuple[dict[str, dict[str, Any]], set[str], set[str]]:
        found: dict[str, dict[str, Any]] = {}
        all_ids: set[str] = set()
        for repository in set(self.config.data["backlogs"].values()):
            for issue in self.client.paginate(f"/repos/{self.org}/{repository}/issues?state=all"):
                if "pull_request" in issue:
                    continue
                match = re.match(r"^\[([A-Z]+-\d{3})\]", issue["title"])
                if match:
                    found[match.group(1)] = {**issue, "repository": repository}
                    all_ids.add(match.group(1))
        wanted = set(expected)
        return found, wanted - all_ids, all_ids - wanted

    def _ensure_fields(self, project_id: str, current: list[dict[str, Any]], expected: dict[str, tuple[BacklogItem, str, str]]) -> dict[str, dict[str, Any]]:
        fields = {field["name"]: field for field in current}
        exact_sprints = sorted({entry[0].priority_sprint.split("/", 1)[1] for entry in expected.values()}, key=lambda value: (value == "Future", value))
        definitions = {
            "Sprint": ("SINGLE_SELECT", exact_sprints),
            "Squad": ("SINGLE_SELECT", list(SQUADS.values())),
            "Priority": ("SINGLE_SELECT", ["P0", "P1", "P2", "P3"]),
            "Size": ("NUMBER", []),
            "Work ID": ("TEXT", []),
            "Responsável planejado": ("TEXT", []),
            "Review owner": ("TEXT", []),
            "Dependencies": ("TEXT", []),
        }
        colors = ["BLUE", "GREEN", "YELLOW", "ORANGE", "RED", "PURPLE", "PINK", "GRAY"]
        mutation = "mutation($input:CreateProjectV2FieldInput!){createProjectV2Field(input:$input){projectV2Field{... on ProjectV2Field{id name dataType} ... on ProjectV2SingleSelectField{id name dataType options{id name}}}}}"
        for name, (data_type, options) in definitions.items():
            if name in fields:
                continue
            payload: dict[str, Any] = {"projectId": project_id, "name": name, "dataType": data_type}
            if options:
                payload["singleSelectOptions"] = [{"name": option, "color": colors[index % len(colors)], "description": ""} for index, option in enumerate(options)]
            created = self.client.graphql(mutation, {"input": payload})["createProjectV2Field"]["projectV2Field"]
            fields[name] = created
        return fields

    def _ensure_status(self, fields: dict[str, dict[str, Any]]) -> None:
        status = fields["Status"]
        desired = ["Backlog", "Refinement", "Ready", "In Progress", "In Review", "Validation", "Blocked", "Done"]
        if [option["name"] for option in status.get("options", [])] == desired:
            return
        colors = ["GRAY", "BLUE", "GREEN", "YELLOW", "PURPLE", "PINK", "RED", "GREEN"]
        options = [{"name": name, "color": colors[index], "description": ""} for index, name in enumerate(desired)]
        mutation = "mutation($input:UpdateProjectV2FieldInput!){updateProjectV2Field(input:$input){projectV2Field{... on ProjectV2SingleSelectField{id name options{id name}}}}}"
        self.client.graphql(mutation, {"input": {"fieldId": status["id"], "singleSelectOptions": options}})

    def _ensure_views(self, project: dict[str, Any], current: list[dict[str, Any]]) -> None:
        existing = {view["name"] for view in current}
        squad_views = [(f"Squad — {squad}", f'Squad:"{squad}"') for squad in SQUADS.values()]
        desired = [("Backlog Geral", "is:issue"), *squad_views, *[(f"Sprint {number}", f'Sprint:"S{number}"') for number in range(7)], ("Contínuas S1–4", 'Sprint:"S1–4"'), ("Future", 'Sprint:"Future"')]
        for name, view_filter in desired:
            if name in existing:
                continue
            self.client.post(f"/orgs/{self.org}/projectsV2/{project['number']}/views", {"name": name, "layout": "board", "filter": view_filter})
        for view in current:
            if view["name"].startswith("View ") and "Backlog Geral" in existing:
                mutation = "mutation($id:ID!){deleteProjectV2View(input:{viewId:$id}){projectV2View{id}}}"
                self.client.graphql(mutation, {"id": view["id"]})

    def _project_items(self, project_id: str) -> dict[str, str]:
        result: dict[str, str] = {}
        cursor: str | None = None
        query = """query($id:ID!,$cursor:String){node(id:$id){... on ProjectV2{items(first:100,after:$cursor){pageInfo{hasNextPage endCursor} nodes{id content{... on Issue{id}}}}}}}"""
        while True:
            connection = self.client.graphql(query, {"id": project_id, "cursor": cursor})["node"]["items"]
            for node in connection["nodes"]:
                if node.get("content"):
                    result[node["content"]["id"]] = node["id"]
            if not connection["pageInfo"]["hasNextPage"]:
                return result
            cursor = connection["pageInfo"]["endCursor"]

    def _add_items(self, project_id: str, content_ids: list[str]) -> None:
        mutation = "mutation($project:ID!,$content:ID!){addProjectV2ItemById(input:{projectId:$project,contentId:$content}){item{id}}}"
        for content_id in content_ids:
            self.client.graphql(mutation, {"project": project_id, "content": content_id})

    def _set_fields(self, project_id: str, fields: dict[str, dict[str, Any]], expected: dict[str, tuple[BacklogItem, str, str]], issues: dict[str, dict[str, Any]], content_to_item: dict[str, str]) -> None:
        updates: list[tuple[str, str, dict[str, Any]]] = []
        option_fields = {name: {option["name"]: option["id"] for option in field.get("options", [])} for name, field in fields.items()}
        for work_id, (item, _repository, squad) in expected.items():
            project_item = content_to_item[issues[work_id]["node_id"]]
            priority, sprint = item.priority_sprint.split("/", 1)
            values = {
                "Sprint": {"singleSelectOptionId": option_fields["Sprint"][sprint]},
                "Squad": {"singleSelectOptionId": option_fields["Squad"][squad]},
                "Priority": {"singleSelectOptionId": option_fields["Priority"][priority]},
                "Size": {"number": float(item.points)},
                "Work ID": {"text": work_id},
                "Responsável planejado": {"text": item.assignee},
                "Review owner": {"text": item.reviewer},
                "Dependencies": {"text": item.dependencies},
            }
            updates.extend((project_item, fields[name]["id"], value) for name, value in values.items())
        def update_batch(batch: list[tuple[str, str, dict[str, Any]]]) -> None:
            declarations = ["$project:ID!"]
            operations: list[str] = []
            variables: dict[str, Any] = {"project": project_id}
            for index, (project_item, field_id, value) in enumerate(batch):
                declarations.extend([f"$item{index}:ID!", f"$field{index}:ID!", f"$value{index}:ProjectV2FieldValue!"])
                operations.append(f"u{index}:updateProjectV2ItemFieldValue(input:{{projectId:$project,itemId:$item{index},fieldId:$field{index},value:$value{index}}}){{projectV2Item{{id}}}}")
                variables[f"item{index}"] = project_item
                variables[f"field{index}"] = field_id
                variables[f"value{index}"] = value
            self.client.graphql(f"mutation({','.join(declarations)}){{{''.join(operations)}}}", variables)

        batches = list(_chunks(updates, 20))
        with ThreadPoolExecutor(max_workers=4) as executor:
            futures = [executor.submit(update_batch, batch) for batch in batches]
            for future in as_completed(futures):
                future.result()

    def _resolve_assignees(self, value: str) -> list[str]:
        people = self.config.data.get("people", {})
        normalized_people = [(_normalized(name), username) for name, username in people.items()]
        result: list[str] = []
        for part in re.split(r"\s+e\s+", value, flags=re.IGNORECASE):
            wanted = _normalized(part)
            matches = [username for name, username in normalized_people if name.startswith(wanted)]
            if len(matches) == 1:
                result.append(matches[0])
        return result

    def _ensure_labels(self, selected_repository: str | None) -> None:
        repositories = [selected_repository] if selected_repository else list(self.config.data["backlogs"].values())
        for repository in repositories:
            existing = {label["name"] for label in self.client.paginate(f"/repos/{self.org}/{repository}/labels")}
            for label in self.config.data.get("labels", []):
                if label["name"] not in existing:
                    self.client.post(f"/repos/{self.org}/{repository}/labels", {"name": label["name"], "color": label["color"], "description": label.get("description", "")})

    @staticmethod
    def _issue_labels(item: BacklogItem, squad: str) -> list[str]:
        priority, sprint = item.priority_sprint.split("/", 1)
        squad_labels = {"Product": "squad:product", "Backend": "squad:backend", "Frontend": "squad:frontend", "Database": "squad:database", "Cloud & DevOps": "squad:cloud", "Quality & Security": "squad:quality"}
        work_type = "type:spike" if "spike" in item.title.casefold() else "type:task"
        release = "future:2027.1" if sprint == "Future" else "release:v1.0.0"
        labels = [work_type, f"priority:{priority}", squad_labels[squad], release]
        if "seguran" in _normalized(item.title) or "owasp" in item.title.casefold():
            labels.append("needs-security")
        return labels

    def _update_issues(self, expected: dict[str, tuple[BacklogItem, str, str]], issues: dict[str, dict[str, Any]]) -> dict[str, Any]:
        failures: list[dict[str, str]] = []

        def update(work_id: str) -> None:
            item, _repository, squad = expected[work_id]
            issue = issues[work_id]
            self.client.patch(f"/repos/{self.org}/{issue['repository']}/issues/{issue['number']}", {"body": item.body, "labels": self._issue_labels(item, squad)})

        with ThreadPoolExecutor(max_workers=4) as executor:
            futures = {executor.submit(update, work_id): work_id for work_id in expected}
            for future in as_completed(futures):
                try:
                    future.result()
                except GitHubError as exc:
                    failures.append({"work_id": futures[future], "error": str(exc)})
        return {"updated": len(expected) - len(failures), "failed": failures}

    def _assign_issues(self, expected: dict[str, tuple[BacklogItem, str, str]], issues: dict[str, dict[str, Any]]) -> dict[str, Any]:
        assigned = 0
        unresolved: list[str] = []
        failed: list[dict[str, str]] = []

        def assign(work_id: str) -> tuple[str, str | None]:
            item = expected[work_id][0]
            usernames = self._resolve_assignees(item.assignee)
            if not usernames:
                return "unresolved", item.assignee
            issue = issues[work_id]
            try:
                self.client.patch(f"/repos/{self.org}/{issue['repository']}/issues/{issue['number']}", {"assignees": usernames})
                return "assigned", None
            except GitHubError as exc:
                return "failed", str(exc)

        with ThreadPoolExecutor(max_workers=4) as executor:
            futures = {executor.submit(assign, work_id): work_id for work_id in expected}
            for future in as_completed(futures):
                status, detail = future.result()
                if status == "assigned":
                    assigned += 1
                elif status == "unresolved":
                    unresolved.append(f"{futures[future]}: {detail}")
                else:
                    failed.append({"work_id": futures[future], "error": detail or "erro desconhecido"})
        return {"assigned": assigned, "unresolved": sorted(unresolved), "failed": failed}
