
output "iam_role_arns" {
  value = { for role_key, role in aws_iam_role.iam_roles : role_key => role.arn }
}

output "iam_policy_arns" {
  value = { for role_key, policy in aws_iam_policy.iam_policies : role_key => policy.arn }
}
