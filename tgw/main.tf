module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

  name = "hub-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "vpc2" {
  source = "terraform-aws-modules/vpc/aws"

  name = "spoke-vpc"
  cidr = "11.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["11.0.1.0/24", "11.0.2.0/24"]
  public_subnets  = ["11.0.101.0/24", "11.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
 map_public_ip_on_launch = true
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "public_instance_ssh" {
  name        = "Public-instance"
  description = "expose SSH"
  vpc_id      = module.vpc1.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "public_instance_ssh"
   
  }
}

module "ec2_hub" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "hub_instance"

  instance_type          = "t2.micro"
  key_name               = "my_key"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.public_instance_ssh.id,aws_security_group.hub_sec_grp.id ]
  subnet_id              = module.vpc1.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "public_instance_ssh2" {
  name        = "Public-instance"
  description = "expose SSH"
  vpc_id      = module.vpc2.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "public_instance_ssh2"
   
  }
}

module "ec2_hub2" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "hub2_instance"

  instance_type          = "t2.micro"
  key_name               = "my_key"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.public_instance_ssh2.id,aws_security_group.hub_sec_grp2.id]
  subnet_id              = module.vpc2.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "hub_sec_grp" {
  name        = "hub_sec_grp"
  description = "private SSH"
  vpc_id      = module.vpc1.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.public_instance_ssh.id}"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    security_groups = ["${aws_security_group.public_instance_ssh.id}"]
  }
  tags = {
    Name = "hub_sec_grp"
   
  }
}

resource "aws_security_group" "hub_sec_grp2" {
  name        = "hub_sec_grp2"
  description = "private SSH2"
  vpc_id      = module.vpc2.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.public_instance_ssh2.id}"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    security_groups = ["${aws_security_group.public_instance_ssh2.id}"]
  }

  tags = {
    Name = "hub_sec_grp2"
   
  }
}

module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"

  name            = "MY TGW"
  description     = "My TGW shared with several other AWS accounts"
  amazon_side_asn = 64532

  transit_gateway_cidr_blocks = ["12.99.0.0/24"]

  # When "true" there is no need for RAM resources if using multiple AWS accounts
  enable_auto_accept_shared_attachments = true

  # When "true", allows service discovery through IGMP
  enable_multicast_support = false

  vpc_attachments = {
    vpc1 = {
      vpc_id       = module.vpc1.vpc_id
      subnet_ids   = module.vpc1.private_subnets
      dns_support  = true
      ipv6_support = true



      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    },
    vpc2 = {
      vpc_id     = module.vpc2.vpc_id
      subnet_ids = module.vpc2.public_subnets

      tgw_routes = [
        {
          destination_cidr_block = "50.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "10.10.10.10/32"
        }
      ]
      tags = {
        Name = "My TGW"
      }
    },
  }



  
}
