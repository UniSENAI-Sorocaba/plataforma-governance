from __future__ import annotations

import json
import os
import urllib.error
import urllib.parse
import urllib.request
from typing import Any


class GitHubError(RuntimeError):
    pass


class GitHubClient:
    api_url = "https://api.github.com"

    def __init__(self, token: str | None = None, timeout: int = 30) -> None:
        self._token = token or os.environ.get("GH_TOKEN")
        if not self._token:
            raise GitHubError("GH_TOKEN não está definido")
        self.timeout = timeout

    def request(
        self,
        method: str,
        path: str,
        payload: dict[str, Any] | list[Any] | None = None,
        *,
        expected: tuple[int, ...] = (200,),
    ) -> Any:
        url = path if path.startswith("https://") else f"{self.api_url}{path}"
        body = None if payload is None else json.dumps(payload).encode("utf-8")
        headers = {
            "Accept": "application/vnd.github+json",
            "Authorization": f"Bearer {self._token}",
            "X-GitHub-Api-Version": "2022-11-28",
            "User-Agent": "plataforma-github-admin/0.1",
        }
        request = urllib.request.Request(url, data=body, headers=headers, method=method)
        try:
            with urllib.request.urlopen(request, timeout=self.timeout) as response:
                raw = response.read()
                if response.status not in expected:
                    raise GitHubError(f"GitHub respondeu HTTP {response.status} para {method} {path}")
                return json.loads(raw) if raw else None
        except urllib.error.HTTPError as exc:
            message = exc.read().decode("utf-8", errors="replace")
            try:
                detail = json.loads(message).get("message", message)
            except json.JSONDecodeError:
                detail = message
            raise GitHubError(f"GitHub HTTP {exc.code} em {method} {path}: {detail}") from exc
        except urllib.error.URLError as exc:
            raise GitHubError(f"Falha de rede ao acessar GitHub: {exc.reason}") from exc

    def get(self, path: str) -> Any:
        return self.request("GET", path)

    def post(self, path: str, payload: dict[str, Any], expected: tuple[int, ...] = (201,)) -> Any:
        return self.request("POST", path, payload, expected=expected)

    def put(self, path: str, payload: dict[str, Any] | None = None, expected: tuple[int, ...] = (200, 201, 204)) -> Any:
        return self.request("PUT", path, payload, expected=expected)

    def patch(self, path: str, payload: dict[str, Any], expected: tuple[int, ...] = (200,)) -> Any:
        return self.request("PATCH", path, payload, expected=expected)

    def delete(self, path: str, expected: tuple[int, ...] = (204,)) -> Any:
        return self.request("DELETE", path, expected=expected)

    def paginate(self, path: str, per_page: int = 100) -> list[Any]:
        separator = "&" if "?" in path else "?"
        page = 1
        result: list[Any] = []
        while True:
            batch = self.get(f"{path}{separator}per_page={per_page}&page={page}")
            if not isinstance(batch, list):
                raise GitHubError(f"Resposta paginada inesperada para {path}")
            result.extend(batch)
            if len(batch) < per_page:
                return result
            page += 1

    def graphql(self, query: str, variables: dict[str, Any]) -> dict[str, Any]:
        result = self.post("/graphql", {"query": query, "variables": variables}, expected=(200,))
        if result.get("errors"):
            raise GitHubError("GraphQL: " + json.dumps(result["errors"], ensure_ascii=False))
        return dict(result.get("data", {}))

    @staticmethod
    def quote(value: str) -> str:
        return urllib.parse.quote(value, safe="")
