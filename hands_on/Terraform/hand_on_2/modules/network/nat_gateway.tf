resource "aws_eip" "nateip" {
  vpc = true
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nateip.id
  subnet_id     = aws_subnet.public_subnet.0.id

  tags = merge(var.default_tags, var.project_tags)
}

resource "aws_route" "route_to_nat" {
  route_table_id          = aws_vpc.vpc.default_route_table_id
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.natgw.id
}