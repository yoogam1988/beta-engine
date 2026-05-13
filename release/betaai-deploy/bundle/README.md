# AtomFlow Internal Deployment Bundle

This bundle deploys your rebranded internal platform by building images from bundled `api/` and `web/` source code.

## 1. Build the deployment zip (on build machine)

```powershell
cd release/atomflow-deploy
powershell -ExecutionPolicy Bypass -File .\build-package.ps1
```

Output zip:

`release/atomflow-deploy/atomflow-deploy-bundle-YYYYMMDD.zip`

## 2. Deploy on target server

1. Unzip the bundle.
2. Edit `.env` (or let script create from `.env.atomflow.example` first).
3. Start services (script runs image build first, then `up -d`):

PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\run.ps1
```

Bash:

```bash
chmod +x ./run.sh
./run.sh
```

## 3. Verify

```bash
docker compose -f ./docker/docker-compose.yaml -f ./docker-compose.atomflow-build.yaml --env-file ./.env ps
```

Access URL defaults to:

- Console/Web: `http://<server-ip>`
- API: `http://<server-ip>/console/api`
