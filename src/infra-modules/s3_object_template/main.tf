resource "aws_s3_object" "s3_object" {
  bucket       = var.bucket_id
  for_each     = fileset(var.folder_path, "**/*.${var.file_type}.tftpl")
  key          = replace(each.value, ".${var.file_type}.tftpl", ".${var.file_type}")
  content      = templatefile("${var.folder_path}/${each.value}", var.template_params)
  etag         = md5(templatefile("${var.folder_path}/${each.value}", var.template_params))
  content_type = var.file_content_type
}
