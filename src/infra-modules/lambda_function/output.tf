output "function_name_value" {
  value = aws_lambda_function.lambda_function.function_name
}

output "arn_value" {
  value = aws_lambda_function.lambda_function.arn
}

output "invoke_arn_value" {
  value = aws_lambda_function.lambda_function.invoke_arn
}
