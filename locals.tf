locals {
  location                  = coalesce(var.location, lower(data.azurerm_resource_group.acmebot.location))
  function_app_name         = coalesce(var.function_app_name, lower("func-${var.workload_name}-${random_string.acmebot.result}"))
  application_insights_name = coalesce(var.application_insights_name, lower("ai-${var.workload_name}-${random_string.acmebot.result}"))
  storage_account_name      = coalesce(var.storage_account_name, lower("stacmebot${random_string.acmebot.result}"))
  app_service_plan_name     = coalesce(var.app_service_plan_name, lower("plan-${var.workload_name}-${random_string.acmebot.result}"))
  key_vault_name            = coalesce(var.key_vault_name, lower("kv-${var.workload_name}-${random_string.acmebot.result}"))
  auth_identifier_uris      = [local.function_app_url]
  auth_callback_urls        = ["${local.function_app_url}/.auth/login/aad/callback"]
  token_issuer_url          = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/v2.0"
  function_app_url          = "https://${lower(local.function_app_name)}.azurewebsites.net"
  resource_tags             = merge((var.inherit_resource_group_tags ? data.azurerm_resource_group.acmebot.tags : {}), var.resource_tags)
}
