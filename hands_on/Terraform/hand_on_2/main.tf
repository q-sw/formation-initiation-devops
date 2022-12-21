module "network" {
  source = "./modules/network"

  vpc_name = "vpc-lab-2"
  vpc_cidr =  "10.0.0.0/16"

  public_subnet_info = [ {
    name = "public_subnet_paris_1"
    cidr = "10.0.1.0/24"
    az = "eu-west-3a"
  } ]

  private_subnet_info = [
    {
      name = "private_subnet_paris_1"
      cidr = "10.0.2.0/24"
      az = "eu-west-3a"
    },
    {
      name = "private_subnet_paris_2"
      cidr = "10.0.3.0/24"
      az = "eu-west-3b"
    }
  ]
  project_tags = {
    project = "CESI_LAB_2"
  }
}


resource "aws_key_pair" "keypair" {
  key_name   = "lab2-keypair"
  public_key = file("~/Workspace/test/lab2-key.pub")
}

resource "aws_lb" "nlb" {
  name               = "lb-lab2"
  internal           = "false"
  load_balancer_type = "network"
  subnets            = [module.network.public_subnet.0.id]

  enable_deletion_protection = false

  tags = {
        Name         = "lb-lab2"
        Build        = "Terraform"
    }
}

resource "aws_lb_target_group" "targetgroup" {
  name = "web-app-target-group"
  port = 80
  protocol = "TCP"
  vpc_id = module.network.vpc.id
}

resource "aws_lb_target_group_attachment" "tg-attachment" {
    count = length(aws_instance.app)
    target_group_arn = aws_lb_target_group.targetgroup.arn
    target_id = element(aws_instance.app.*.id, count.index)
}
resource "aws_lb_listener" "lb-listener" {
    load_balancer_arn = aws_lb.nlb.arn
    port = 80
    protocol = "TCP"
    default_action{
        type = "forward"
        target_group_arn = aws_lb_target_group.targetgroup.arn
    }
}
