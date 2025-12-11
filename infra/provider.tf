terraform {
  required_version = ">= 1.4.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "remote" {
    organization = "MyDevopsDemo"

    workspaces {
      name = "devops-demo"
    }
  }
}

provider "azurerm" {
  features {}
}
