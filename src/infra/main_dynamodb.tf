locals {
  dynamodb_table_name = "${local.base_environment_project_name}-products"
}

module "dynamodb_table" {
  source               = "../infra-modules/dynamodb_table"
  table_name           = local.dynamodb_table_name
  table_billing_mode   = var.dynamodb_table_billing_mode
  table_hash_key       = var.dynamodb_table_hash_key
  table_attribute_name = var.dynamodb_table_attribute_name
  table_attribute_type = var.dynamodb_table_attribute_type
  tags                 = local.tags
}

