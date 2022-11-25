/*
 * Code to get security groups for ECS
 */

resource "aws_security_group" "ecs" {
  name = "security-group-ec2"
  description = "security-group-ecs"

  ingress {
    from_port       = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    to_port         = 80
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-group-ec2"
    Env  = "production"
  }

  vpc_id = aws_vpc.vpc.id
}
