terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.5.0"
    }
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
  required_version = ">= 0.13"
}
