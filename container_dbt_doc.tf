resource "azapi_resource" "container_app_docs" {
  name      = local.resource_names.dbt_doc_container_app_name
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
            name  = "snowflake-password"
            value = var.snowflake_password
          }
        ]
        ingress = {
          external      = true
          targetPort    = 8080
          allowInsecure = false
          # ipSecurityRestrictions = {
          #   name = ""
          #   ipAddressRange = ""
          #   action = "Allow"
          # }
        }
        registries = [
          {
            server   = data.azurerm_container_registry.this.login_server
            identity = azurerm_user_assigned_identity.aci_identity_doc.id
        }]
      }
      template = {
        containers = [{
          image = "${data.azurerm_container_registry.this.login_server}/${var.dbt_doc_container_repository}:${var.dbt_doc_image_tag}"
          name  = "dbt-doc-instance"
          resources = {
            cpu    = var.dbt_doc_container_cpu
            memory = var.dbt_doc_container_memory
          }
          env = [
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
            }
          ]
        }]
        scale = {
          minReplicas = 0
          maxReplicas = 1
          rules = [{
            name = "httpscalingrule"
            custom = {
              type = "http"
              metadata = {
                "concurrentRequests" : "100"
              }
            }
          }]
        }
      }
    }
  })

  tags = merge(data.azurerm_resource_group.this.tags, {
    Role = "Container app running DBT doc"
  })
}