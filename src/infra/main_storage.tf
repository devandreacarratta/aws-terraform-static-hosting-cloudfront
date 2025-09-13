locals {
  bucket_name = "${local.base_environment_project_name}-${random_pet.pet_name.id}-${random_string.random.result}"
  folder_path = "../web-template"

  dynamic_template_params = {
    lambda_url            = module.lambda_function_url_get_products.function_url_value
    lambda_add_url        = module.lambda_function_url_post_products.function_url_value
    json_url              = "https://${aws_cloudfront_distribution.cloudfront_distribution.domain_name}/api/products.json"
    default_product_image = "https://${aws_cloudfront_distribution.cloudfront_distribution.domain_name}/images/placeholder.png"
  }
}

module "s3_hosting" {
  source      = "../infra-modules/s3_bucket_private"
  bucket_name = local.bucket_name
  tags        = local.tags
}

module "s3_object_css" {
  depends_on        = [aws_cloudfront_distribution.cloudfront_distribution]
  source            = "../infra-modules/s3_object"
  bucket_id         = module.s3_hosting.s3_bucket_id
  folder_path       = local.folder_path
  file_content_type = "text/css"
  file_type         = "css"
}

module "s3_object_ico" {
  depends_on        = [aws_cloudfront_distribution.cloudfront_distribution]
  source            = "../infra-modules/s3_object"
  bucket_id         = module.s3_hosting.s3_bucket_id
  folder_path       = local.folder_path
  file_content_type = "image/x-icon"
  file_type         = "ico"
}

module "s3_object_png" {
  depends_on        = [aws_cloudfront_distribution.cloudfront_distribution]
  source            = "../infra-modules/s3_object"
  bucket_id         = module.s3_hosting.s3_bucket_id
  folder_path       = local.folder_path
  file_content_type = "image/png"
  file_type         = "png"
}

module "s3_object_json" {
  depends_on        = [aws_cloudfront_distribution.cloudfront_distribution]
  source            = "../infra-modules/s3_object"
  bucket_id         = module.s3_hosting.s3_bucket_id
  folder_path       = local.folder_path
  file_content_type = "application/json"
  file_type         = "json"
}

module "s3_object_html" {
  depends_on        = [aws_cloudfront_distribution.cloudfront_distribution]
  bucket_id         = module.s3_hosting.s3_bucket_id
  source            = "../infra-modules/s3_object_template"
  folder_path       = local.folder_path
  file_content_type = "text/html"
  file_type         = "html"
  template_params   = merge(var.tpl_params, local.dynamic_template_params)
}
