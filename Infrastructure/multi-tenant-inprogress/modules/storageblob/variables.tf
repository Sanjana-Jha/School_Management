variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "location" {
  description = "Azure region"
}

variable "storage_account_name" {
  description = "Name of the storage account"
}

variable "account_tier" {
  description = "Tier of the storage account"
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication type of the storage account"
  default     = "LRS"
}

variable "container_name" {
  description = "Name of the storage container"
}

variable "container_access_type" {
  description = "Access level for the storage container"
  default     = "private"
}
