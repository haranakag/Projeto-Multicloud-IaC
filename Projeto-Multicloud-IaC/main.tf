terraform {
  required_version = ">= 1.2.0, < 2.0.0"

  required_providers {
    aws = {
      version = "5.97.0"
      source  = "hashicorp/aws"
    }

    azurerm = {
      version = "2.0"
      source  = "hashicorp/azurerm"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      managed-by = "terraform"
      owner      = "haranaka"
    }
  }
}
provider "azurerm" {
  features {}
}