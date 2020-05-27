resource "azurerm_function_app" "function_app" {
  name                      = "${var.prefix}-${var.name}"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  app_service_plan_id       = azurerm_app_service_plan.function_app_plan.id
  storage_connection_string = module.storage_account.conn_string
  version                   = "~3"
  enable_builtin_logging    = var.builtin_logging
  app_settings = {
    CosmosKey                           = var.cosmos_conn_string
    DOCKER_REGISTRY_SERVER_URL          = "https://index.docker.io"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  }
  client_affinity_enabled = false
  https_only              = true
  site_config {
    always_on        = true
    linux_fx_version = var.docker_config

  }
  os_type = "linux"
  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_app_service_plan" "function_app_plan" {
  name                = "${var.prefix}-function-app-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = var.app_plan_tier
    size = var.app_plan_size
  }
}


module "storage_account" {
  source = "git@github.com:antempus/tf-storage-account-module.git"

  prefix               = "${var.name}"
  storage_account_name = "storeacc"
  resource_group_name  = var.resource_group_name
  location             = var.location
}

resource "azurerm_key_vault_access_policy" "function_app_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_function_app.function_app.identity[0].principal_id
  secret_permissions = [
    "Get",
    "List"
  ]
}
