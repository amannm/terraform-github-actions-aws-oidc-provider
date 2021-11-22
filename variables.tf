variable "role_name" {
  type    = string
  default = "github-actions"
}
variable "role_policy_arns" {
  type    = set(string)
  default = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}
variable "github_repository" {
  type = string
}