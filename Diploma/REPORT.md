# Diploma Report

## Implemented requirements

- selected a public source repository and copied it into the diploma project
- application source code was extended and documented
- local infrastructure is described declaratively with Docker Compose
- one-command startup is available through `scripts/bootstrap.ps1`
- CI/CD pipeline is configured with GitHub Actions
- monitoring is configured with Prometheus and Grafana
- deployment notifications are configured for Telegram

## Public source

- original repository: `https://github.com/hackersandslackers/golang-helloworld`

## Verification done locally

- `go mod tidy`
- `go test ./...`
- `go build -o bin/diploma-service.exe .`
- local run with successful checks for `/healthz` and `/api/v1/hello`
- `docker compose config`

## Verification limits

- full container startup was not completed in this environment because the local Docker engine was not running
- remote deployment requires GitHub secrets and a target host
