#!/bin/bash
set -e

echo "========================================="
echo "  BetaAI One-Click Deploy"
echo "========================================="
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

# Check Docker Compose
if ! docker compose version &> /dev/null; then
    echo "Error: Docker Compose is not installed."
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
    echo "IMPORTANT: Please edit docker/.env to set your SECRET_KEY!"
    echo ""
fi

if [ ! -f middleware.env ]; then
    echo "Creating middleware.env from middleware.env.example..."
    cp middleware.env.example middleware.env
fi

echo "Building and starting middleware services..."
docker compose -f docker-compose.middleware.yaml --env-file middleware.env up -d --build
echo ""

echo "Waiting for middleware to be ready..."
sleep 15

echo "Building and starting BetaAI services..."
cd ..
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
