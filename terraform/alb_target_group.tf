/*
 * Code to create target group for Application Load Balancer
 */

resource "aws_alb_target_group" "default" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/"
  }
}
