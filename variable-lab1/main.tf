provider "aws" {
    region = "us-east-1"
  
}

resource "aws_instance" "my-instance-1" {
  instance_type = var.instance_type
  ami = var.ami
  tags = {
      Name = "ec2_instance_1"
      env = "dev"
  }
}

resource "aws_instance" "my-instance-2" {
  instance_type = var.instance_type
  ami = var.ami
  tags = {
      Name = "ec2_instance_2"
      env = "qa"
  }
}