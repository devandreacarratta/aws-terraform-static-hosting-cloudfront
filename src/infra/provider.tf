terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=6.13.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


locals {

  base_environment_project_name = "${var.project_name}-${var.project_environment}"

  tags = {
    LastUpdated                = "${timestamp()}"
    Owner                      = "devandreacarratta.it"
    ManagedBy                  = "Terraform"
    Project                    = var.project_name
    Environment                = var.project_environment
    GitHubOrganization         = "devandreacarratta"
    GitHubRepository           = "aws-terraform-static-hosting-cloudfront"
    BaseEnvironmentProjectName = local.base_environment_project_name
  }
}
