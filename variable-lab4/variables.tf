variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "ami" {
  type = string
  default = "ami-087c17d1fe0178315"
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "tags" {
  type = map
  default = {
    Name = "my_ec2"
    environment = "dev"
  }
}