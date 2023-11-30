variable "environment" {
  type        = string
  description = "Environment trigram used for resource names. For example, dev, uat, tst, ppd, prd, ..."
}

variable "customer_code" {
  type        = string
  description = "Customer code used for the resource names. 3 letters maximum is recommended"
}

variable "region_code" {
  type        = string
  description = "Region code used for resource group names, for example weu for West Europe. 3 letters maximum is recommended"
}

variable "domain_code" {
  type        = string
  description = "Domain code of the data product in the Hub&Spoke architecture"
}

#####################
# Core Resource names
#####################
variable "core_resource_group_name" {
  type        = string
  default     = ""
  description = "Resource group where to create Data Core resources. Optional, default is 'rg-data-core-$${var.environment}-$${var.region_code}-01'"
}

variable "log_analytics_name" {
  type        = string
  default     = ""
  description = "Log analytics workspace name. Optional, default is 'log-$${var.customer_code}-logs-$${var.environment}-01'"
}

variable "log_analytics_name_rg" {
  type        = string
  default     = ""
  description = "Resource of the Log analytics workspace. Optional, default is 'rg-infra-logs-$${var.environment}-$${var.region_code}-01'"
}

variable "core_key_vault_name" {
  type        = string
  default     = ""
  description = "Name of the core key vault. Optional, default is 'kv-$${var.customer_code}-data-core-$${var.environment}-01'"
}

variable "core_orchestrate_function_name" {
  type        = string
  default     = ""
  description = "Name of the core key vault. Optional, default is 'func-$${var.customer_code}-data-core-$${var.environment}-01'"
}

#####################
# Domain Resource names
#####################

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "Resource group where to create Data domain resources. Optional, default is 'rg-data-$${var.domain_code}-$${var.environment}-$${var.region_code}-01'"
}

variable "service_bus_name" {
  type        = string
  default     = ""
  description = "Name of the service bus namespace. Optional, default is 'sb-$${var.customer_code}-data-$${var.domain_code}-$${var.environment}-01'"
}

variable "container_environment_name" {
  type        = string
  default     = ""
  description = "Name of the Container Environment. Optional, default is 'cae-$${var.customer_code}-data-$${var.domain_code}-$${var.environment}-01'"
}

variable "dbt_container_app_name" {
  type        = string
  default     = ""
  description = "Name of the Container App running DBT. Optional, default is 'ca-$${var.customer_code}-data-$${var.domain_code}-$${var.environment}-01'"
}

variable "dbt_doc_container_app_name" {
  type        = string
  default     = ""
  description = "Name of the Container App running DBT doc. Optional, default is 'ca-$${var.customer_code}-data-$${var.domain_code}-$${var.environment}-02'"
}

#####################
# Identity
#####################

variable "current_object_id" {
  type        = string
  default     = ""
  description = "Current object id to assign roles. Optional, default value is data.azurerm_client_config.current.object_id"
}

####################
## Service bus #####
####################

variable "service_bus_sku_name" {
  type        = string
  description = "Service Bus SKU. Optional, default is Basic"
  default     = "Basic"
}

variable "service_bus_dbt_run_queue_name" {
  type        = string
  description = "Name of the queue used to run DBT. Optional, default is 'dbt-run'"
  default     = "dbt-run"
}

#####################
# Snowflake
#####################

variable "snowflake_user" {
  type        = string
  description = "User to connect DBT to Snowflake"
}

variable "snowflake_password" {
  type        = string
  description = "Password to connect DBT to Snowflake"
}

variable "snowflake_warehouse" {
  type        = string
  description = "Warehouse used to connect DBT to Snowflake"
}

#####################
# Container registry
#####################
variable "container_registry_login_server" {
  type        = string
  default     = "dcube.azurecr.io"
  description = "Login server of the container registry. Optional, default is the dcube container registry"
}

variable "container_registry_user_name" {
  type        = string
  description = "User name to connect to the container registry."
}

variable "container_registry_password" {
  type        = string
  sensitive   = true
  description = "Password to connect to the container registry."
}

#####################
# Container
#####################

variable "dbt_container_repository" {
  type        = string
  default     = "dbt"
  description = "Name of the repository in the Container Registry for DBT. optional, default is 'dbt'"
}

variable "dbt_doc_container_repository" {
  type        = string
  default     = "dbt-doc"
  description = "Name of the repository in the Container Registry for DBT doc. optional, default is 'dbt-doc'"
}

variable "dbt_image_tag" {
  type        = string
  description = "Tag of the image in the container Registry to run DBT."
}

variable "dbt_doc_image_tag" {
  type        = string
  description = "Tag of the image in the container Registry to run DBT doc."
}

variable "dbt_container_cpu" {
  type        = number
  default     = 2
  description = "Number of vCPU to run DBT"
}

variable "dbt_container_memory" {
  type        = string
  default     = "4Gi"
  description = "Memory to run DBT"
}

variable "dbt_doc_container_cpu" {
  type        = number
  default     = 1
  description = "Number of vCPU to run DBT doc"
}

variable "dbt_doc_container_memory" {
  type        = string
  default     = "2Gi"
  description = "Memory to run DBT doc"
}

variable "is_same_spn_than_core" {
  type        = bool
  default     = false
  description = "True if SPN used to deploy is the same than SPN used for 'core'. Default is false."
}