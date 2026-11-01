variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "school"
}

variable "env" {
  description = "Environment prefix for resources (e.g., dev, prod, uat)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Central US"
}

variable "aks_node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 1
}

variable "aks_vm_size" {
  description = "Size of the VMs in the AKS cluster"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "aks_os_disk_size_gb" {
  description = "Size of the OS disk for nodes in the AKS cluster"
  type        = number
  default     = 30
}

variable "mysql_admin" {
  description = "MySQL administrator username"
  type        = string
  default     = "schooladmin"
}

variable "mysql_sku" {
  description = "Azure Database for MySQL Flexible Server SKU"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "mysql_version" {
  description = "MySQL Server version"
  type        = string
  default     = "8.0.21"
}

variable "mysql_database_name" {
  description = "Primary database name for School Management System"
  type        = string
  default     = "school_sms"
}
