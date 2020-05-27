resource "azurerm_app_service" "app_service" {
  name                = "${var.prefix}-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = var.docker_config
  }

  app_settings = {
    "CosmosKey"                = var.cosmos_conn_string
    DOCKER_REGISTRY_SERVER_URL = "https://index.docker.io"

  }

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "${var.prefix}-app-service-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "Linux"
  reserved            = true
  sku {
    tier = var.app_plan_tier
    size = var.app_plan_size
  }
}


resource "azurerm_key_vault_access_policy" "app_service_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_app_service.app_service.identity[0].principal_id
  secret_permissions = [
    "Get",
    "List"
  ]
}

