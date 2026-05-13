#!/bin/bash
set -e
cd "$(dirname "$0")/.."
docker compose -f docker/docker-compose.yaml up -d
echo "BetaAI is running at http://localhost"
