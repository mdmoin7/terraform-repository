terraform {
  #required_version = ">= 1.14.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.66.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }

  # storing tfstate in a remote backend (blob storage)
  # terraform init -migrate-state : to migrate local state to remote backend
  backend "azurerm" {
    resource_group_name  = "rg-jup3kd1-devtest"
    storage_account_name = "stjup3kddevtest"
    container_name       = "tfstate"
    key                  = "appservice.tfstate"
  }
}

provider "azurerm" {
  # Configuration options : az login
  # subscription_id = "<YOUR_SUBSCRIPTION_ID>"
  features {
    # enable/disable specific features here
  }
}
