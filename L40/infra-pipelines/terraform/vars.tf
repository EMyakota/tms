variable "public_key" {
    type = string
    default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxWhTj+Gyvz+8pPgQWS8NPnaimpPOUXtWtDGpZp/udJ gitlab-runner@ip-172-31-34-248"
}

variable "instance_type" {
    type = string
    default = "t3.micro"
}

variable "private_key_path" {
    type = string
    default = "~/.ssh/id_ed25519"
}
