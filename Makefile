.PHONY: up down logs sync-rules

sync-rules:
	mkdir -p .agent/rules
	cp AI_GUIDELINES.md .cursorrules
	cp AI_GUIDELINES.md .windsurfrules
	cp AI_GUIDELINES.md .github/copilot-instructions.md
	cp AI_GUIDELINES.md .agent/rules/AI_GUIDELINES.md
	@echo "AI Guidelines synchronized."

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f
