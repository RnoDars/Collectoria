.PHONY: help setup build run test test-coverage clean docker-up docker-down migrate seed restart

# Default target
help:
	@echo "Collection Management Microservice - Available commands:"
	@echo ""
	@echo "  make setup          - Full setup (PostgreSQL + migrations + seed)"
	@echo "  make build          - Build the application"
	@echo "  make run            - Run the application"
	@echo "  make test           - Run all tests"
	@echo "  make test-coverage  - Run tests with coverage report"
	@echo "  make docker-up      - Start PostgreSQL with docker-compose"
	@echo "  make docker-down    - Stop PostgreSQL"
	@echo "  make migrate        - Apply database migrations"
	@echo "  make seed           - Load seed data (40 MECCG cards)"
	@echo "  make restart        - Restart local environment (clean + restart backend + frontend)"
	@echo "  make clean          - Clean build artifacts"
	@echo ""

# Full setup
setup:
	@./setup.sh

# Build the application
build:
	@echo "Building application..."
	@go build -o main ./cmd/api
	@echo "Build complete: ./main"

# Run the application
run:
	@echo "Starting Collection Management Service..."
	@go run cmd/api/main.go

# Run all tests
test:
	@echo "Running tests..."
	@go test ./... -v

# Run tests with coverage
test-coverage:
	@echo "Running tests with coverage..."
	@go test ./... -cover -coverprofile=coverage.out
	@go tool cover -html=coverage.out -o coverage.html
	@echo "Coverage report generated: coverage.html"

# Start PostgreSQL
docker-up:
	@echo "Starting PostgreSQL..."
	@docker-compose up -d
	@echo "Waiting for PostgreSQL to be ready..."
	@sleep 5
	@echo "PostgreSQL is ready!"

# Stop PostgreSQL
docker-down:
	@echo "Stopping PostgreSQL..."
	@docker-compose down

# Apply migrations
migrate:
	@echo "Applying migrations..."
	@PGPASSWORD=collectoria psql -h localhost -U collectoria -d collection_management -f migrations/001_create_collections_schema.sql
	@echo "Migrations applied!"

# Load seed data
seed:
	@echo "Loading seed data..."
	@PGPASSWORD=collectoria psql -h localhost -U collectoria -d collection_management -f testdata/seed_meccg_mock.sql
	@echo "Seed data loaded! (40 MECCG cards with 60% completion)"

# Clean build artifacts
clean:
	@echo "Cleaning..."
	@rm -f main
	@rm -f coverage.out coverage.html
	@echo "Clean complete!"

# Quick start (for development)
dev: docker-up migrate seed
	@echo ""
	@echo "Development environment ready!"
	@echo "Run 'make run' to start the service"

# Restart local environment (clean + restart)
restart:
	@./scripts/restart-local.sh
