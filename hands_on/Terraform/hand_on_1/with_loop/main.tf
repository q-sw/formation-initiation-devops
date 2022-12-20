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
  availability_zone = ""
  map_public_ip_on_launch = true


  tags = {
    Name = "public_subnet"
    build_by = "terraform"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_info)

  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnet_info.*.cidr, count.index)
  availability_zone = element(var.private_subnet_info.*.az, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet_${count.index + 1}"
    build_by = "terraform"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
    build_by = "terraform"
  }
}