#!/bin/bash
set -e

echo "========================================="
echo "  BetaAI (贝塔引擎) One-Click Deploy"
echo "========================================="
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

# Check Docker Compose
if ! docker compose version &> /dev/null; then
    echo "Error: Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "Docker version: $(docker --version)"
echo "Docker Compose version: $(docker compose version --short)"
echo ""

# Copy .env files if not exists
cd "$(dirname "$0")/docker"

if [ ! -f .env ]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo "IMPORTANT: Please edit docker/.env to set your SECRET_KEY and other passwords!"
    echo ""
fi

if [ ! -f middleware.env ]; then
    echo "Creating middleware.env from middleware.env.example..."
    cp middleware.env.example middleware.env
fi

echo "Starting middleware services (PostgreSQL, Redis, Weaviate)..."
docker compose -f docker-compose.middleware.yaml --env-file middleware.env up -d
echo ""

echo "Waiting for middleware to be ready..."
sleep 10

echo "Starting BetaAI services..."
docker compose up -d --build
echo ""

echo "========================================="
echo "  Deployment Complete!"
echo "========================================="
echo ""
echo "Access BetaAI at: http://localhost"
echo ""
echo "To view logs: docker compose logs -f"
echo "To stop: docker compose down"
echo ""
