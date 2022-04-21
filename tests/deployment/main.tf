terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.99.0"
    }
  }
  required_version = ">= 1.1"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

module "keyvault_acmebot" {
  source = "../.."

  resource_group_name = azurerm_resource_group.environment.name
  location            = azurerm_resource_group.environment.location
  acme_endpoint       = "https://acme-staging-v02.api.letsencrypt.org/"
  acme_mail_address   = "keyvault.acmebot@redeploy.com"

  tags = {
    environment = "test"
  }

  depends_on = [
    azurerm_resource_group.environment
  ]
}
