variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "resource_group_id" {
  type        = string
  description = "ID of the resource group."
}

variable "location" {
  type        = string
  description = "Azure region for AKS."
}

variable "project_name" {
  type        = string
  description = "Project name prefix."
}

variable "random_suffix" {
  type        = string
  description = "Random suffix for unique naming."
}

variable "aks_subnet_id" {
  type        = string
  description = "ID of the AKS subnet."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of the Log Analytics Workspace for Container Insights & diagnostics."
  default     = null
}

variable "acr_id" {
  type        = string
  description = "ID of the Azure Container Registry for AcrPull role."
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for AKS."
  default     = null
}

variable "node_vm_size" {
  type        = string
  description = "VM SKU for the worker node pool."
  default     = "Standard_B2ms"
}

variable "node_count" {
  type        = number
  description = "Initial number of worker nodes."
  default     = 2
}

variable "node_count_min" {
  type        = number
  description = "Minimum node count for autoscaling."
  default     = 1
}

variable "node_count_max" {
  type        = number
  description = "Maximum node count for autoscaling."
  default     = 3
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}
