variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "school-dev-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "school-dev-aks"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "school-dev-aks-dns"
}

variable "node_count" {
  description = "Number of worker nodes in the AKS cluster"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "VM size for AKS worker nodes"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB for AKS worker nodes"
  type        = number
  default     = 30
}

variable "client_id" {
  description = "Client ID / App ID for AKS Service Principal"
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "Client Secret for AKS Service Principal"
  type        = string
  default     = ""
  sensitive   = true
}

variable "acr_name" {
  description = "Azure Container Registry name (alphanumeric only, 5-50 characters)"
  type        = string
  default     = "schooldevacr01"
}

variable "mysql_server_name" {
  description = "Name of the MySQL flexible server"
  type        = string
  default     = "school-dev-mysql"
}

variable "mysql_database_name" {
  description = "Primary database name for School Management System"
  type        = string
  default     = "school_sms"
}

variable "mysql_admin_username" {
  description = "MySQL administrator username"
  type        = string
  default     = "schooladmin"
}

variable "mysql_admin_password" {
  description = "MySQL administrator password"
  type        = string
  default     = "SchoolAdminSecurePass123!"
  sensitive   = true
}

variable "storage_account_name" {
  description = "Storage account name (alphanumeric lowercase, max 24 characters)"
  type        = string
  default     = "schooldevstore01"
}

variable "container_name" {
  description = "Blob container name"
  type        = string
  default     = "school-media"
}

