output "arn_value" {
  value = aws_dynamodb_table.dynamodb_table.arn
}

output "name_value" {
  value = aws_dynamodb_table.dynamodb_table.name
}
