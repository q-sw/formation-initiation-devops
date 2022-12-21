resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_info)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block              = element(var.public_subnet_info.*.cidr, count.index)
  availability_zone       = element(var.public_subnet_info.*.az, count.index)
  tags = merge(var.default_tags, {Name: element(var.public_subnet_info.*.name, count.index)}, var.project_tags)
}


resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet_info)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  cidr_block              = element(var.private_subnet_info.*.cidr, count.index)
  availability_zone       = element(var.private_subnet_info.*.az, count.index)
  tags = merge(var.default_tags, {Name: element(var.private_subnet_info.*.name, count.index)}, var.project_tags)
}
