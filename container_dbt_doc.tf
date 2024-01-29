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
          },
          {
            name  = "registry-password"
            value = var.container_registry_password
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
            server            = var.container_registry_login_server
            username          = var.container_registry_user_name
            passwordSecretRef = "registry-password"
        }]
      }
      template = {
        containers = [{
          image = "${var.container_registry_login_server}/${var.dbt_doc_container_repository}:${var.dbt_doc_image_tag}"
          name  = "dbt-doc-instance"
          resources = {
            cpu    = var.dbt_doc_container_cpu
            memory = var.dbt_doc_container_memory
          }
          volumeMounts = [
            {
              mountPath  = "/dbt-doc"
              volumeName = "dbt-doc-files-volume"
            }
          ]
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
        volumes = [
          {
            name = "dbt-doc-files-volume"
            storageType = "AzureFile"
            storageName = "dbt-doc"
          }
        ]
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