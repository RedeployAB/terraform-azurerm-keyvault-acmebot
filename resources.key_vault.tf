resource "azurerm_key_vault" "acmebot" {
  name                = local.key_vault_name
  location            = local.location
  resource_group_name = data.azurerm_resource_group.acmebot.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku

  tags = var.resource_tags
}

resource "azurerm_key_vault_access_policy" "acmebot" {
  key_vault_id = azurerm_key_vault.acmebot.id

  tenant_id = azurerm_function_app.acmebot.identity[0].tenant_id
  object_id = azurerm_function_app.acmebot.identity[0].principal_id

  secret_permissions = [
    "set",
    "get",
    "list"
  ]
}
