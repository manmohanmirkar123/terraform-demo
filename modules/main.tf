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
}

module "ec2_instance1" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "hub-instance"

  instance_type          = "t2.micro"
  key_name               = "my-key"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.public_instance_ssh.id]
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
}

module "ec2_instance2" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "spoke-instance"

  instance_type          = "t2.micro"
  key_name               = "my-key"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.public_instance_ssh2.id]
  subnet_id              = module.vpc2.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
