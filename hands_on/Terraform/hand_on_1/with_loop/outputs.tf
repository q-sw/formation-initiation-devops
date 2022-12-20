output "subnet_public_info" {
  value = {"${aws_subnet.public.id}": "${aws_subnet.public.cidr_block}"}
}

output "subnet_private_1_info" {
  value = {"${aws_subnet.private_1.id}": "${aws_subnet.private_1.cidr_block}"}
}

output "subnet_private_2_info" {
  value = {"${aws_subnet.private_2.id}": "${aws_subnet.private_2.cidr_block}"}
}

output "sg-id" {
  value = aws_security_group.allow_ssh.arn
}