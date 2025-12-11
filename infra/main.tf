variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "uksouth"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "devops-demo-rg"
}

variable "acr_name" {
  description = "Azure Container Registry name (must be globally unique)"
  type        = string
  default     = "devopsdemoacr1234"
}

variable "app_service_plan_name" {
  description = "App Service Plan name"
  type        = string
  default     = "devops-demo-asp"
}

variable "web_app_name" {
  description = "Web App for Containers name"
  type        = string
  default     = "devops-demo-container-webapp"
}

variable "image_name" {
  description = "Container image name (repository) in ACR"
  type        = string
  default     = "demo-app"
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "latest"
}
