# BetaAI One-Click Deploy Script for Windows

Write-Host "========================================="
Write-Host "  BetaAI One-Click Deploy"
Write-Host "========================================="
Write-Host ""

# Check Docker
try {
    $dockerVersion = docker --version 2>&1
    Write-Host "Docker version: $dockerVersion"
} catch {
    Write-Host "Error: Docker is not installed. Please install Docker Desktop first."
    exit 1
}

# Check Docker Compose
try {
    $composeVersion = docker compose version --short 2>&1
    Write-Host "Docker Compose version: $composeVersion"
} catch {
    Write-Host "Error: Docker Compose is not installed."
    exit 1
}
Write-Host ""

# Navigate to docker directory
Set-Location -Path "$PSScriptRoot\docker"

# Copy .env files if not exists
if (-not (Test-Path ".env")) {
    Write-Host "Creating .env from .env.example..."
    Copy-Item ".env.example" ".env"
    Write-Host "IMPORTANT: Please edit docker\.env to set your SECRET_KEY!"
    Write-Host ""
}

if (-not (Test-Path "middleware.env")) {
    Write-Host "Creating middleware.env from middleware.env.example..."
    Copy-Item "middleware.env.example" "middleware.env"
}

Write-Host "Building and starting middleware services..."
docker compose -f docker-compose.middleware.yaml --env-file middleware.env up -d --build
Write-Host ""

Write-Host "Waiting for middleware to be ready..."
Start-Sleep -Seconds 15

Write-Host "Building and starting BetaAI services..."
Set-Location -Path "$PSScriptRoot"
docker compose up -d --build
Write-Host ""

Write-Host "========================================="
Write-Host "  Deployment Complete!"
Write-Host "========================================="
Write-Host ""
Write-Host "Access BetaAI at: http://localhost"
Write-Host ""
Write-Host "To view logs: docker compose logs -f"
Write-Host "To stop: docker compose down"
Write-Host ""
