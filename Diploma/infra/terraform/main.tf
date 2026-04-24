terraform {
  required_version = ">= 1.6.0"
}

resource "terraform_data" "docker_compose_up" {
  provisioner "local-exec" {
    command = "docker compose up -d --build"
    working_dir = "${path.module}/../.."
  }
}

