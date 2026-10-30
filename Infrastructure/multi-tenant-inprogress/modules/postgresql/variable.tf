variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "location" {
  description = "Azure region"
}

variable "server_name" {
  description = "Name of the PostgreSQL server"
}

variable "postgresql_version" {
  description = "Version of PostgreSQL server"
  default     = "11"
}

variable "admin_username" {
  description = "Username for PostgreSQL admin"
}

variable "admin_password" {
  description = "Password for PostgreSQL admin"
}

variable "sku_name" {
  description = "Name of the SKU"
  default     = "B_Gen5_1"
}

variable "database_name" {
  description = "Name of the PostgreSQL database"
}
