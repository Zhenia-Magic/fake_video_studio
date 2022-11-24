/*
 * Code to create Application Load Balancer
 */

resource "aws_alb" "alb" {
  name            = "alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = flatten([aws_subnet.public_subnet.*.id])
}
