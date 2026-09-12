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
        guidance = {
            "PG": "Produzir ou atualizar o artefato de governança/produto, registrar decisões e garantir rastreabilidade com requisitos e equipes impactadas.",
            "BE": "Implementar no backend Spring Boot, cobrindo regras de domínio, validações, erros, observabilidade, segurança e testes automatizados aplicáveis.",
            "FE": "Implementar no frontend Next.js com TypeScript, cobrindo estados de interface, acessibilidade, responsividade, integração com contratos e testes aplicáveis.",
            "DB": "Implementar e versionar a alteração de dados, incluindo migration, integridade, índices, segurança, validação de upgrade e estratégia segura de rollback.",
            "INF": "Implementar como infraestrutura ou automação versionada, com privilégio mínimo, observabilidade, validação em ambiente seguro e procedimento de rollback.",
            "QA": "Planejar e executar a validação, automatizar quando aplicável e publicar evidências reproduzíveis, defeitos encontrados e parecer de qualidade ou segurança.",
        }[self.work_id.split("-", 1)[0]]
        return (
            f"## Objetivo\n\n{self.title}.\n\n"
            f"## Escopo esperado\n\n{guidance}\n\n"
            "## Atividades mínimas\n\n"
            "- [ ] Confirmar dependências, contrato/SPEC e critérios antes de iniciar.\n"
            "- [ ] Implementar a entrega no repositório responsável sem ampliar o escopo silenciosamente.\n"
            "- [ ] Criar ou atualizar testes, validações e evidências proporcionais ao risco.\n"
            "- [ ] Atualizar documentação, contratos e rastreabilidade afetados.\n"
            "- [ ] Vincular o PR com `Closes #<issue>` e registrar limitações ou follow-ups.\n\n"
            "## Critérios de aceite\n\n"
            f"- [ ] {self.title}\n"
            "- [ ] Evidências anexadas ou vinculadas e revisão concluída pelo responsável indicado.\n\n"
            f"## Metadados\n\n"
            f"- Work ID: `{self.work_id}`\n"
            f"- Prioridade/Sprint: `{self.priority_sprint}`\n"
            f"- Estimativa: `{self.points} SP`\n"
            f"- Responsável inicial: {self.assignee}\n"
            f"- Revisor: {self.reviewer}\n"
            f"- Dependências: {self.dependencies}\n\n"
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
