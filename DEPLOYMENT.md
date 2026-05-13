# 贝塔引擎 (BetaAI) 部署文档

## 目录

1. [系统要求](#1-系统要求)
2. [快速开始](#2-快速开始)
3. [一键部署](#3-一键部署)
4. [手动部署](#4-手动部署)
5. [配置文件说明](#5-配置文件说明)
6. [服务架构](#6-服务架构)
7. [常见问题](#7-常见问题)
8. [运维命令](#8-运维命令)

---

## 1. 系统要求

### 最低配置
- CPU >= 2 Core
- RAM >= 4 GiB
- 磁盘空间 >= 20 GB

### 推荐配置
- CPU >= 4 Core
- RAM >= 8 GiB
- 磁盘空间 >= 50 GB

### 软件要求
- Docker 20.10+
- Docker Compose v2+

---

## 2. 快速开始

### Linux/Mac

```bash
# 1. 克隆项目
git clone <repository-url>
cd dify-main

# 2. 运行一键部署脚本
chmod +x deploy.sh
./deploy.sh
```

### Windows

```powershell
# 1. 克隆项目
git clone <repository-url>
cd dify-main

# 2. 运行一键部署脚本
.\deploy.ps1
```

部署完成后访问：http://localhost

---

## 3. 一键部署

### 3.1 部署脚本说明

项目根目录提供两个一键部署脚本：

| 脚本 | 平台 | 说明 |
|------|------|------|
| `deploy.sh` | Linux/Mac | Bash 一键部署 |
| `deploy.ps1` | Windows | PowerShell 一键部署 |

### 3.2 部署流程

一键部署脚本自动完成以下步骤：

1. **环境检查** — 验证 Docker 和 Docker Compose 是否安装
2. **配置初始化** — 从 `.env.example` 创建 `.env` 配置文件
3. **中间件启动** — 启动 PostgreSQL、Redis、Weaviate 等中间件服务
4. **应用构建** — 构建 BetaAI 前后端 Docker 镜像
5. **服务启动** — 启动所有 BetaAI 服务

### 3.3 部署后检查

```bash
# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f

# 检查服务健康
docker compose ps --format "table {{.Name}}\t{{.Status}}"
```

---

## 4. 手动部署

### 4.1 准备配置文件

```bash
cd docker

# 复制环境配置
cp .env.example .env
cp middleware.env.example middleware.env
```

### 4.2 编辑配置

编辑 `docker/.env` 文件，设置以下关键配置：

```bash
# 密钥（必须修改）
SECRET_KEY=<your-strong-secret-key>

# 数据库密码（建议修改）
DB_PASSWORD=BetaAI@2026Secure!xK9mP2
REDIS_PASSWORD=BetaAI@2026Secure!rT7nQ5

# 数据库名
DB_DATABASE=betaai

# 邮件配置
MAIL_DEFAULT_SEND_FROM=admin@gpnjvc.com
```

### 4.3 启动中间件

```bash
cd docker

# 启动中间件服务（PostgreSQL + Redis + Weaviate）
docker compose -f docker-compose.middleware.yaml --env-file middleware.env up -d

# 等待中间件就绪
sleep 10
```

### 4.4 启动应用

```bash
# 构建并启动 BetaAI 服务
cd ..
docker compose up -d --build
```

### 4.5 快速启动（已配置好 .env）

```bash
./docker/docker-start.sh
```

---

## 5. 配置文件说明

### 5.1 docker/.env.example

主配置文件，包含以下关键配置项：

| 配置项 | 说明 | 默认值 |
|--------|------|--------|
| `SECRET_KEY` | 应用密钥 | 需手动设置 |
| `DB_TYPE` | 数据库类型 | postgresql |
| `DB_HOST` | 数据库主机 | db_postgres |
| `DB_PORT` | 数据库端口 | 5432 |
| `DB_USERNAME` | 数据库用户 | postgres |
| `DB_PASSWORD` | 数据库密码 | BetaAI@2026Secure!xK9mP2 |
| `DB_DATABASE` | 数据库名 | betaai |
| `REDIS_HOST` | Redis 主机 | redis |
| `REDIS_PORT` | Redis 端口 | 6379 |
| `REDIS_PASSWORD` | Redis 密码 | BetaAI@2026Secure!rT7nQ5 |
| `VECTOR_STORE` | 向量数据库类型 | weaviate |
| `NGINX_PORT` | Nginx HTTP 端口 | 80 |
| `NGINX_SSL_PORT` | Nginx HTTPS 端口 | 443 |

### 5.2 docker/middleware.env.example

中间件配置文件，包含数据库、Redis、Weaviate 等中间件的连接配置。

### 5.3 docker/docker-compose.yaml

主 Docker Compose 文件，定义以下服务：

| 服务 | 镜像 | 说明 |
|------|------|------|
| `api` | betaai/betaai-api | API 服务 |
| `worker` | betaai/betaai-api | 后台任务 Worker |
| `worker_beat` | betaai/betaai-api | 定时任务调度器 |
| `web` | betaai/betaai-web | 前端 Web 服务 |
| `nginx` | nginx | 反向代理 |
| `redis` | redis:6-alpine | 缓存服务 |
| `sandbox` | betaai/betaai-sandbox | 代码执行沙箱 |
| `plugin_daemon` | betaai/betaai-plugin-daemon | 插件守护进程 |
| `ssrf_proxy` | ubuntu/squid | SSRF 代理 |
| `db_postgres` | postgres:15-alpine | PostgreSQL 数据库 |
| `weaviate` | semitechnologies/weaviate | 向量数据库 |

---

## 6. 服务架构

### 6.1 服务依赖关系

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Nginx     │────▶│    Web      │     │    API      │
│   (80/443)  │     │  (Next.js)  │     │  (Flask)    │
└─────────────┘     └──────┬──────┘     └──────┬──────┘
                           │                   │
                    ┌─────────────────────────┴──────┐
                    │                                 │
              ┌─────▼─────┐                    ┌─────▼─────┐
              │   Redis   │                    │ PostgreSQL│
              │  (Cache)  │                    │   (DB)    │
              └───────────┘                    └───────────┘
                                                        │
                                                  ┌─────▼─────
                                                  │  Weaviate │
                                                  │ (Vector)  │
                                                  └───────────┘
```

### 6.2 网络架构

| 网络 | 说明 |
|------|------|
| `default` | 主网络，连接大部分服务 |
| `ssrf_proxy_network` | 内部网络，隔离沙箱和 SSRF 代理 |

### 6.3 数据存储

| 数据 | 存储位置 |
|------|----------|
| PostgreSQL 数据 | `docker/volumes/db/data` |
| Redis 数据 | `docker/volumes/redis/data` |
| Weaviate 数据 | `docker/volumes/weaviate` |
| 用户文件 | `docker/volumes/app/storage` |
| 插件数据 | `docker/volumes/plugin_daemon` |

---

## 7. 常见问题

### 7.1 Docker 未安装

**Linux:**
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# CentOS/RHEL
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

**Mac:** 下载 Docker Desktop https://www.docker.com/products/docker-desktop

**Windows:** 下载 Docker Desktop https://www.docker.com/products/docker-desktop

### 7.2 端口冲突

如果 80 端口被占用，编辑 `docker/.env`：

```bash
EXPOSE_NGINX_PORT=8080
EXPOSE_NGINX_SSL_PORT=8443
```

### 7.3 内存不足

编辑 `docker/.env`，调整 Worker 数量：

```bash
SERVER_WORKER_AMOUNT=1
CELERY_WORKER_AMOUNT=1
```

### 7.4 数据库连接失败

检查中间件是否正常启动：

```bash
docker compose -f docker-compose.middleware.yaml --env-file middleware.env ps
```

### 7.5 向量数据库连接失败

检查 Weaviate 状态：

```bash
docker compose ps weaviate
docker compose logs weaviate
```

---

## 8. 运维命令

### 8.1 服务管理

```bash
# 启动所有服务
docker compose up -d

# 停止所有服务
docker compose down

# 重启特定服务
docker compose restart api

# 重新构建并启动
docker compose up -d --build
```

### 8.2 日志查看

```bash
# 查看所有服务日志
docker compose logs -f

# 查看特定服务日志
docker compose logs -f api
docker compose logs -f web
docker compose logs -f nginx
```

### 8.3 数据备份

```bash
# 备份数据库
docker compose exec db_postgres pg_dump -U postgres betaai > backup.sql

# 备份 Redis
docker compose exec redis redis-cli SAVE

# 备份所有数据卷
docker run --rm -v dify_db_data:/data -v $(pwd):/backup alpine tar czf /backup/db-backup.tar.gz /data
```

### 8.4 数据恢复

```bash
# 恢复数据库
cat backup.sql | docker compose exec -T db_postgres psql -U postgres betaai
```

### 8.5 更新升级

```bash
# 拉取最新代码
git pull

# 重新构建并启动
docker compose up -d --build

# 执行数据库迁移
docker compose exec api flask db upgrade
```

### 8.6 健康检查

```bash
# 检查所有服务状态
docker compose ps

# 检查 API 健康
curl http://localhost/console/api/health

# 检查 Web 服务
curl http://localhost
```

---

## 联系支持

如有问题，请联系：admin@gpnjvc.com
