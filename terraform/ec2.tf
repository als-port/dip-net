locals {
  node_instance_type = {
    stage = "t2.micro"
    prod = "t2.micro"
  }
  node_instance_count = {
    stage = 1
    prod = 0
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_instance" "node" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.node_instance_type[terraform.workspace]
  count         = local.node_instance_count[terraform.workspace]
  subnet_id   = aws_subnet.public_subnet.id
  //associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name= "aws-key"
  connection {
      private_key = file("~/run/temp/aws-key")
      timeout     = "1m"
   }
  tags = {
    Name = "${terraform.workspace}-serv"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "aws_pk" {
  key_name   = "aws-key"
  public_key = var.pk
}