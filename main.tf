terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.99.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~>1.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }

  required_version = "~>1.1"
}
