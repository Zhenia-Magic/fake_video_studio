/*
 * Code to create Launch Configuration
 */

data "template_file" "user_data_template" {
  template = file("user_data.sh")
  vars = {
    ecs_cluster_name = aws_ecs_cluster.production.name
  }
}

resource "aws_launch_configuration" "aws_conf" {
  image_id             = data.aws_ami.ecs_ami.id
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.ecs.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ecs.name
  name_prefix          = "launch-configuration-"
  key_name             = aws_key_pair.default.key_name

  user_data = data.template_file.user_data_template.rendered

  lifecycle {
    create_before_destroy = true
  }
}
