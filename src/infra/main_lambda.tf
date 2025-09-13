locals {
  lambda_runtime_python = "python3.11"

  lambda_environment_variables = {
    DYNAMODB_TABLE = local.dynamodb_table_name
  }

  lambda_function_name_get  = "${local.base_environment_project_name}-get-products"
  lambda_function_name_post = "${local.base_environment_project_name}-post-products"

}

data "archive_file" "lambda_get" {
  type        = "zip"
  source_file = "../lambda-function-python/get_products_lambda.py"
  output_path = "../lambda-function-python-zip/get_products_lambda.zip"
}

module "lambda_function_get_products" {
  source                       = "../infra-modules/lambda_function"
  lambda_environment_variables = local.lambda_environment_variables
  lambda_filename              = data.archive_file.lambda_get.output_path
  lambda_function_name         = local.lambda_function_name_get
  lambda_handler               = "get_products_lambda.lambda_handler"
  lambda_role_arn              = module.iam_role_policy.iam_role_arns["reader"]
  lambda_runtime               = local.lambda_runtime_python
  lambda_timeout               = var.lambda_products_get_timeout
  tags                         = local.tags
  depends_on = [
    module.dynamodb_table,
    module.iam_role_policy
  ]
}

data "archive_file" "lambda_post" {
  type        = "zip"
  source_file = "../lambda-function-python/post_products_lambda.py"
  output_path = "../lambda-function-python-zip/post_products_lambda.zip"
}

module "lambda_function_post_products" {
  source                       = "../infra-modules/lambda_function"
  lambda_environment_variables = local.lambda_environment_variables
  lambda_filename              = data.archive_file.lambda_post.output_path
  lambda_function_name         = local.lambda_function_name_post
  lambda_handler               = "post_products_lambda.lambda_handler"
  lambda_role_arn              = module.iam_role_policy.iam_role_arns["writer"]
  lambda_runtime               = local.lambda_runtime_python
  lambda_timeout               = var.lambda_products_post_timeout
  tags                         = local.tags
  depends_on = [
    module.dynamodb_table,
    module.iam_role_policy
  ]
}
