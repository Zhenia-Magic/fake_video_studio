/*
 * Code to create listeners to connect Application Load Balancer to target group
 */

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.default.arn
    type             = "forward"
  }

}
