# TMS Diploma Project

This diploma project is based on the public repository:

- source: `https://github.com/hackersandslackers/golang-helloworld`

The original application was extended into a small production-style service with:

- Dockerized deployment
- infrastructure bootstrap from one command
- CI/CD with GitHub Actions
- Prometheus monitoring
- Grafana dashboards
- deployment notifications

## Project structure

- `main.go` - application entry point
- `main_test.go` - unit tests
- `Dockerfile` - container image build
- `docker-compose.yml` - local infrastructure
- `infra/terraform` - IaC wrapper for infrastructure bootstrap
- `monitoring/` - Prometheus and Grafana configuration
- `.github/workflows/ci-cd.yml` - CI/CD pipeline
- `scripts/bootstrap.ps1` - one-command local startup
- `scripts/destroy.ps1` - cleanup script
- `REPORT.md` - diploma completion summary

## Run locally

Windows PowerShell:

```powershell
.\scripts\bootstrap.ps1
```

If you want to use a prebuilt image from GHCR, copy `.env.example` to `.env`.

Alternative:

```powershell
docker compose up -d --build
```

## Endpoints

- app: `http://localhost:8080`
- hello: `http://localhost:8080/api/v1/hello?name=Alex`
- health: `http://localhost:8080/healthz`
- readiness: `http://localhost:8080/readyz`
- metrics: `http://localhost:8080/metrics`
- prometheus: `http://localhost:9090`
- grafana: `http://localhost:3000`

Grafana default credentials:

- username: `admin`
- password: `admin`

## CI/CD behavior

- every push:
  - formatting check
  - `go vet`
  - unit tests
  - build artifact upload
  - Docker image build and publish to GHCR
- push to `main/master`:
  - deployment to target host over SSH
  - Telegram notification

## Required GitHub secrets

- `DEPLOY_HOST`
- `DEPLOY_USER`
- `DEPLOY_SSH_KEY`
- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHAT_ID`

## Terraform bootstrap

If Terraform is available, infrastructure bootstrap can also be triggered from:

```powershell
cd infra/terraform
terraform init
terraform apply -auto-approve
```

## Notes

- local startup requires Docker Desktop or another running Docker engine
- remote deployment requires a prepared host with Docker Compose and access to GHCR
