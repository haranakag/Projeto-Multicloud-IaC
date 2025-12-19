terraform {
  required_version = ">=1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta3"
    }

    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }
    backend "azurerm" {
        resource_group_name = "rg-terraform-state"
        storage_account_name = "haranakaterraformstate"
        container_name       = "remote-state"
        key                  = "pipeline-gitlab/terraform.tfstate"
    }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      owner     = "haranaka"
      managedby = "terraform"
    }
  }
}


provider "azurerm" {
  features {}
}

data "terraform_remote_state" "vpc" {
    backend "s3" {
    bucket = "haranaka"
    key    = "aws-vpc/terraform.tfstate"
    region = "us-east-1"
  }    
}

data "terraform_remote_state" "vnet" `{
    backend "azurerm" {
    resource_group_name = "rg-terraform-state"
    storage_account_name = "haranakaterraformstate"
    container_name       = "remote-state"
    key                  = "azurerm-vnet/terraform.tfstate"
  }    
}