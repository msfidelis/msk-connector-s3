provider "aws" {
  region = var.region
}

provider "awscc" {
  region = var.region
}

# terraform {
#   required_providers {
#     awscc = {
#       source  = "hashicorp/awscc"
#       version = "~> 0.1.0"
#     }
#   }
# }