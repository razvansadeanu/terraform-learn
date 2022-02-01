terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
  # cloud {
  #   organization = "binaryhubs"
  #   workspaces {
  #     name = "provisioners_2"
  #   }
  # }
  required_version = ">= 1.0.0"
}
