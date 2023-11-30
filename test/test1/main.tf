module "dcube_data_domain_test" {
  source = "../.."

  environment                     = "dev"
  customer_code                   = "abc"
  region_code                     = "weu"
  domain_code                     = "test"
  snowflake_user                  = "My_Password"
  snowflake_password              = "My_User"
  snowflake_warehouse             = "My_Warehouse"
  container_registry_login_server = "xxx.azurecr.io"
  container_registry_user_name    = "client-fictif"
  container_registry_password     = "xxx"
  dbt_image_tag                   = "latest"
  dbt_doc_image_tag               = "latest"
}