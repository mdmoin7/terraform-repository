terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.66"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8"
    }
  }

  # Free Azure Blob backend for remote state
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatelearnapp" # must be globally unique — change this
    container_name       = "tfstate"
    key                  = "learnapp.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
