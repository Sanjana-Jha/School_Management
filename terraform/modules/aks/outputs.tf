output "cluster_id" {
  description = "The ID of the AKS Cluster."
  value       = azurerm_kubernetes_cluster.aks.id
}

output "cluster_name" {
  description = "The name of the AKS Cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL for Workload Identity."
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

output "kubelet_identity_object_id" {
  description = "The object ID of the Kubelet Managed Identity."
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "ingress_public_ip" {
  description = "Static Public IP for NGINX Ingress Controller."
  value       = azurerm_public_ip.ingress_ip.ip_address
}

output "ingress_fqdn" {
  description = "FQDN for the Ingress Controller Public IP."
  value       = azurerm_public_ip.ingress_ip.fqdn
}
