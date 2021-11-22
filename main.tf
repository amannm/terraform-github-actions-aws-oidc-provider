data "tls_certificate" "provider-certificate" {
  url = "https://token.actions.githubusercontent.com"
}
resource "aws_iam_openid_connect_provider" "provider" {
  url             = data.tls_certificate.provider-certificate.url
  thumbprint_list = slice([for c in data.tls_certificate.provider-certificate.certificates : c.sha1_fingerprint], 0, min(length(data.tls_certificate.provider-certificate.certificates), 5))
  client_id_list  = ["sts.amazonaws.com"]
}
module "provider-role" {
  source            = "./modules/github-actions-aws-oidc-role"
  provider_arn      = aws_iam_openid_connect_provider.provider.arn
  role_name         = var.role_name
  policy_arns       = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  github_repository = var.github_repository
}