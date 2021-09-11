provider "aws" {
region = "us-east-1"
  
}

module "ec2-module-demo" {
  source = "./ec2_module"
}