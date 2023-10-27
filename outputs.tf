output "resource_group_name" {
  value = data.azurerm_resource_group.this.name
}

output "container_environment_id" {
  value = azurerm_container_app_environment.container_environment.id
}

output "servicebus_namespace_primary_connection_string" {
  value     = azurerm_servicebus_namespace.this.default_primary_connection_string
  sensitive = true
}

output "servicebus_namespace_name" {
  value = azurerm_servicebus_namespace.this.name
}