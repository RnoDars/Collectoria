.PHONY: help test-local test-backend test-frontend cleanup monitor setup

help: ## Afficher cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

test-local: ## Tester tous les services localement
	@./scripts/test-local.sh all

test-backend: ## Tester le backend collection-management
	@./scripts/test-local.sh collection-management

test-frontend: ## Lancer le frontend en mode dev
	@cd frontend && npm run dev

cleanup: ## Nettoyer l'environnement local (containers + processus)
	@./scripts/cleanup-local.sh

monitor: ## Afficher le statut des services locaux
	@./scripts/monitor-local.sh

setup: ## Rendre les scripts exécutables
	@chmod +x scripts/*.sh
	@echo "Setup terminé — scripts prêts dans scripts/"
