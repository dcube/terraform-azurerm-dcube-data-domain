# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "dbt" {
  name                              = local.resource_names.dbt_storage_name
  resource_group_name               = data.azurerm_resource_group.this.name
  location                          = data.azurerm_resource_group.this.location
  account_tier                      = "Standard"
  account_replication_type          = var.storage_redundancy
  account_kind                      = "StorageV2"
  access_tier                       = "Hot"
  infrastructure_encryption_enabled = true

  tags = merge(data.azurerm_resource_group.this.tags, { Role = "Storage used for DBT project" })
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share
resource "azurerm_storage_share" "dbt" {
  name                 = "dbt"
  storage_account_name = azurerm_storage_account.dbt.name
  quota                = 50
}

resource "azurerm_storage_share" "dbt_doc" {
  name                 = "dbt-doc"
  storage_account_name = azurerm_storage_account.dbt.name
  quota                = 50
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment_storage
resource "azurerm_container_app_environment_storage" "dbt" {
  name                         = "dbt"
  container_app_environment_id = azurerm_container_app_environment.container_environment.id
  account_name                 = azurerm_storage_account.dbt.name
  share_name                   = azurerm_storage_share.dbt.name
  access_key                   = azurerm_storage_account.dbt.primary_access_key
  access_mode                  = "ReadOnly"
}

resource "azurerm_container_app_environment_storage" "dbt_doc" {
  name                         = "dbt-doc"
  container_app_environment_id = azurerm_container_app_environment.container_environment.id
  account_name                 = azurerm_storage_account.dbt.name
  share_name                   = azurerm_storage_share.dbt_doc.name
  access_key                   = azurerm_storage_account.dbt.primary_access_key
  access_mode                  = "ReadWrite"
}