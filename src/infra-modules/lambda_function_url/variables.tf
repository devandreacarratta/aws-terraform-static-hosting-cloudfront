variable "lambda_function_name" {
  type     = string
  nullable = false
}

variable "enable_cors" {
  type    = bool
  default = false
}

variable "cors_allow_credentials" {
  type     = bool
  default  = false
  nullable = true
}

variable "cors_allow_headers" {
  type     = list(string)
  default  = ["*"]
  nullable = true
}

variable "cors_allow_methods" {
  type     = list(string)
  default  = ["*"]
  nullable = true
}

variable "cors_allow_origins" {
  type     = list(string)
  default  = ["*"]
  nullable = true
}

variable "cors_expose_headers" {
  type     = list(string)
  default  = ["*"]
  nullable = true
}
variable "cors_max_age" {
  type     = number
  default  = 0
  nullable = true
}
