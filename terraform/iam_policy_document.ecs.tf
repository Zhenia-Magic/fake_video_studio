/*
 * Create ECS IAM Instance Policy
 */

data "aws_iam_policy_document" "ecsAssumePolicyDocument" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
    sid    = ""
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}
