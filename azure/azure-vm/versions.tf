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
}

provider "azurerm" {
  # Configuration options : az login
  # subscription_id = "<YOUR_SUBSCRIPTION_ID>"
  features {
    # enable/disable specific features here
  }
}
