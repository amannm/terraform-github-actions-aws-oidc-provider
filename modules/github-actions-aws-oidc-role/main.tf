locals {
  github_actions_provider_hostname = "token.actions.githubusercontent.com"
}
data "aws_iam_policy_document" "provider-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.provider_arn]
    }
    condition {
      test     = "StringLike"
      variable = "${local.github_actions_provider_hostname}:sub"
      values   = ["repo:${var.github_repository}:*"]
    }
  }
}
resource "aws_iam_role" "provider-role" {
  name                = var.role_name
  assume_role_policy  = data.aws_iam_policy_document.provider-role-policy.json
  managed_policy_arns = var.policy_arns
}