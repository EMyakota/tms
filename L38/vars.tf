variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "instance_type" {
  description = "Default EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Fallback AMI for static EC2 example"
  type        = string
  default     = "ami-06e3c045d79fd65d9"
}

variable "subnet_id" {
  description = "Target subnet id"
  type        = string
}

variable "existing_key_name" {
  description = "Existing AWS key pair name"
  type        = string
}

variable "public_key_path" {
  description = "Path to public SSH key for aws_key_pair resource"
  type        = string
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "emyakota-tms-lesson-38-demo-bucket"

  tags = {
    Name = "lesson-38-demo-bucket"
  }
}
