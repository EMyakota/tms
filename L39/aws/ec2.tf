resource "aws_key_pair" "control_plain" {
  key_name   = "control-plain-ssh-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "ssh-sg" {
  name        = "allow-ssh"
  description = "Allow ssh from anywhere"

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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "target_1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.control_plain.key_name

  vpc_security_group_ids = [
    aws_security_group.ssh-sg.id
  ]

  tags = {
    Name = "target-host-1"
    Team = "dos-31"
    Kind = "permanent"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    script = "./scripts/wait-host.sh"
  }

  provisioner "local-exec" {
    command = "cd ./ansible && ansible-playbook -i '${self.private_ip},' -u ubuntu --private-key '${var.private_key_path}' setup-app.yaml"
  }
}
