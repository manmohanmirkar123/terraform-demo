provider "aws" {
    region = "us-east-1"
  
  }

resource "aws_instance" "my-ec2" {
    ami = "ami-087c17d1fe0178315"
    instance_type = "t2.micro"
    tags = {
      "Name" = "my_ec2"
    }
}

resource "aws_ebs_volume" "ebs-vol" {
    size = 40
    availability_zone = "us-east-1c"
}

resource "aws_volume_attachment" "ebs_ec2_att" {
  device_name = "/dev/sdd"
  volume_id = aws_ebs_volume.ebs-vol.id
  instance_id = aws_instance.my-ec2.id
}