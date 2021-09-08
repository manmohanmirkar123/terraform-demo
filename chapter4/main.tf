provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "first_ec2" {
    ami = "ami-087c17d1fe0178315"
    instance_type = "t2.micro"
    key_name = "boto3"
    tags = {
        Name= "myec2"
    }
}
