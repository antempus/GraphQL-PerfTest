provider "azurerm" {
  version = "2.7.0"
  features {}
}

data "azurerm_client_config" "current" {}


data "azurerm_cosmosdb_account" "comsosdb" {
  name                = var.cosmos_name
  resource_group_name = var.resource_group_name
}

locals {
  cosmos_conn_string = "AccountEndpoint=${data.azurerm_cosmosdb_account.comsosdb.endpoint};AccountKey=${data.azurerm_cosmosdb_account.comsosdb.primary_master_key}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}


module "function_app" {
  source = "./function_app"

  name                = "funcapp"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  app_plan_tier       = var.app_plan_tier
  app_plan_size       = var.app_plan_size
  cosmos_conn_string  = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.keyvault.vault_uri}secrets/${azurerm_key_vault_secret.cosmos_conn_string.name}/${azurerm_key_vault_secret.cosmos_conn_string.version})"
  key_vault_id        = azurerm_key_vault.keyvault.id
  docker_config       = "DOCKER|${var.docker_name}/${var.docker_functionapp_image}:${var.image_tag}"
}

module "app_service" {
  source              = "./app_service"
  name                = "app-service"
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  app_plan_tier       = var.app_plan_tier
  app_plan_size       = var.app_plan_size
  cosmos_conn_string  = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.keyvault.vault_uri}secrets/${azurerm_key_vault_secret.cosmos_conn_string.name}/${azurerm_key_vault_secret.cosmos_conn_string.version})"
  key_vault_id        = azurerm_key_vault.keyvault.id
  docker_config       = "DOCKER|${var.docker_name}/${var.docker_appservice_image}:${var.image_tag}"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}


resource "azurerm_key_vault" "keyvault" {
  name                            = "${var.prefix}-keyvault"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_template_deployment = true
  sku_name                        = "standard"


  # SPN Access Policy
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore"
    ]
  }
}


resource "azurerm_key_vault_secret" "cosmos_conn_string" {
  name         = "${var.prefix}-${var.cosmos_name}-conn-string"
  key_vault_id = azurerm_key_vault.keyvault.id
  value        = local.cosmos_conn_string
}

