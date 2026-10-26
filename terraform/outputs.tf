output "resource_group_name" {
  description = "Resource Group where all resources are provisioned."
  value       = azurerm_resource_group.rg.name
}

output "aks_cluster_name" {
  description = "Name of the provisioned AKS Cluster."
  value       = module.aks.cluster_name
}

output "aks_get_credentials_command" {
  description = "Run this Azure CLI command to configure kubectl context."
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${module.aks.cluster_name} --overwrite-existing"
}

output "acr_name" {
  description = "Azure Container Registry Name."
  value       = module.acr.acr_name
}

output "acr_login_server" {
  description = "URL of the Azure Container Registry."
  value       = module.acr.login_server
}

output "ingress_static_ip" {
  description = "Static Public IP assigned for NGINX Ingress Controller."
  value       = module.aks.ingress_public_ip
}

output "ingress_fqdn" {
  description = "Fully Qualified Domain Name for the Ingress Controller Public IP."
  value       = module.aks.ingress_fqdn
}

# output "log_analytics_workspace_id" {
#   description = "Log Analytics Workspace ID for monitoring and diagnostics."
#   value       = module.monitoring.workspace_id
# }
# 
# output "log_analytics_workspace_name" {
#   description = "Log Analytics Workspace Name."
#   value       = module.monitoring.workspace_name
# }

output "oidc_issuer_url" {
  description = "The OIDC issuer URL for Workload Identity."
  value       = module.aks.oidc_issuer_url
}

output "database_host" {
  description = "Host endpoint for the MySQL database."
  value       = var.enable_azure_mysql ? module.database[0].server_fqdn : "school-mysql.school-system.svc.cluster.local (In-Cluster Pod)"
}
