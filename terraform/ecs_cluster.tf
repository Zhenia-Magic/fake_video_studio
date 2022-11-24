resource "aws_ecs_cluster" "production" {
  name = "production"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "production"
    Env  = "production"
  }

}
