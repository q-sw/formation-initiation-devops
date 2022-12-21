resource "aws_instance" "instance" {
  count                  = length(var.instance_info)

  ami                    = element(var.instance_info.*.ami_id, count.index)
  instance_type          = element(var.instance_info.*.ec2_instance_type, count.index)
  key_name               = element(var.instance_info.*.ssh_key_name, count.index)
  vpc_security_group_ids = element(var.instance_info.*.security_groups, count.index)
  subnet_id              =  element(var.instance_info.*.subnet_id, count.index)

  root_block_device {
    volume_type = "gp2"
    volume_size = "10"
  }
  tags = merge(var.default_tags, {Name: element(var.instance_info.*.name, count.index)}, var.project_tags)
}