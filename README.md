# dcube/dcube-data-domain/azurerm
Terraform module for "Data Domain" resources in the dcube data architecture
https://registry.terraform.io/modules/dcube/dcube-data-domain/azurerm/latest

# Prerequesites

## resources

These resources must exist:
- A storage account for terraform state
- Data core resource group and resources
- A SPN to run the CI/CD
- If you use Azure Devops: a Service Connection associated with the previous SPN
- If you use Github: put client ID et Client secret of the previous SPN in Environment variables
- If you use Azure Devops: a service Connection to connect to the Container Registry
- If you use Github: put credentials in Environment variables to connect to Container Registry

## provider registration

These providers must be registered on the target subscription before running Terraform:
- Microsoft.ServiceBus
- Microsoft.ContainerService
- Microsoft.ManagedIdentity

## Permissions

To run this Terraform project you need these permissions (the SPN in the CI/CD):
- SPN must be ***Storage Account Key Operator Service Role*** on terraform storage account
- SPN must be ***Owner*** of its resource group
- SPN must be reader of "core" resource group
- SPN must have permissions Microsoft.Web/sites/config/list/action, Microsoft.OperationalInsights/workspaces/sharedKeys/action, Microsoft.KeyVault/vaults/accessPolicies/write and Microsoft.Web/sites/host/listkeys/action on RG core (custom role)
- SPN must have permission Microsoft.OperationalInsights/workspaces/read on Log Analytics (Role Log Analytics Contirbutor)