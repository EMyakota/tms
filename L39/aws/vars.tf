variable "ssh_key" {
  type    = string
  default = "control-plain-ssh-key"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "public_key_path" {
  type        = string
  description = "Path to public key used for aws_key_pair"
  default     = "~/.ssh/id_ed25519.pub"
}

variable "private_key_path" {
  type        = string
  description = "Path to private key used by provisioners/Ansible"
  default     = "~/.ssh/id_ed25519"
}



