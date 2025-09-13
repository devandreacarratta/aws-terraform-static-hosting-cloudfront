resource "random_pet" "pet_name" {
  length = 2
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}


