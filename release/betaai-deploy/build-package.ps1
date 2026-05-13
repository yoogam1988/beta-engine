Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Resolve-Path (Join-Path $scriptDir '..\..')
$releaseDir = Resolve-Path $scriptDir
$bundleDir = Join-Path $releaseDir 'bundle'
$dateTag = Get-Date -Format 'yyyyMMdd'
$zipPath = Join-Path $releaseDir ("atomflow-deploy-bundle-{0}.zip" -f $dateTag)

Write-Host '[1/4] Prepare bundle directory'
if (Test-Path $bundleDir) {
  Remove-Item -LiteralPath $bundleDir -Recurse -Force
}
if (Test-Path $zipPath) {
  Remove-Item -LiteralPath $zipPath -Force
}
New-Item -ItemType Directory -Path $bundleDir -Force | Out-Null

Copy-Item -Recurse -Force (Join-Path $rootDir 'docker') (Join-Path $bundleDir 'docker')
Copy-Item -Recurse -Force (Join-Path $rootDir 'api') (Join-Path $bundleDir 'api')
Copy-Item -Recurse -Force (Join-Path $rootDir 'web') (Join-Path $bundleDir 'web')
Copy-Item -Force (Join-Path $releaseDir 'docker-compose.atomflow-images.yaml') $bundleDir
Copy-Item -Force (Join-Path $releaseDir 'docker-compose.atomflow-build.yaml') $bundleDir
Copy-Item -Force (Join-Path $releaseDir '.env.atomflow.example') $bundleDir
Copy-Item -Force (Join-Path $releaseDir 'run.ps1') $bundleDir
Copy-Item -Force (Join-Path $releaseDir 'run.sh') $bundleDir
Copy-Item -Force (Join-Path $releaseDir 'README.md') $bundleDir

Write-Host '[2/4] Remove local-only folders'
Get-ChildItem -Path $bundleDir -Recurse -Directory -Force |
  Where-Object { $_.Name -in @('.git', 'node_modules', '.next', '__pycache__', '.venv') } |
  ForEach-Object { Remove-Item -LiteralPath $_.FullName -Recurse -Force }

Write-Host '[3/4] Create deployment zip'
Compress-Archive -Path (Join-Path $bundleDir '*') -DestinationPath $zipPath -CompressionLevel Optimal

Write-Host '[4/4] Done'
Write-Host ("Bundle: {0}" -f $zipPath)
