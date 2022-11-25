/*
 * Code to create CloudWatch log group and stream
 */

resource "aws_cloudwatch_log_group" "fake-video-studio-log-group" {
  name              = "/ecs/fake-video-studio"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "fake-video-studio-log-stream" {
  name           = "fake-video-studio-log-stream"
  log_group_name = aws_cloudwatch_log_group.fake-video-studio-log-group.name
}
