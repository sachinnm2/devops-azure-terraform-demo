# ---------------------------
# Resource Group
# ---------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# ---------------------------
# Azure Container Registry
# ---------------------------
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# ---------------------------
# App Service Plan (Linux)
# ---------------------------
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  os_type  = "Linux"
  sku_name = "B1"
}

# ---------------------------
# Web App for Containers
# ---------------------------
resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
	  docker_image_name   = "${azurerm_container_registry.acr.login_server}/${var.image_name}"
      docker_image_tag    = var.image_tag
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  app_settings = {
    WEBSITES_PORT                     = "3000"
    DOCKER_REGISTRY_SERVER_URL        = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME   = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD   = azurerm_container_registry.acr.admin_password
  }

  https_only = true
}
