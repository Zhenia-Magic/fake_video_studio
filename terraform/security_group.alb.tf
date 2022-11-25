/*
 * Code to create Security Group for the Application Load Balancer
 */

resource "aws_security_group" "alb" {
  name = "security-group-alb"
  description = "security-group-alb"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Env  = "production"
    Name = "security-group-alb"
  }

  vpc_id = aws_vpc.vpc.id
}
