# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment
resource "azurerm_container_app_environment" "container_environment" {
  name                       = local.resource_names.container_environment_name
  location                   = data.azurerm_resource_group.this.location
  resource_group_name        = data.azurerm_resource_group.this.name
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id

  tags = merge(data.azurerm_resource_group.this.tags, {
    Role = "Container Environment for data domain"
  })
}

#https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/azapi_resource
resource "azapi_resource" "container_app" {
  name      = local.resource_names.dbt_container_app_name
  location  = data.azurerm_resource_group.this.location
  parent_id = data.azurerm_resource_group.this.id
  identity {
    type = "SystemAssigned"
  }
  type = "Microsoft.App/containerApps@2022-03-01"

  body = jsonencode({
    properties : {
      managedEnvironmentId = azurerm_container_app_environment.container_environment.id
      configuration = {
        secrets = [
          {
            name  = "function-key"
            value = data.azurerm_function_app_host_keys.orchestrate.default_function_key
          },
          {
            name  = "service-bus-connection-string"
            value = azurerm_servicebus_namespace.this.default_primary_connection_string
          },
          {
            name  = "snowflake-password"
            value = var.snowflake_password
          },
          {
            name  = "log-analytics-shared-key"
            value = data.azurerm_log_analytics_workspace.core.primary_shared_key
          },
          {
            name  = "registry-password"
            value = var.container_registry_password
          }
        ]
        ingress = null
        registries = [
          {
            server            = var.container_registry_login_server
            username          = var.container_registry_user_name
            passwordSecretRef = "registry-password"
        }]
      }
      template = {
        containers = [{
          image = "${var.container_registry_login_server}/${var.dbt_container_repository}:${var.dbt_image_tag}"
          name  = "dbt-instance"
          resources = {
            cpu    = var.dbt_container_cpu
            memory = var.dbt_container_memory
          }
          env = [
            {
              name  = "SB_NAMESPACE"
              value = azurerm_servicebus_namespace.this.name
            },
            {
              name  = "SB_QUEUE_NAME"
              value = var.service_bus_dbt_run_queue_name
            },
            {
              name  = "FUNCTION_URL"
              value = data.azurerm_linux_function_app.orchestrate.default_hostname
            },
            {
              name      = "FUNCTION_KEY"
              secretRef = "function-key"
            },
            {
              name  = "DBT_SF_ENV"
              value = var.environment
            },
            {
              name  = "DBT_SF_USR"
              value = var.snowflake_user
            },
            {
              name      = "DBT_SF_PWD"
              secretRef = "snowflake-password"
            },
            {
              name  = "DBT_SF_WH"
              value = var.snowflake_warehouse
            },
            {
              name  = "LOG_CUSTOMER_ID"
              value = data.azurerm_log_analytics_workspace.core.workspace_id
            },
            {
              name      = "LOG_SHARED_KEY"
              secretRef = "log-analytics-shared-key"
            }
          ]
        }]
        scale = {
          minReplicas = 0
          maxReplicas = 5
          rules = [{
            name = "queue-based-autoscaling"
            custom = {
              type = "azure-servicebus"
              metadata = {
                queueName    = var.service_bus_dbt_run_queue_name
                messageCount = "1"
                namespace    = azurerm_servicebus_namespace.this.name
              }
              auth = [{
                secretRef        = "service-bus-connection-string"
                triggerParameter = "connection"
              }]
            }
          }]
        }
      }
    }
  })

  tags = merge(data.azurerm_resource_group.this.tags, {
    Role = "Container app running DBT"
  })
}
