#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================="
echo "  BetaAI Deployment"
echo "========================================="
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

echo "Docker version: $(docker --version)"
echo "Docker Compose version: $(docker compose version --short)"
echo ""

# Load Docker images if present
IMAGES_DIR="$SCRIPT_DIR/images"
if [ -d "$IMAGES_DIR" ]; then
    echo "Loading Docker images..."
    for tar_file in "$IMAGES_DIR"/*.tar; do
        [ -f "$tar_file" ] || continue
        echo "Loading $(basename "$tar_file")..."
        docker load -i "$tar_file"
    done
    echo "All images loaded successfully"
    echo ""
fi

# Create .env if not exists
if [ ! -f ".env" ]; then
    cp .env.betaai.example .env
    echo "IMPORTANT: Please edit .env to set your SECRET_KEY!"
    echo ""
fi

# Create middleware.env if not exists
if [ ! -f "docker/middleware.env" ]; then
    cp docker/middleware.env.example docker/middleware.env
fi

echo "Starting middleware services (PostgreSQL, Redis, Weaviate)..."
docker compose -f docker/docker-compose.middleware.yaml --env-file docker/middleware.env up -d --build
echo ""

echo "Waiting for middleware to be ready..."
sleep 15

echo "Building and starting BetaAI services..."
docker compose \
  -f ./docker/docker-compose.yaml \
  -f ./docker-compose.betaai-build.yaml \
  --env-file ./.env \
  up -d --build
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
