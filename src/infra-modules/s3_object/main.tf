resource "aws_s3_object" "s3_object" {
  bucket       = var.bucket_id
  for_each     = fileset(var.folder_path, "**/*.${var.file_type}")
  key          = each.value
  source       = "${var.folder_path}/${each.value}"
  etag         = filemd5("${var.folder_path}/${each.value}")
  content_type = var.file_content_type
}
