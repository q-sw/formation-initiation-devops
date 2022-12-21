output "vpc" {
  value = aws_vpc.vpc
}

output "public_subnet" {
  value = aws_subnet.public_subnet
}

output "private_subnet" {
  value = aws_subnet.private_subnet
}

output "nat_ip" {
  value = aws_eip.nateip.address
}