output "acr_login_server" {
  description = "Login server for ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "webapp_url" {
  description = "URL of the deployed Web App"
  value       = "https://${azurerm_linux_web_app.webapp.default_hostname}"
}
