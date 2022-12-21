output "web_ip_public" {
  value = aws_instance.app.*.public_ip
}
output "lb_ip_public" {
  value = aws_instance.lb.*.public_ip
}