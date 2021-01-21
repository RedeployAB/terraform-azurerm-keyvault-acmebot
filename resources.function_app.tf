data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "acmebot" {
  name = var.resource_group_name
}

resource "random_string" "acmebot" {
  length  = 6
  special = false
  upper   = false
}

## Application Insights
resource "azurerm_application_insights" "acmebot" {
  name                = local.application_insights_name
  location            = local.location
  resource_group_name = data.azurerm_resource_group.acmebot.name
  application_type    = "web"

  daily_data_cap_in_gb = 1
  retention_in_days    = 30
  disable_ip_masking   = true

  tags = local.resource_tags
}

## Azure AD auth (function access)
resource "azuread_application" "acmebot" {
  display_name            = var.auth_client_name
  homepage                = local.function_app_url
  identifier_uris         = local.auth_identifier_uris
  reply_urls              = local.auth_callback_urls
  group_membership_claims = "None"

  oauth2_permissions {
    admin_consent_description  = "Allow the application to access Acmebot on behalf of the signed-in user."
    admin_consent_display_name = "Access Acmebot"
    is_enabled                 = true
    type                       = "User"
    user_consent_description   = "Allow the application to access Acmebot on your behalf."
    user_consent_display_name  = "Access Acmebot"
    value                      = "user_impersonation"
  }
}

resource "random_password" "acmebot" {
  length  = 64
  special = true

  keepers = {
    "application" = azuread_application.acmebot.id
  }
}

resource "azuread_application_password" "acmebot" {
  application_object_id = azuread_application.acmebot.id
  value                 = random_password.acmebot.result
  end_date_relative     = "87600h"
}

## Function app
resource "azurerm_function_app" "acmebot" {
  name                       = local.function_app_name
  location                   = local.location
  resource_group_name        = data.azurerm_resource_group.acmebot.name
  app_service_plan_id        = azurerm_app_service_plan.acmebot.id
  storage_account_name       = azurerm_storage_account.acmebot.name
  storage_account_access_key = azurerm_storage_account.acmebot.primary_access_key
  version                    = "~3"

  https_only              = true
  client_affinity_enabled = false

  auth_settings {
    enabled = true
    issuer  = local.token_issuer_url

    default_provider              = "AzureActiveDirectory"
    unauthenticated_client_action = "RedirectToLoginPage"

    active_directory {
      client_id     = azuread_application.acmebot.application_id
      client_secret = random_password.acmebot.result
    }
  }

  site_config {
    ftps_state    = "Disabled"
    http2_enabled = true
  }

  # Ref: https://github.com/shibayan/keyvault-acmebot#2-add-application-settings
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"  = azurerm_application_insights.acmebot.instrumentation_key
    "WEBSITE_RUN_FROM_PACKAGE"        = var.function_package_url
    "FUNCTIONS_WORKER_RUNTIME"        = "dotnet"
    "Acmebot:AzureDns:SubscriptionId" = data.azurerm_client_config.current.subscription_id
    "Acmebot:Contacts"                = var.acme_mail_address
    "Acmebot:Endpoint"                = var.acme_endpoint
    "Acmebot:VaultBaseUrl"            = azurerm_key_vault.acmebot.vault_uri
    "Acmebot:Environment"             = "AzureCloud"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.resource_tags
}

resource "azurerm_app_service_plan" "acmebot" {
  name                = local.app_service_plan_name
  location            = local.location
  resource_group_name = data.azurerm_resource_group.acmebot.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = local.resource_tags
}

resource "azurerm_storage_account" "acmebot" {
  name                = local.storage_account_name
  location            = local.location
  resource_group_name = data.azurerm_resource_group.acmebot.name

  account_tier             = "Standard"
  account_replication_type = "LRS"

  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false

  tags = local.resource_tags
}

## Azure DNS zone role assignment
resource "azurerm_role_assignment" "acmebot" {
  count = length(var.dns_zone_ids)

  scope                = var.dns_zone_ids[count.index]
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_function_app.acmebot.identity[0].principal_id
}
