terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.5.0"
    }
    okta = {
      source  = "oktadeveloper/okta"
      version = ">= 3.5.0"
    }
  }
  required_version = ">= 0.14"
}
