variable "bucket_name" {
  type     = string
  nullable = false
}
variable "tags" {
  type     = map(string)
  default  = {}
  nullable = true
}
variable "versioning_configuration" {
  type    = bool
  default = false
}