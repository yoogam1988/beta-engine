Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

if (-not (Test-Path '.env')) {
  Copy-Item '.env.atomflow.example' '.env'
  Write-Host 'Generated .env from .env.atomflow.example. Update secrets before first run.'
}

docker compose `
  -f .\docker\docker-compose.yaml `
  -f .\docker-compose.atomflow-build.yaml `
  --env-file .\.env `
  build api worker worker_beat web

docker compose `
  -f .\docker\docker-compose.yaml `
  -f .\docker-compose.atomflow-build.yaml `
  --env-file .\.env `
  up -d
