resource "aws_lb" "vault-lb" {
  name = "vault-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_vpc.id]
  subnets            = [module.subnet1.subnet_id, module.subnet2.subnet_id, module.subnet3.subnet_id]
  tags = {
    Name = "vault-lb"
  }
}

resource "aws_lb_target_group" "vault" {
  name = "vault-target-group"
    tags = {
    Name = "vault-lb-target-group"
  }

  port     = "8200"
  vpc_id   = aws_vpc.vpc.id
  protocol = "HTTPS"

  health_check {
    interval          = "5"
    timeout           = "2"
    path              = "/v1/sys/health"
    port              = "8200"
    protocol          = "HTTPS"
    matcher           = "200,472,473"
    healthy_threshold = 2
  }
}


resource "aws_lb_target_group_attachment" "vault1" {
  target_group_arn = aws_lb_target_group.vault.arn
  target_id        = module.server1.instance_id
  port             = 8200
}

resource "aws_lb_target_group_attachment" "vault2" {
  target_group_arn = aws_lb_target_group.vault.arn
  target_id        = module.server2.instance_id
  port             = 8200
}

resource "aws_lb_target_group_attachment" "vault3" {
  target_group_arn = aws_lb_target_group.vault.arn
  target_id        = module.server3.instance_id
  port             = 8200
}

resource "aws_lb_target_group_attachment" "vault-lb" {
  target_group_arn = aws_lb_target_group.vault.arn
  target_id        = aws_lb.vault-lb.id
  port             = 8200
}