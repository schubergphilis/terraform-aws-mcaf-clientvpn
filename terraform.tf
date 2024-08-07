terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.59"
    }
    okta = {
      source  = "okta/okta"
      version = "~> 4.9"
    }
  }

  required_version = ">= 0.13"
}
