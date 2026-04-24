terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "emyakota-workspaces-tfstate"
    key            = "24-02/terraform.tfstate"
    region         = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}

locals {
  ws = terraform.workspace
  env = local.ws == "default" ? "dev" : local.ws
  bucket_name = "emyakota-${local.env}-bucket"
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = local.env
  }
}

variable "aws_region" {
  type        = string
  default     = "us-east-2"
}
