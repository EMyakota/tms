resource "aws_key_pair" "control_plain" {
  key_name   = "control-plain-ssh-key"
  public_key = var.public_key
}

resource "aws_instance" "server_2" {
  ami           = "ami-06e3c045d79fd65d9"
  instance_type = var.instance_type
  key_name      = aws_key_pair.control_plain.key_name
  monitoring    = false
  security_groups = [
    "launch-wizard-1",
  ]
  subnet_id = "subnet-0e85977bad3d55bad"
  tags = {
    "Name" = "target-server"
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
    command = "cd ../ansible && ansible-playbook -i '${self.private_ip},' -u ubuntu --private-key '${var.private_key_path}' mongo.yml"
  }
}
