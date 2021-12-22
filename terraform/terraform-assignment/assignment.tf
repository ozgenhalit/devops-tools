terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ex_ami" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["729556892494"] #or just "self"

}

resource "aws_instance" "stevie-instance" {
  ami           = data.aws_ami.ex_ami.id
  instance_type = "t2.micro"
  key_name      = "stevie"
  security_groups = ["sec-grp"]
  tags = {
    "Name" = "Terraform First Instance"
  }

  provisioner "file" {
      content = aws_instance.stevie-instance.public_ip
      destination = "/home/ec2-user/my_public_ip.txt"
  
  }
  provisioner "file" {
      content = aws_instance.stevie-instance.private_ip
      destination = "/home/ec2-user/my_private_ip.txt"
  }

  connection {
    host = aws_instance.stevie-instance.public_ip
    type = "ssh"
    user = "ec2-user"
    private_key = file("stevie.pem")
  }

  provisioner "remote-exec" {
      inline = [
          "sudo yum -y install httpd",
          "sudo systemctl enable httpd",
          "sudo systemctl start httpd",
          "echo hello world from stevie > index.html",
          "sudo cp index.html /var/www/html"
        
      ]
  
  }
}
resource "aws_instance" "stevie-instance2" {
  ami             = data.aws_ami.ex_ami.id
  instance_type   = "t2.micro"
  key_name        = "stevie"
  security_groups = ["sec-grp"]

  tags = {
    "Name" = "Terraform Second Instance"
  }
  
  provisioner "file" {
      content = aws_instance.stevie-instance2.public_ip
      destination = "/home/ec2-user/my_public_ip.txt"
  }
  provisioner "file" {
      content = aws_instance.stevie-instance2.private_ip
      destination = "/home/ec2-user/my_private_ip.txt"
  }
  connection {
    host = aws_instance.stevie-instance2.public_ip
    type = "ssh"
    user = "ec2-user"
    private_key = file("stevie.pem")
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "echo hello world from stevie > index.html ",
      "sudo cp index.html /var/www/html"
    ]
  }

}


