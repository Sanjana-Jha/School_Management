output "resource_group_name" {
  description = "Resource Group where all resources are provisioned."
  value       = azurerm_resource_group.rg.name
}

output "aks_cluster_name" {
  description = "Name of the provisioned AKS Cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_get_credentials_command" {
  description = "Run this Azure CLI command to configure kubectl context."
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_kubernetes_cluster.aks.name} --overwrite-existing"
}

output "acr_name" {
  description = "Azure Container Registry Name."
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "URL of the Azure Container Registry."
  value       = azurerm_container_registry.acr.login_server
}

output "ingress_static_ip" {
  description = "Static Public IP assigned for NGINX Ingress Controller."
  value       = azurerm_public_ip.ingress_ip.ip_address
}

output "ingress_fqdn" {
  description = "Fully Qualified Domain Name for the Ingress Controller Public IP."
  value       = azurerm_public_ip.ingress_ip.fqdn
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL for Workload Identity."
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

output "database_host" {
  description = "Host endpoint for the MySQL database."
  value       = var.enable_azure_mysql ? azurerm_mysql_flexible_server.mysql[0].fqdn : "school-mysql.school-system.svc.cluster.local (In-Cluster Pod)"
}
