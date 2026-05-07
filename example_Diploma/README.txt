Это дипломный проект по DevOps.

За основу взято простое публичное приложение на Go.
Я расширил его так, чтобы оно выглядело как нормальный сервис для развертывания и мониторинга.

Что есть в проекте:

main.go
Основной код приложения.

main_test.go
Тесты.

Dockerfile
Сборка контейнера.

docker-compose.yml
Локальный запуск приложения, Prometheus, Grafana и контейнерного мониторинга одной командой.

infra\\terraform
Простой Terraform-слой для автоматизированного старта инфраструктуры.

.github\\workflows\\ci-cd.yml
CI/CD через GitHub Actions.

monitoring
Конфиги Prometheus и Grafana, плюс dashboard для приложения и контейнеров.

scripts\\bootstrap.ps1
Быстрый запуск проекта.

Как запускать локально:

Вариант 1:
.\scripts\bootstrap.ps1

Вариант 2:
docker compose up -d --build

Адреса после запуска:

Приложение:
http://localhost:8080

Проверка сервиса:
http://localhost:8080/healthz

API:
http://localhost:8080/api/v1/hello?name=Alex

Метрики:
http://localhost:8080/metrics

Prometheus:
http://localhost:9090

Контейнерные метрики:
http://localhost:8081/metrics

Grafana:
http://localhost:3000

Логин в Grafana:
admin
admin

Что делает CI/CD:

При push запускаются линтер, проверки форматирования, тесты, сборка бинаря, сборка Docker-образа, smoke test собранного контейнера и публикация артефактов.
Для основной ветки предусмотрен deploy и уведомление в Telegram, если заданы секреты GitHub.

Что дает мониторинг:

Prometheus собирает метрики приложения и контейнеров.
Grafana показывает запросы к приложению и использование ресурсов контейнерами.

Какие секреты нужны для deploy:

DEPLOY_HOST
DEPLOY_USER
DEPLOY_SSH_KEY
TELEGRAM_BOT_TOKEN
TELEGRAM_CHAT_ID
