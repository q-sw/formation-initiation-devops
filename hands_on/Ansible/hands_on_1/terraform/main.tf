resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_network_address_usage_metrics = false
  enable_dns_support  = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform_vpc"
    build_by = "terraform"
  }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "terraform_igw"
      build_by = "terraform"
  }
}

resource "aws_route" "route"{
    route_table_id  = aws_vpc.main.default_route_table_id
    destination_cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.gw.id
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-3a"
  map_public_ip_on_launch = true


  tags = {
    Name = "public_subnet"
    build_by = "terraform"
  }
}

resource "aws_key_pair" "keypair" {
  key_name   = "lab2-keypair"
  public_key = file("~/Workspace/test/lab2-key.pub")
}

resource "aws_instance" "app" {
  count                  = 2
  ami                    = "ami-054e881150baee51a"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.sg_private_app.id, aws_security_group.sg_ssh.id ]
  subnet_id              = aws_subnet.public.id
  root_block_device {
    volume_type = "gp2"
    volume_size = "10"
  }

  tags = {
    Name  = "WEB-${count.index}"
    Build = "Terraform"
  }
}

resource "aws_instance" "lb" {
  count                  = 1
  ami                    = "ami-054e881150baee51a"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.sg_private_app.id, aws_security_group.sg_ssh.id ]
  subnet_id              = aws_subnet.public.id
  root_block_device {
    volume_type = "gp2"
    volume_size = "10"
  }

  tags = {
    Name  = "LB-${count.index}"
    Build = "Terraform"
  }
}

resource "aws_security_group" "sg_private_app" {
  name   = "SG_PRIVATE_APP"
  vpc_id = aws_vpc.main.id
  tags = {
    Name  = "SG_PRIVATE_APP"
    Build = "Terraform"
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_ssh" {
  name   = "SG_ALLOW_SSH"
  vpc_id = aws_vpc.main.id
  tags = {
    Name  = "SG_ALLOW_SSH"
    Build = "Build by tf-module-aws-securitygroup"
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}