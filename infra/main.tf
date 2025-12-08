##############################################
# Resource Group
##############################################

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

##############################################
# Azure Container Registry
##############################################

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"

  # Enabled for simplicity; in real-world you would often use managed identity instead
  admin_enabled       = true
}

##############################################
# App Service Plan (Linux)
##############################################

resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  os_type  = "Linux"
  sku_name = "B1" # Basic, cost-effective for demo
}

##############################################
# Web App for Containers (Linux)
##############################################

resource "azurerm_linux_web_app" "webapp" {
  name                = var.web_app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      docker_image_name = "${azurerm_container_registry.acr.login_server}/demo-app:latest"
    }
  }

  app_settings = {
    # Required so App Service knows which port the container listens on
    WEBSITES_PORT = "3000"

    # ACR credentials (simple demo approach using admin user)
    DOCKER_REGISTRY_SERVER_URL      = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password

    # Optional: for logging
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  }

  https_only = true
}
