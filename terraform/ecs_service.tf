/*
 * Code to create ECS Service
 */

resource "aws_ecs_service" "service" {
  name                               = "fake-video-studio"
  cluster                            = aws_ecs_cluster.production.id
  desired_count                      = length(var.aws_zones)
  enable_ecs_managed_tags = true
  force_new_deployment    = true
  load_balancer {
    target_group_arn = aws_alb_target_group.default.arn
    container_name   = "fake-video-studio"
    container_port   = "8080"
  }
  task_definition = "${aws_ecs_task_definition.td.family}:${aws_ecs_task_definition.td.revision}"
}
