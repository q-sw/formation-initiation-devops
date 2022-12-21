resource "aws_security_group" "sg_bastion_ssh" {
  name   = "SG_BASTION_SSH"
  vpc_id = module.network.vpc.id
  tags = {
    Name  = "SG_BASTION_SSH"
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

module "ec2_bastion" {
  source = "./modules/ec2-instance"
  
  instance_info = [
    {
      name = "bastion"
      ami_id = "ami-054e881150baee51a"
      ec2_instance_type = "t2.micro"
      ssh_key_name = aws_key_pair.keypair.key_name
      security_groups = [aws_security_group.sg_bastion_ssh.id]
      subnet_id = module.network.public_subnet.0.id
    }
  ]
  project_tags = {
    project = "CESI_LAB_2"
  }

  depends_on = [
    aws_security_group.sg_bastion_ssh, module.network
  ]
}

# resource "aws_instance" "bastion" {
#   count                  = 1
#   ami                    = "ami-054e881150baee51a"
#   instance_type          = "t2.micro"
#   key_name               = aws_key_pair.keypair.key_name
#   vpc_security_group_ids = [aws_security_group.sg_bastion_ssh.id]
#   subnet_id              = module.network.public_subnet.0.id
#   root_block_device {
#     volume_type = "gp2"
#     volume_size = "10"
#   }
#   tags = {
#     Name  = "BASTION"
#     Build = "Build by Terraform"
#   }
# }