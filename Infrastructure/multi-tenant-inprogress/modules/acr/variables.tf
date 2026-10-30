variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "location" {
  description = "Azure region"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
}

variable "acr_sku" {
  description = "SKU (Pricing tier) of the Azure Container Registry"
  default     = "Basic"
}

variable "acr_admin_enabled" {
  description = "Specifies whether the admin user is enabled for the Azure Container Registry"
  default     = false
}
