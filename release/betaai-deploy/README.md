# BetaAI (贝塔引擎) 部署包

此部署包用于在企业服务器上部署 BetaAI 平台。

## 部署步骤

### Windows 服务器

1. 解压部署包
2. 编辑 `.env` 文件，设置 `SECRET_KEY`（或运行脚本自动生成）
3. 运行部署脚本：

```powershell
powershell -ExecutionPolicy Bypass -File .\run.ps1
```

### Linux 服务器

1. 解压部署包
2. 编辑 `.env` 文件，设置 `SECRET_KEY`

```bash
chmod +x run.sh
./run.sh
```

## 访问地址

部署完成后访问：`http://<服务器IP>`

## 常见问题

### 1. Docker 未安装
请先安装 Docker 和 Docker Compose v2

### 2. 端口被占用
编辑 `docker/.env` 文件，修改 `EXPOSE_NGINX_PORT` 和 `EXPOSE_NGINX_SSL_PORT`

### 3. 内存不足
调整 `docker/.env` 中的 `SERVER_WORKER_AMOUNT` 和 `CELERY_WORKER_AMOUNT`

### 4. 镜像加载失败
如果镜像 tar 文件加载失败，请检查 Docker 版本是否兼容

## 运维命令

```bash
# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f

# 重启服务
docker compose restart

# 停止服务
docker compose down
```

## 联系支持

如有问题，请联系：admin@gpnjvc.com
