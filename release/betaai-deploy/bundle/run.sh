#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [[ ! -f ".env" ]]; then
  cp .env.atomflow.example .env
  echo "Generated .env from .env.atomflow.example. Update secrets before first run."
fi

docker compose \
  -f ./docker/docker-compose.yaml \
  -f ./docker-compose.atomflow-build.yaml \
  --env-file ./.env \
  build api worker worker_beat web

docker compose \
  -f ./docker/docker-compose.yaml \
  -f ./docker-compose.atomflow-build.yaml \
  --env-file ./.env \
  up -d
