terraform {
  required_version = ">= 1.4.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }

  # Local state for simplicity in the assignment
  backend "local" {}
}

provider "azurerm" {
  features {}
}
