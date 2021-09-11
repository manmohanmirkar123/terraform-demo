resource "aws_instance" "my-instance-1" {
  instance_type = var.instance_type
  ami = var.ami
  tags = {
      Name = "ec2_instance_1"
      env = "dev"
  }
}

