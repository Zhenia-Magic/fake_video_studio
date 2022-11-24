resource "aws_iam_role_policy_attachment" "ecsInstanceProfile" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.ecs.name
}
