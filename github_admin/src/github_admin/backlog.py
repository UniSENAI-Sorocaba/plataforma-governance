from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path


ROW = re.compile(r"^\|\s*((?:PG|BE|FE|DB|INF|QA)-\d{3})\s*\|(.+)\|$")


@dataclass(frozen=True)
class BacklogItem:
    work_id: str
    priority_sprint: str
    points: str
    assignee: str
    reviewer: str
    title: str
    dependencies: str

    @property
    def issue_title(self) -> str:
        return f"[{self.work_id}] {self.title}"

    @property
    def body(self) -> str:
        return (
            f"## Metadados\n\n"
            f"- Work ID: `{self.work_id}`\n"
            f"- Prioridade/Sprint: `{self.priority_sprint}`\n"
            f"- Estimativa: `{self.points} SP`\n"
            f"- Responsável inicial: {self.assignee}\n"
            f"- Revisor: {self.reviewer}\n"
            f"- Dependências: {self.dependencies}\n\n"
            f"## Critério de aceite\n\n- [ ] {self.title}\n\n"
            "Importado da baseline Markdown; o GitHub Project é a fonte do estado.\n"
        )


def parse_backlog(path: str | Path) -> list[BacklogItem]:
    items: list[BacklogItem] = []
    for line in Path(path).read_text(encoding="utf-8-sig").splitlines():
        match = ROW.match(line)
        if not match:
            continue
        cells = [match.group(1), *[cell.strip() for cell in match.group(2).split("|")]]
        if len(cells) != 7:
            raise ValueError(f"Linha inválida em {path}: {line}")
        items.append(BacklogItem(*cells))
    return items
