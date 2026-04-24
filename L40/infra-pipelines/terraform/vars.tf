variable "public_key" {
    type = string
    default = "ssh-ed25519 REPLACE_WITH_YOUR_PUBLIC_KEY emyakota@local"
}

variable "instance_type" {
    type = string
    default = "t3.micro"
}

variable "private_key_path" {
    type = string
    default = "~/.ssh/id_ed25519"
}
