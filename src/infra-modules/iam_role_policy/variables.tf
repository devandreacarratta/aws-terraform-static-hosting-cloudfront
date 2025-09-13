variable "roles" {
  description = "Map of IAM roles with policies."
  type = map(object({
    name               = string
    assume_role_policy = string
    policies = list(object({
      name        = string
      description = string
      policy      = string
    }))
  }))
}
