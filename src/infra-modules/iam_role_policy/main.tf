
resource "aws_iam_role" "iam_roles" {
  for_each = var.roles

  name               = each.value.name
  assume_role_policy = each.value.assume_role_policy
}

resource "aws_iam_policy" "iam_policies" {
  for_each = merge([
    for role_key, role in var.roles : {
      for idx, policy in role.policies : "${role_key}-${idx}" => policy
    } if length(role.policies) > 0
  ]...)

  name        = each.value.name
  description = each.value.description
  policy      = each.value.policy
}

resource "aws_iam_role_policy_attachment" "iam_role_attachments" {
  for_each = { for key, policy in aws_iam_policy.iam_policies : key => policy }

  role       = var.roles[split("-", each.key)[0]].name
  policy_arn = each.value.arn
}
