variable "role_policies" {
  type = map(
    object({
      type                   = string
      identifiers            = list(string)
      assume_role_policy     = string
      iam_policy_name        = string
      iam_policy_description = string
      iam_policy             = string
  }))

  default = {}
}