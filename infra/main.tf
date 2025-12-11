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
  sku_name = "B1"
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
      # This tells App Service which image to pull
      docker_image_name = "${azurerm_container_registry.acr.login_server}/${var.image_name}:${var.image_tag}"
    }
  }

  app_settings = {
    # Port your container listens on
    WEBSITES_PORT = "3000"

    # ACR registry credentials (simple demo approach)
    DOCKER_REGISTRY_SERVER_URL      = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
  }

  https_only = true
}
