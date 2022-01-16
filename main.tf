terraform {
  required_providers {
    aws = {
      version = ">= 2.33.0"
    }
  }
}
data "tls_certificate" "provider-certificate" {
  url = "https://token.actions.githubusercontent.com"
}
resource "aws_iam_openid_connect_provider" "provider" {
  url = data.tls_certificate.provider-certificate.url
  #  https://github.blog/changelog/2022-01-13-github-actions-update-on-oidc-based-deployments-to-aws/
  thumbprint_list = concat(["6938fd4d98bab03faadb97b34396831e3780aea1"], slice([for c in data.tls_certificate.provider-certificate.certificates : c.sha1_fingerprint], 0, min(length(data.tls_certificate.provider-certificate.certificates), 5)))
  client_id_list  = ["sts.amazonaws.com"]
}
module "provider-role" {
  source            = "./modules/github-actions-aws-oidc-role"
  provider_arn      = aws_iam_openid_connect_provider.provider.arn
  role_name         = var.role_name
  policy_arns       = var.role_policy_arns
  github_repository = var.github_repository
}