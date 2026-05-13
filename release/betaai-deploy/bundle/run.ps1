# BetaAI Deployment Script for Windows

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host '========================================='
Write-Host '  BetaAI Deployment'
Write-Host '========================================='
Write-Host ''

# Check Docker
try {
  $dockerVersion = docker --version 2>&1
  Write-Host "Docker version: $dockerVersion"
} catch {
  Write-Host 'Error: Docker is not installed. Please install Docker Desktop first.'
  exit 1
}

try {
  $composeVersion = docker compose version --short 2>&1
  Write-Host "Docker Compose version: $composeVersion"
} catch {
  Write-Host 'Error: Docker Compose is not installed.'
  exit 1
}
Write-Host ''

# Load Docker images if present
$imagesDir = Join-Path $scriptDir 'images'
if (Test-Path $imagesDir) {
  Write-Host 'Loading Docker images...'
  Get-ChildItem -Path $imagesDir -Filter '*.tar' | ForEach-Object {
    Write-Host "Loading $($_.Name)..."
    docker load -i $_.FullName
  }
  Write-Host 'All images loaded successfully'
  Write-Host ''
}

# Create .env if not exists
if (-not (Test-Path '.env')) {
  Write-Host 'Creating .env from .env.betaai.example...'
  Copy-Item '.env.betaai.example' '.env'
  Write-Host 'IMPORTANT: Please edit .env to set your SECRET_KEY!'
  Write-Host ''
}

# Create middleware.env if not exists
if (-not (Test-Path 'docker\middleware.env')) {
  Write-Host 'Creating docker/middleware.env...'
  Copy-Item 'docker\middleware.env.example' 'docker\middleware.env'
}

# Start middleware services
Write-Host 'Starting middleware services (PostgreSQL, Redis, Weaviate)...'
docker compose -f docker\docker-compose.middleware.yaml --env-file docker\middleware.env up -d --build
Write-Host ''

Write-Host 'Waiting for middleware to be ready...'
Start-Sleep -Seconds 15

# Start BetaAI services
Write-Host 'Building and starting BetaAI services...'
docker compose -f docker\docker-compose.yaml -f docker-compose.betaai-build.yaml --env-file .\.env up -d --build
Write-Host ''

Write-Host '========================================='
Write-Host '  Deployment Complete!'
Write-Host '========================================='
Write-Host ''
Write-Host 'Access BetaAI at: http://localhost'
Write-Host ''
Write-Host 'To view logs: docker compose logs -f'
Write-Host 'To stop: docker compose down'
Write-Host ''
