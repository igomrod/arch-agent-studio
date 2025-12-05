.PHONY: up down logs sync-rules init-project switch-project

# Default project path
PROJECT_PATH ?= ./projects/example-project

# Read current project if file exists
ifneq (,$(wildcard .current_project))
    PROJECT_PATH := $(shell cat .current_project)
endif

sync-rules:
	mkdir -p .agent/rules
	cp AI_GUIDELINES.md .cursorrules
	cp AI_GUIDELINES.md .windsurfrules
	cp AI_GUIDELINES.md .github/copilot-instructions.md
	cp AI_GUIDELINES.md .agent/rules/AI_GUIDELINES.md
	@echo "AI Guidelines synchronized."

up:
	@echo "Starting Structurizr for project: $(PROJECT_PATH)"
	PROJECT_PATH=$(PROJECT_PATH) docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

init-project:
ifndef NAME
	$(error NAME is undefined. Usage: make init-project NAME=my-project)
endif
	mkdir -p projects/$(NAME)
	cp projects/example-project/workspace.dsl projects/$(NAME)/workspace.dsl
	cp -r projects/example-project/docs projects/$(NAME)/docs
	cp -r projects/example-project/adrs projects/$(NAME)/adrs
	@echo "./projects/$(NAME)" > .current_project
	@echo "Initialized project: $(NAME)"
	@echo "Switched to project: $(NAME)"

switch-project:
ifndef NAME
	$(error NAME is undefined. Usage: make switch-project NAME=my-project)
endif
	@if [ ! -d "projects/$(NAME)" ]; then \
		echo "Project 'projects/$(NAME)' does not exist."; \
		exit 1; \
	fi
	@echo "./projects/$(NAME)" > .current_project
	@echo "Switched to project: $(NAME)"
	@$(MAKE) down
	@$(MAKE) up

export-diagrams:
	@echo "Exporting diagrams for project: $(PROJECT_PATH)"
	@mkdir -p $(PROJECT_PATH)/export
	@docker run --rm \
		--network arch-agent-studio_default \
		-v $(CURDIR)/scripts:/scripts \
		-v $(CURDIR)/$(PROJECT_PATH)/export:/output \
		-e STRUCTURIZR_URL="http://structurizr-lite:8080" \
		-e OUTPUT_DIR="/output" \
		-e NODE_PATH="/home/pptruser/node_modules" \
		ghcr.io/puppeteer/puppeteer:latest \
		node /scripts/export-diagrams.js
