resource "aws_dynamodb_table" "dynamodb_table" {
  name         = var.table_name
  billing_mode = var.table_billing_mode
  hash_key     = var.table_hash_key

  attribute {
    name = var.table_attribute_name
    type = var.table_attribute_type
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

