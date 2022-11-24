resource "aws_security_group" "ecs" {
  description = "security-group-ecs"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port       = 0
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    to_port         = 65535
  }

  name = "security-group-ec2"

  tags = {
    Name = "security-group-ec2"
    Env  = "production"
  }

  vpc_id = aws_vpc.vpc.id
}
