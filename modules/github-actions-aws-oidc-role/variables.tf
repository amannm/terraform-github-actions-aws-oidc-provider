variable "role_name" {
  type = string
}
variable "provider_arn" {
  type = string
}
variable "github_repository" {
  type = string
}
variable "policy_arns" {
  type = list(string)
}