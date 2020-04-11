terraform {
  required_version = "= 0.12.19"
}

resource "aws_iam_role" "role_instances" {
  for_each           = var.role_policies
  name               = each.key
  assume_role_policy = each.value.assume_role_policy
}

resource "aws_iam_policy" "iam_policies" {
  for_each = var.role_policies

  name        = each.value.iam_policy_name
  description = each.value.iam_policy_description
  policy      = each.value.iam_policy
}

resource "aws_iam_role_policy_attachment" "policy_attach_to_role" {
  for_each   = var.role_policies
  role       = aws_iam_role.role_instances[each.key].name
  policy_arn = aws_iam_policy.iam_policies[each.key].arn
}