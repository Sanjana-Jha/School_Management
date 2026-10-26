variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "location" {
  type        = string
  description = "Azure region for ACR."
}

variable "random_suffix" {
  type        = string
  description = "Random string suffix for unique naming."
}

variable "acr_sku" {
  type        = string
  description = "SKU for Azure Container Registry."
  default     = "Basic"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}
