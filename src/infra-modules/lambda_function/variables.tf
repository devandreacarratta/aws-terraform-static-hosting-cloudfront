variable "lambda_function_name" {
  type     = string
  nullable = false
}
variable "tags" {
  type     = map(string)
  default  = {}
  nullable = true
}

variable "lambda_role_arn" {
  type = string
}

variable "lambda_handler" {
  type = string
}

variable "lambda_runtime" {
  type = string
}

variable "lambda_filename" {
  type = string
}

variable "lambda_timeout" {
  type    = number
  default = 30
}

variable "lambda_environment_variables" {
  type     = map(string)
  default  = {}
  nullable = true
}
