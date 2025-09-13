variable "bucket_id" {
  type     = string
  nullable = false
}

variable "folder_path" {
  type     = string
  nullable = false
}
variable "file_type" {
  type     = string
  nullable = false
}

variable "file_content_type" {
  type     = string
  default  = false
  nullable = true
}
