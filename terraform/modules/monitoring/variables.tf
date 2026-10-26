variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "location" {
  type        = string
  description = "Azure region for Log Analytics Workspace."
}

variable "project_name" {
  type        = string
  description = "Project name prefix."
}

variable "log_analytics_sku" {
  type        = string
  description = "SKU for Log Analytics Workspace."
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = number
  description = "Retention period for logs in days."
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}
