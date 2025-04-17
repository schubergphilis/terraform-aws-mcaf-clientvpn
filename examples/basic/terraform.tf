terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 1.0"
    }
    okta = {
      source  = "okta/okta"
      version = ">= 1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 1.0"
    }
  }
  required_version = ">= 1.0"
}
