resource "azurerm_key_vault_access_policy" "keyvault_policies_azure_devops" {
  count = var.is_same_spn_than_core ? 0 : 1 # If SPN is the same as the one used for core then this policy already exists

  key_vault_id = data.azurerm_key_vault.core.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = local.current_object_id

  secret_permissions = [
    "Get",
    "List",
    "Backup",
    "Delete",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]
}

resource "azurerm_key_vault_secret" "service_bus" {
  name         = local.namespace_secret_name
  value        = azurerm_servicebus_namespace.this.name
  key_vault_id = data.azurerm_key_vault.core.id

  depends_on = [
    azurerm_key_vault_access_policy.keyvault_policies_azure_devops
  ]
}

resource "azurerm_key_vault_secret" "queue" {
  name         = local.queue_secret_name
  value        = azurerm_servicebus_queue.queue.name
  key_vault_id = data.azurerm_key_vault.core.id

  depends_on = [
    azurerm_key_vault_access_policy.keyvault_policies_azure_devops
  ]
}