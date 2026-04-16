#!/bin/bash

# Setup script for Collection Management Microservice
# This script automates the setup process

set -e

echo "=========================================="
echo "Collection Management Microservice Setup"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: docker-compose is not installed${NC}"
    echo "Please install docker-compose first"
    exit 1
fi

# Check if psql is installed
if ! command -v psql &> /dev/null; then
    echo -e "${YELLOW}Warning: psql is not installed${NC}"
    echo "Installing PostgreSQL client..."
    sudo apt-get update && sudo apt-get install -y postgresql-client
fi

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo -e "${RED}Error: Go is not installed${NC}"
    echo "Please install Go 1.21+ first"
    exit 1
fi

echo "Step 1: Starting PostgreSQL with Docker Compose..."
docker-compose up -d

echo ""
echo "Step 2: Waiting for PostgreSQL to be ready..."
sleep 5

# Check if PostgreSQL is ready
until docker-compose exec -T postgres pg_isready -U collectoria &> /dev/null; do
    echo "Waiting for PostgreSQL..."
    sleep 2
done

echo -e "${GREEN}PostgreSQL is ready!${NC}"
echo ""

echo "Step 3: Applying database migrations..."
PGPASSWORD=collectoria psql -h localhost -U collectoria -d collection_management -f migrations/001_create_collections_schema.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Migrations applied successfully!${NC}"
else
    echo -e "${RED}Error applying migrations${NC}"
    exit 1
fi

echo ""
echo "Step 4: Loading seed data (40 MECCG mock cards)..."
PGPASSWORD=collectoria psql -h localhost -U collectoria -d collection_management -f testdata/seed_meccg_mock.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Seed data loaded successfully!${NC}"
else
    echo -e "${RED}Error loading seed data${NC}"
    exit 1
fi

echo ""
echo "Step 5: Installing Go dependencies..."
go mod download

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Dependencies installed!${NC}"
else
    echo -e "${RED}Error installing dependencies${NC}"
    exit 1
fi

echo ""
echo "Step 6: Running tests..."
go test ./... -cover

if [ $? -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
else
    echo -e "${RED}Some tests failed${NC}"
    exit 1
fi

echo ""
echo "=========================================="
echo -e "${GREEN}Setup completed successfully!${NC}"
echo "=========================================="
echo ""
echo "To start the service, run:"
echo "  go run cmd/api/main.go"
echo ""
echo "Or build and run:"
echo "  go build -o main ./cmd/api"
echo "  ./main"
echo ""
echo "The API will be available at: http://localhost:8080"
echo ""
echo "Test the endpoint:"
echo "  curl http://localhost:8080/api/v1/collections/summary"
echo ""
echo "Expected result: 24 cards owned / 40 total = 60% completion"
echo ""
