# Usa o terraform instalado; se não houver, roda via Docker.
TF ?= $(shell command -v terraform >/dev/null 2>&1 && echo terraform || echo docker compose run --rm terraform)

.PHONY: up down reset status help bootstrap init plan apply destroy fmt validate check aws exemplo

up:            ## Liga a AWS local
	docker compose up -d
	@until curl -sf http://localhost:4566/_ministack/health >/dev/null 2>&1 || curl -s http://localhost:4566 >/dev/null 2>&1; do sleep 1; done; echo "MiniStack pronto em http://localhost:4566"

down:          ## Desliga e apaga tudo (a "conta" volta a ficar vazia)
	docker compose down -v
	-@docker rm -f $$(docker ps -aq --filter "name=ministack-rds") >/dev/null 2>&1 || true

reset:         ## Começar do zero: desliga, limpa states locais e sobe de novo com o bucket do state
	$(MAKE) down
	rm -rf bootstrap/terraform.tfstate* bootstrap/.terraform environments/*/.terraform environments/*/*.tfplan \
	       global/*/.terraform global/*/*.tfplan exemplos/*/.terraform exemplos/*/terraform.tfstate*
	$(MAKE) up
	$(MAKE) bootstrap

status:        ## O MiniStack está no ar?
	@if curl -sf http://localhost:4566/_ministack/health >/dev/null 2>&1; then echo "MiniStack LIGADO em http://localhost:4566"; else echo "MiniStack DESLIGADO — rode: make up"; fi

help:          ## Lista os comandos
	@grep -E '^[a-z-]+:.*## ' Makefile | sed 's/:.*## /\t/'

bootstrap:     ## INF-001: cria o bucket do state remoto (state local, só uma vez)
	$(TF) -chdir=bootstrap init -input=false
	$(TF) -chdir=bootstrap apply -auto-approve

init:
	$(TF) -chdir=environments/development init -input=false -reconfigure

plan:
	$(TF) -chdir=environments/development plan -out=dev.tfplan

apply:
	$(TF) -chdir=environments/development apply dev.tfplan

destroy:
	$(TF) -chdir=environments/development destroy -auto-approve

fmt:
	$(TF) fmt -recursive

check:         ## Mesmo gate do repo real: fmt + validate
	$(TF) fmt -check -recursive
	$(TF) -chdir=environments/development init -backend=false -input=false >/dev/null
	$(TF) -chdir=environments/development validate
	$(TF) -chdir=global/github-oidc init -backend=false -input=false >/dev/null
	$(TF) -chdir=global/github-oidc validate

aws:           ## Ex.: make aws CMD="s3 ls"
	docker compose run --rm aws $(CMD)

oidc-init:     ## INF-004: root global de IAM (aplicado por humano, 1x por conta)
	$(TF) -chdir=global/github-oidc init -input=false -reconfigure

oidc-plan:
	$(TF) -chdir=global/github-oidc plan -out=oidc.tfplan

oidc-apply:
	$(TF) -chdir=global/github-oidc apply oidc.tfplan

exemplo:       ## Exemplo 01: make exemplo NOME=teste (cria um bucket com um arquivo)
	$(TF) -chdir=exemplos/01-primeiro-bucket init -input=false
	$(TF) -chdir=exemplos/01-primeiro-bucket apply -auto-approve -var 'seu_nome=$(or $(NOME),exemplo)'

exemplo-destroy:
	$(TF) -chdir=exemplos/01-primeiro-bucket destroy -auto-approve -var 'seu_nome=$(or $(NOME),exemplo)'
