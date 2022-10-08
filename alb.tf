data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "subnet" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "mysg" {
    vpc_id      = data.aws_vpc.default.id
}
# target group
resource "aws_lb_target_group" "albtg" {
  health_check {
      interval = 10
      path = "/"
      protocol = "HTTP"
      timeout = 5
      healthy_threshold  = 3
      unhealthy_threshold = 2
    }

  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_lb" "alb" {
  name               = "ALB"
  load_balancer_type = "application"
  vpc_id             = [data.aws_vpc.default.id]
  security_groups    = data.aws_security_group.mysg.id
  subnets            = data.aws_subnet_ids.subnet.id
  tags = {
    Name = "application-load_balancer"
  }

  resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.albtg.arn
  }
}

resource "aws_lb_target_group_attachment" "alb-attcah" {
  count = length(aws_instance.web)
  target_group_arn = aws_lb_target_group.albtg.arn
  target_id        = aws_instance.web[count.index].id
}
}

#alb dns
output "alb_dns" {
    value = aws_lb.alb.dns_name
}
