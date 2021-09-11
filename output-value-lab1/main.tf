provider "aws" {
    region = var.region
  
}

resource "aws_instance" "my-instance-1" {
  instance_type = var.instance_type
  ami = var.ami
  tags = var.tags
}

resource "aws_instance" "my-instance-2" {
  instance_type = var.instance_type
  ami = var.ami
  tags = var.tags
}