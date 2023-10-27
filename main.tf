data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "this" {
  name = local.resource_names.resource_group_name
}

data "azurerm_resource_group" "core" {
  name = local.resource_names.core_resource_group_name
}

data "azurerm_log_analytics_workspace" "core" {
  name                = local.resource_names.monitoring.log_analytics_name
  resource_group_name = local.resource_names.monitoring.log_analytics_name_rg
}

data "azurerm_key_vault" "core" {
  name                = local.resource_names.core_key_vault_name
  resource_group_name = data.azurerm_resource_group.core.name
}

data "azurerm_linux_function_app" "orchestrate" {
  name                = local.resource_names.core_orchestrate_function_name
  resource_group_name = data.azurerm_resource_group.core.name
}

data "azurerm_function_app_host_keys" "orchestrate" {
  name                = local.resource_names.core_orchestrate_function_name
  resource_group_name = data.azurerm_resource_group.core.name
}