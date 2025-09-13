# Lambda Function GET
module "lambda_function_url_get_products" {
  source                 = "../infra-modules/lambda_function_url"
  lambda_function_name   = module.lambda_function_get_products.function_name_value
  enable_cors            = var.lambda_function_url_get_cors_enable
  cors_allow_credentials = var.lambda_function_url_get_cors_allow_credentials
  cors_allow_headers     = var.lambda_function_url_get_cors_allow_headers
  cors_allow_methods     = var.lambda_function_url_get_cors_allow_methods
  cors_allow_origins     = var.lambda_function_url_get_cors_allow_origins
  cors_expose_headers    = var.lambda_function_url_get_cors_expose_headers
  cors_max_age           = var.lambda_function_url_get_cors_max_age
}


# Lambda Function POST
module "lambda_function_url_post_products" {
  source                 = "../infra-modules/lambda_function_url"
  lambda_function_name   = module.lambda_function_post_products.function_name_value
  enable_cors            = var.lambda_function_url_post_cors_enable
  cors_allow_credentials = var.lambda_function_url_post_cors_allow_credentials
  cors_allow_headers     = var.lambda_function_url_post_cors_allow_headers
  cors_allow_methods     = var.lambda_function_url_post_cors_allow_methods
  cors_allow_origins     = var.lambda_function_url_post_cors_allow_origins
  cors_expose_headers    = var.lambda_function_url_post_cors_expose_headers
  cors_max_age           = var.lambda_function_url_post_cors_max_age
}
