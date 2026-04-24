$ErrorActionPreference = "Stop"

Set-Location $PSScriptRoot\..
docker compose up -d --build

Write-Host "Application: http://localhost:8080"
Write-Host "Prometheus:  http://localhost:9090"
Write-Host "Grafana:     http://localhost:3000"

