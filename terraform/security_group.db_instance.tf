/*
 * Code to get security groups for RDS
 */

resource "aws_security_group" "rds_sg" {
  name = "security-group-db-instance"
  description = "security-group-db-instance"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
    security_groups = [aws_security_group.ecs.id]
  }

  tags = {
    Name               = "security-group-db-instance"
    Env                = "production"
  }

  vpc_id = aws_vpc.vpc.id
}
