![cover-v5-optimized](./images/GitHub_README_if.png)

<p align="center">
  <a href="https://docs.betaai.com">Documentation</a>
</p>

<p align="center">
    <a href="https://betaai.com" target="_blank">
        <img alt="Static Badge" src="https://img.shields.io/badge/Product-F04438"></a>
</p>

<p align="center">
  <a href="./README.md"><img alt="README in English" src="https://img.shields.io/badge/English-d9d9d9"></a>
  <a href="./docs/zh-CN/README.md"><img alt="简体中文文件" src="https://img.shields.io/badge/简体中文-d9d9d9"></a>
  <a href="./docs/ja-JP/README.md"><img alt="日本語のREADME" src="https://img.shields.io/badge/日本語-d9d9d9"></a>
  <a href="./docs/es-ES/README.md"><img alt="README en Español" src="https://img.shields.io/badge/Español-d9d9d9"></a>
  <a href="./docs/fr-FR/README.md"><img alt="README en Français" src="https://img.shields.io/badge/Français-d9d9d9"></a>
  <a href="./docs/ko-KR/README.md"><img alt="README in Korean" src="https://img.shields.io/badge/한국어-d9d9d9"></a>
  <a href="./docs/de-DE/README.md"><img alt="README in Deutsch" src="https://img.shields.io/badge/German-d9d9d9"></a>
  <a href="./docs/pt-BR/README.md"><img alt="README em Português do Brasil" src="https://img.shields.io/badge/Portugu%C3%AAs%20do%20Brasil-d9d9d9"></a>
</p>

BetaAI (贝塔引擎) is an open-source LLM app development platform. Its intuitive interface combines AI workflow, RAG pipeline, agent capabilities, model management, observability features and more, letting you quickly go from prototype to production.

## Quick start

> Before installing BetaAI, make sure your machine meets the following minimum system requirements:
>
> - CPU >= 2 Core
> - RAM >= 4 GiB

<br/>

The easiest way to start the BetaAI server is through Docker Compose:

```bash
cd docker
cp .env.example .env
cp middleware.env.example middleware.env
docker compose -f docker-compose.middleware.yaml --env-file middleware.env up -d
docker compose up -d --build
```

After running, you can access the BetaAI dashboard in your browser at [http://localhost](http://localhost) and start the initialization process.

## Key features

**1. Workflow**:
Build and test powerful AI workflows on a visual canvas.

**2. Comprehensive model support**:
Seamless integration with hundreds of proprietary / open-source LLMs from dozens of inference providers and self-hosted solutions, covering GPT, Mistral, Llama3, and any OpenAI API-compatible models.

**3. Prompt IDE**:
Intuitive interface for crafting prompts, comparing model performance, and adding additional features such as text-to-speech to a chat-based app.

**4. RAG Pipeline**:
Extensive RAG capabilities that cover everything from document ingestion to retrieval, with out-of-box support for text extraction from PDFs, PPTs, and other common document formats.

**5. Agent capabilities**:
You can define agents based on LLM Function Calling or ReAct, and add pre-built or custom tools. 50+ built-in tools for AI agents.

**6. LLMOps**:
Monitor and analyze application logs and performance over time.

**7. Backend-as-a-Service**:
All of BetaAI's offerings come with corresponding APIs.

## Deployment

### One-Click Deploy

```bash
# Linux/Mac
./deploy.sh

# Windows
.\deploy.ps1
```

### Self-hosting BetaAI

Quickly get BetaAI running in your environment with the [Quick start](#quick-start) guide.

## Advanced Setup

### Custom configurations

If you need to customize the configuration, please refer to the comments in our `docker/.env.example` file and update the corresponding values in your `.env` file.

### Deployment with Kubernetes

Community-contributed Helm Charts and YAML files allow BetaAI to be deployed on Kubernetes.

### Using Terraform for Deployment

Deploy BetaAI to Cloud Platform with Terraform.

## Contributing

For those who'd like to contribute code, see our [Contribution Guide](./CONTRIBUTING.md).

## Security disclosure

To protect your privacy, please avoid posting security issues on GitHub. Instead, report issues to admin@gpnjvc.com.

## License

This repository is licensed under the Dify Open Source License, based on Apache 2.0 with additional conditions.
