output "s3_object_keys" {
  value = { for k, obj in aws_s3_object.s3_object : k => obj.key }
}


output "s3_object_urls" {
  value = {
    for k, obj in aws_s3_object.s3_object :
    k => "https://${var.bucket_id}.s3.amazonaws.com/${obj.key}"
  }
}
