variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "location" {
  description = "Azure region"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
}

variable "vm_size" {
  description = "Size of the VMs in the AKS cluster"
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk for nodes in the AKS cluster"
}

variable "client_id" {
  description = "Client ID for AKS authentication"
}

variable "client_secret" {
  description = "Client secret for AKS authentication"
}
