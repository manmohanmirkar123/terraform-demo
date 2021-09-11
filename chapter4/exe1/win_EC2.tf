
#This script will be used for deploying win2019 ami in AWS
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "win_ec2" {
    ami = "ami-02cc00a60f7d8adb7"
    instance_type = "t2.micro"
    tags = {
      "Name" = "Win_EC2"
    }
}