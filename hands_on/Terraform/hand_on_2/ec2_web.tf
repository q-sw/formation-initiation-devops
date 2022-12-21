resource "aws_security_group" "sg_private_app" {
  name   = "SG_PRIVATE_APP"
  vpc_id = module.network.vpc.id
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

  depends_on = [
    module.network
  ]
}

resource "aws_security_group" "sg_private_ssh" {
  name   = "SG_PRIVATE_SSH"
  vpc_id = module.network.vpc.id
  tags = {
    Name  = "SG_PRIVATE_SSH"
    Build = "Terraform"
  }
  
  depends_on = [
    module.network
  ]
}

resource "aws_security_group_rule" "ssh_private_access" {
  type                      = "ingress"
  from_port                 = 22
  to_port                   = 22
  protocol                  = "tcp"
  source_security_group_id  = aws_security_group.sg_bastion_ssh.id
  security_group_id         = aws_security_group.sg_private_ssh.id

  depends_on = [
    module.network
  ]
}

resource "aws_instance" "app" {
  count                  = 2
  ami                    = "ami-054e881150baee51a"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.sg_private_app.id, aws_security_group.sg_private_ssh.id ]
  subnet_id              = module.network.private_subnet.0.id
  root_block_device {
    volume_type = "gp2"
    volume_size = "10"
  }

  user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
EOF

  tags = {
    Name  = "WEB-${count.index}"
    Build = "Terraform"
  }
}