variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group."
  default     = "school-system"
}

variable "location" {
  type        = string
  description = "Azure primary region for resource provisioning."
  default     = "centralindia"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, staging, prod)."
  default     = "prod"
}

variable "project_name" {
  type        = string
  description = "Identifier for the project used in naming conventions."
  default     = "school-sms"
}

# --- Network Configuration ---
variable "vnet_cidr" {
  type        = list(string)
  description = "Address space for the Virtual Network."
  default     = ["10.240.0.0/16"]
}

variable "aks_subnet_cidr" {
  type        = list(string)
  description = "Subnet CIDR dedicated for AKS Nodes and Pods (Azure CNI Overlay)."
  default     = ["10.240.0.0/22"]
}

# --- AKS Cluster Configuration ---
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for AKS (null picks latest Azure default)."
  default     = null
}

variable "node_vm_size" {
  type        = string
  description = "VM SKU for the default AKS worker node pool."
  default     = "Standard_B2ms" # 2 vCPU, 8 GiB RAM (Budget & Production friendly)
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

# --- Azure Container Registry (ACR) ---
variable "acr_sku" {
  type        = string
  description = "SKU for Azure Container Registry (Basic, Standard, Premium)."
  default     = "Basic"
}

# --- Database Options ---
variable "enable_azure_mysql" {
  type        = bool
  description = "If true, provisions Azure Database for MySQL Flexible Server. If false, runs MySQL inside AKS cluster using PVC (cost-saving)."
  default     = false
}

variable "mysql_admin_username" {
  type        = string
  description = "Administrator username for Azure MySQL Flexible Server."
  default     = "sms_admin"
}

variable "mysql_admin_password" {
  type        = string
  description = "Administrator password for Azure MySQL Flexible Server."
  sensitive   = true
  default     = null
}

variable "mysql_sku_name" {
  type        = string
  description = "SKU for Azure MySQL Flexible Server."
  default     = "B_Standard_B1ms"
}

# --- Resource Tags ---
variable "tags" {
  type        = map(string)
  description = "Common tags applied to all Azure resources."
  default = {
    Project     = "School-Management-System"
    ManagedBy   = "Terraform"
    Environment = "Production"
  }
}
