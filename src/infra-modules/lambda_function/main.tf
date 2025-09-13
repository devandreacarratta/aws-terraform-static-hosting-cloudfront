resource "aws_lambda_function" "lambda_function" {
  function_name    = var.lambda_function_name
  role             = var.lambda_role_arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  filename         = var.lambda_filename
  source_code_hash = filebase64sha256(var.lambda_filename)
  timeout          = var.lambda_timeout
  tags             = var.tags

  lifecycle {
    # ignore_changes = [source_code_hash]
    ignore_changes = [tags]
  }

  logging_config {
    log_format = "Text"
  }

  environment {
    variables = var.lambda_environment_variables
  }
}
