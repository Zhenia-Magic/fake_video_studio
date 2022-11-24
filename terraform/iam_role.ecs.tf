/*
 * Create ECS IAM Instance Role
 */

resource "aws_iam_role" "ecs" {
  assume_role_policy = data.aws_iam_policy_document.ecsAssumePolicyDocument.json
  name               = "ecsInstanceRole"
}
