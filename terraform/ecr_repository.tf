/*
 * Code to create ECR repository
 */

resource "aws_ecr_repository" "default" {
  name  = "fake-video-studio"

  image_scanning_configuration {
    scan_on_push = true
  }
}
