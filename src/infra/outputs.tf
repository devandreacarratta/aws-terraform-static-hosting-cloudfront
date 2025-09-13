# Random Outputs
output "random_values" {
  value = {
    random_pet_name       = random_pet.pet_name.id,
    random_string_generic = random_string.random.result
  }
}

# S3 Hosting Outputs

output "s3_values" {
  value = {
    bucket_id          = module.s3_hosting.s3_bucket_id
    bucket_arn         = module.s3_hosting.s3_bucket_arn
    bucket_domain_name = module.s3_hosting.s3_bucket_domain_name
    html = {
      keys = module.s3_object_html.s3_object_keys
      urls = module.s3_object_html.s3_object_urls
    }
    css = {
      keys = module.s3_object_css.s3_object_keys
      urls = module.s3_object_css.s3_object_urls
    }
    png = {
      keys = module.s3_object_png.s3_object_keys
      urls = module.s3_object_png.s3_object_urls
    }
    json = {
      keys = module.s3_object_json.s3_object_keys
      urls = module.s3_object_json.s3_object_urls
    }
  }
}



# CloudFront Outputs
output "cloudfront_values" {
  value = {
    distribution_id   = aws_cloudfront_distribution.cloudfront_distribution.id
    distribution_arn  = aws_cloudfront_distribution.cloudfront_distribution.arn
    distribution_name = aws_cloudfront_distribution.cloudfront_distribution.domain_name
    aliases           = aws_cloudfront_distribution.cloudfront_distribution.aliases
    website_url       = "https://${aws_cloudfront_distribution.cloudfront_distribution.domain_name}"
  }
}

# Template Paramers
output "template_parameter_values" {
  value = {
    dynamic   = local.dynamic_template_params
    variables = var.tpl_params
  }
}

# DynamoDB Outputs
output "dynamodb_values" {
  value = {
    arn_value  = module.dynamodb_table.arn_value
    name_value = module.dynamodb_table.name_value
  }
}

# Lambda Function Outputs
output "lambda_values" {
  value = {
    get_products = {
      name = module.lambda_function_get_products.function_name_value
      url  = module.lambda_function_url_get_products.function_url_value
    }
    post_products = {
      name = module.lambda_function_post_products.function_name_value
      url  = module.lambda_function_url_post_products.function_url_value
    }
  }
}
