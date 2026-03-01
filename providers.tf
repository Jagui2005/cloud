terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      # Esto soluciona el error de "Resource Group still contains Resources"
      prevent_deletion_if_contains_resources = false
    }
  }
}