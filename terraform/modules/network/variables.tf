variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "location" {
  type        = string
  description = "Azure region for network resources."
}

variable "project_name" {
  type        = string
  description = "Project name prefix."
}

variable "vnet_cidr" {
  type        = list(string)
  description = "Address space for Virtual Network."
}

variable "aks_subnet_cidr" {
  type        = list(string)
  description = "CIDR range for AKS subnet."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}
