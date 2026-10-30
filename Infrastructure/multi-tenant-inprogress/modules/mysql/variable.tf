variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "server_name" {
  description = "MySQL flexible server name"
  type        = string
}

variable "admin_username" {
  description = "MySQL administrator username"
  type        = string
  default     = "schooladmin"
}

variable "admin_password" {
  description = "MySQL administrator password"
  type        = string
}

variable "mysql_version" {
  description = "MySQL server version"
  type        = string
  default     = "8.0.21"
}

variable "sku_name" {
  description = "SKU for MySQL flexible server"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "database_name" {
  description = "Database name for School Management System"
  type        = string
  default     = "school_sms"
}

