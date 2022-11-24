/*
 * Code to create task definition
 */

resource "aws_ecs_task_definition" "td" {
  family                   = "fake-video-studio"
  container_definitions    = file("container_definitions.json")
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  memory                   = "2048"
}
