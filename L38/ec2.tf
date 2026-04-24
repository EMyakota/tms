data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "server_2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.existing_key_name
  monitoring    = false
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id = var.subnet_id
  tags = {
    "Name" = "server-2"
  }

}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.admin_key.key_name
  vpc_security_group_ids = [
    aws_security_group.app_server_sg.id,
    aws_security_group.web_sg.id
  ]
  subnet_id = var.subnet_id

  tags = {
    Name = "tf-server-1"
    Team = "dos-31"
    Kind = "temporary"
  }
}

resource "aws_security_group" "app_server_sg" {
  name        = "tf-servers-sg"
  description = "Allow access for tf-servers"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "admin_key" {
  key_name   = "control-plain-key"
  public_key = file(var.public_key_path)
}
