locals {
  current_object_id = length(var.current_object_id) > 0 ? var.current_object_id : data.azurerm_client_config.current.object_id
  resource_names = {
    resource_group_name            = length(var.resource_group_name) > 0 ? var.resource_group_name : "rg-data-${var.domain_code}-${var.environment}-${var.region_code}-01"
    core_resource_group_name       = length(var.core_resource_group_name) > 0 ? var.core_resource_group_name : "rg-data-core-${var.environment}-${var.region_code}-01"
    core_key_vault_name            = length(var.core_key_vault_name) > 0 ? var.core_key_vault_name : "kv-${var.customer_code}-data-core-${var.environment}-01"
    core_orchestrate_function_name = length(var.core_orchestrate_function_name) > 0 ? var.core_orchestrate_function_name : "func-${var.customer_code}-data-core-${var.environment}-01"
    service_bus_name               = length(var.service_bus_name) > 0 ? var.service_bus_name : "sb-${var.customer_code}-data-${var.domain_code}-${var.environment}-01"
    container_environment_name     = length(var.container_environment_name) > 0 ? var.container_environment_name : "cae-${var.customer_code}-data-${var.domain_code}-${var.environment}-01"
    dbt_container_app_name         = length(var.dbt_container_app_name) > 0 ? var.dbt_container_app_name : "ca-${var.customer_code}-data-${var.domain_code}-${var.environment}-01"
    dbt_doc_container_app_name     = length(var.dbt_doc_container_app_name) > 0 ? var.dbt_doc_container_app_name : "ca-${var.customer_code}-data-${var.domain_code}-${var.environment}-02"
    monitoring = {
      log_analytics_name    = length(var.log_analytics_name) > 0 ? var.log_analytics_name : "log-${var.customer_code}-logs-${var.environment}-01"
      log_analytics_name_rg = length(var.log_analytics_name_rg) > 0 ? var.log_analytics_name_rg : "rg-data-core-${var.environment}-${var.region_code}-01"
    }
  }

  namespace_secret_name = "${var.domain_code}-namespace"
  queue_secret_name     = "${var.domain_code}-queue"
}