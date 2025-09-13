variable "table_name" {
  type     = string
  nullable = false
}

variable "table_billing_mode" {
  type     = string
  nullable = false
  default  = "PAY_PER_REQUEST"
}

variable "table_hash_key" {
  type     = string
  nullable = false
  default  = "Id"
}

variable "table_attribute_name" {
  type     = string
  nullable = false
  default  = "Id"
}

variable "table_attribute_type" {
  type     = string
  nullable = false
  default  = "S"
}

variable "tags" {
  type     = map(string)
  default  = {}
  nullable = true
}
