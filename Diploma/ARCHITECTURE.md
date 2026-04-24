# Architecture

## Source application

The diploma project is based on the public repository:

- `https://github.com/hackersandslackers/golang-helloworld`

The original tutorial app was extended to satisfy diploma requirements:

- health and readiness endpoints
- Prometheus metrics
- Docker-based deployment
- monitoring stack with Prometheus and Grafana
- GitHub Actions CI/CD

## Components

- `app` - Go HTTP service
- `prometheus` - metrics collection
- `grafana` - monitoring dashboards
- `docker compose` - local target infrastructure
- `terraform` - IaC entry point for automated deployment

## CI/CD flow

- push to any branch:
  - format check
  - `go vet`
  - unit tests
  - binary build
  - artifact upload
  - Docker image build and push to GHCR
- push to `main/master`:
  - remote deployment over SSH
  - Telegram notification

