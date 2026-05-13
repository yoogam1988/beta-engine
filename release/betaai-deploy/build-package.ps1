Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Resolve-Path (Join-Path $scriptDir '..\..')
$releaseDir = Resolve-Path $scriptDir
$bundleDir = Join-Path $releaseDir 'bundle'
$dateTag = Get-Date -Format 'yyyyMMdd'
$zipPath = Join-Path $releaseDir ("betaai-deploy-bundle-{0}.zip" -f $dateTag)

Write-Host '[1/5] Prepare bundle directory'
if (Test-Path $bundleDir) {
  Remove-Item -LiteralPath $bundleDir -Recurse -Force
}
if (Test-Path $zipPath) {
  Remove-Item -LiteralPath $zipPath -Force
}
New-Item -ItemType Directory -Path $bundleDir -Force | Out-Null

Write-Host '[2/5] Copy deployment files'
Copy-Item -Recurse -Force (Join-Path $rootDir 'docker') (Join-Path $bundleDir 'docker')
Copy-Item -Recurse -Force (Join-Path $rootDir 'api') (Join-Path $bundleDir 'api')
Copy-Item -Recurse -Force (Join-Path $rootDir 'web') (Join-Path $bundleDir 'web')
Copy-Item -Force (Join-Path $releaseDir 'docker-compose.betaai-images.yaml') $bundleDir
Copy-Item -Force (Join-Path $releaseDir 'docker-compose.betaai-build.yaml') $bundleDir
Copy-Item -Force (Join-Path $releaseDir '.env.betaai.example') $bundleDir
Copy-Item -Force (Join-Path $releaseDir 'run.ps1') $bundleDir
Copy-Item -Force (Join-Path $releaseDir 'run.sh') $bundleDir
Copy-Item -Force (Join-Path $releaseDir 'README.md') $bundleDir

Write-Host '[3/5] Remove local-only folders'
Get-ChildItem -Path $bundleDir -Recurse -Directory -Force |
  Where-Object { $_.Name -in @('.git', 'node_modules', '.next', '__pycache__', '.venv') } |
  ForEach-Object { Remove-Item -LiteralPath $_.FullName -Recurse -Force }

Write-Host '[4/5] Build and save Docker images'
Set-Location $rootDir

# Check if Docker is available
try {
  docker version | Out-Null
  Write-Host 'Docker detected, building images...'

  # Build images
  Write-Host 'Building betaai-api image...'
  docker build -t betaai/betaai-api:1.13.3 -f api/Dockerfile . --build-arg BETA_API_IMAGE_NAME=betaai/betaai-api

  Write-Host 'Building betaai-web image...'
  docker build -t betaai/betaai-web:1.13.3 -f web/Dockerfile .

  # Save images to tar files
  $imagesDir = Join-Path $bundleDir 'images'
  New-Item -ItemType Directory -Path $imagesDir -Force | Out-Null

  Write-Host 'Saving betaai-api image...'
  docker save betaai/betaai-api:1.13.3 -o (Join-Path $imagesDir 'betaai-api.tar')

  Write-Host 'Saving betaai-web image...'
  docker save betaai/betaai-web:1.13.3 -o (Join-Path $imagesDir 'betaai-web.tar')

  Write-Host 'Docker images saved successfully'
} catch {
  Write-Host 'Warning: Docker not available or build failed. Images will not be included.'
  Write-Host 'You will need to build images manually on the target server.'
}

Set-Location $releaseDir

Write-Host '[5/5] Create deployment zip'
Compress-Archive -Path (Join-Path $bundleDir '*') -DestinationPath $zipPath -CompressionLevel Optimal

Write-Host '[Done] Bundle created successfully'
Write-Host "Bundle: $zipPath"
Write-Host ''
Write-Host 'To deploy on target server:'
Write-Host '1. Unzip the bundle'
Write-Host '2. Edit .env (or let script create from .env.betaai.example)'
Write-Host '3. Run: powershell -ExecutionPolicy Bypass -File .\run.ps1'
