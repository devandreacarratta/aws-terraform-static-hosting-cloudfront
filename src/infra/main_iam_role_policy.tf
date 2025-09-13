module "iam_role_policy" {
  source = "../infra-modules/iam_role_policy"

  roles = {

    reader = {
      name = "${local.base_environment_project_name}-lambda-products-reader-role"
      assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
          Action    = "sts:AssumeRole",
          Effect    = "Allow",
          Principal = { Service = "lambda.amazonaws.com" }
        }]
      })
      policies = [
        {
          name        = "${local.base_environment_project_name}-lambda-reader-policy"
          description = "Policy for reading from DynamoDB"
          policy = jsonencode({
            Version = "2012-10-17",
            Statement = [{
              Effect   = "Allow"
              Action   = ["dynamodb:GetItem", "dynamodb:Scan", "dynamodb:Query"]
              Resource = module.dynamodb_table.arn_value
            }]
          })
        }
      ]
    }

    writer = {
      name = "${local.base_environment_project_name}-lambda-products-writer-role"
      assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
          Action    = "sts:AssumeRole",
          Effect    = "Allow",
          Principal = { Service = "lambda.amazonaws.com" }
        }]
      })
      policies = [
        {
          name        = "${local.base_environment_project_name}-lambda-writer-policy"
          description = "Policy for writing to DynamoDB"
          policy = jsonencode({
            Version = "2012-10-17",
            Statement = [{
              Effect   = "Allow"
              Action   = ["dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:DeleteItem"]
              Resource = module.dynamodb_table.arn_value
            }]
          })
        }
      ]
    }
  }
}
