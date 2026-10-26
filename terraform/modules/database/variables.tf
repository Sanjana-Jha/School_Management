variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "location" {
  type        = string
  description = "Azure region for MySQL."
}

variable "project_name" {
  type        = string
  description = "Project name prefix."
}

variable "random_suffix" {
  type        = string
  description = "Random suffix for unique naming."
}

variable "vnet_id" {
  type        = string
  description = "ID of the Virtual Network."
}

variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network."
}

variable "mysql_subnet_cidr" {
  type        = list(string)
  description = "CIDR range for delegated MySQL subnet."
  default     = ["10.240.4.0/24"]
}

variable "mysql_admin_username" {
  type        = string
  description = "Admin username for MySQL Flexible Server."
}

variable "mysql_admin_password" {
  type        = string
  description = "Admin password for MySQL Flexible Server."
  sensitive   = true
}

variable "mysql_sku_name" {
  type        = string
  description = "SKU for MySQL Flexible Server."
  default     = "B_Standard_B1ms"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}
