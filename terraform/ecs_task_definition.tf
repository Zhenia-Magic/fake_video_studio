/*
 * Code to create task definition
 */

data "template_file" "app" {
  template = file("container_definitions.json")

  vars = {
    region = var.aws_region
    ecr_repository = var.aws_ecr_repo
  }
}


resource "aws_ecs_task_definition" "td" {
  family                   = "fake-video-studio"
  container_definitions    = data.template_file.app.rendered
  depends_on               = [aws_db_instance.production]
}
