/*
 * Code to create ECS Service
 */

resource "aws_ecs_service" "service" {
  name                               = "fake-video-studio"
  cluster                            = aws_ecs_cluster.production.id
  desired_count                      = length(var.aws_zones)
  force_new_deployment               = true
  iam_role                           = aws_iam_role.ecs-service-role.arn
  task_definition                    = aws_ecs_task_definition.td.arn

  load_balancer {
    target_group_arn = aws_alb_target_group.default.arn
    container_name   = "fake-video-studio"
    container_port   = 80
  }

  depends_on = [aws_alb_listener.http, aws_iam_role_policy.ecs-service-role-policy]
}
