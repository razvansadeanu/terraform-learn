//HERE YOU CAN DEFINE THE TERRAFORM PROVIDER
//AND THE REQUIRED TERRAFORM VERSION
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
  cloud {
    organization = "binaryhubs"
    workspaces {
      name = "lesson_1"
    }
  }
  required_version = ">= 1.0.0"
}
