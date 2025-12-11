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
  admin_enabled       = false
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

  identity {
    type = "SystemAssigned"
  }
  site_config {
    application_stack {
	  docker_image_name   = "${azurerm_container_registry.acr.login_server}/${var.image_name}:${var.image_tag}"
    }
  }

  app_settings = {
    WEBSITES_PORT                     = "3000"
  }

  https_only = true
}
