SHELL := bash
CURRENT_DIR = $(shell pwd)
ENV_FILE := $(CURRENT_DIR)/.envrc
POETRY_COMMAND := $(shell which poetry)

create-venv:
	@$(POETRY_COMMAND) install

install-roles-and-collections:
	@$(POETRY_COMMAND) run ansible-galaxy role install -r requirements.yml
	@$(POETRY_COMMAND) run ansible-galaxy collection install -r requirements.yml

shell-env:
	@$(POETRY_COMMAND) shell

lint:	
	@ansible-lint --force-color

clean-up:
	@$(POETRY_COMMAND) run ansible-playbook cleanup.yml  $(EXTRA_ARGS)

create-kube-clusters:
	@direnv allow $(ENV_FILE)
	@$(POETRY_COMMAND) run ansible-playbook clusters.yml $(EXTRA_ARGS)
	@direnv allow $(ENV_FILE)

setup:
	@direnv allow $(ENV_FILE)
	@$(POETRY_COMMAND) run ansible-playbook playbook.yml $(EXTRA_ARGS)
	@direnv allow $(ENV_FILE)

deploy-argocd-apps:
	@direnv allow $(ENV_FILE)
	@$(POETRY_COMMAND) run ansible-playbook gitops.yml $(EXTRA_ARGS)
	@direnv allow $(ENV_FILE)

deploy-argocd:
	@direnv allow $(ENV_FILE)
	@$(POETRY_COMMAND) run ansible-playbook argocd.yml $(EXTRA_ARGS)
	@direnv allow $(ENV_FILE)

deploy-gloo:
	@direnv allow $(ENV_FILE)
	@$(POETRY_COMMAND) run ansible-playbook gloo.yml $(EXTRA_ARGS)
	@direnv allow $(ENV_FILE)

deploy-gitea:
	@direnv allow $(ENV_FILE)
	@$(POETRY_COMMAND) run ansible-playbook gitea.yml --tags="gitea"
	@direnv allow $(ENV_FILE)

expose-gitea:
	@direnv allow $(ENV_FILE)
	@$(POETRY_COMMAND) run ansible-playbook gitea.yml --tags="gitea-gloo"
	@direnv allow $(ENV_FILE)

# deploy-istio:
# 	@direnv allow $(ENV_FILE)
# 	@$(POETRY_COMMAND) run ansible-playbook istio.yml $(EXTRA_ARGS)
# 	@direnv allow $(ENV_FILE)

tools:
	@direnv allow $(ENV_FILE)
	@$(POETRY_COMMAND) run ansible-playbook tools.yml $(EXTRA_ARGS)
	@direnv allow $(ENV_FILE)

test:
	@direnv allow $(ENV_FILE)
	@$(POETRY_COMMAND) run ansible-playbook test.yml $(EXTRA_ARGS)
	@direnv allow $(ENV_FILE)

