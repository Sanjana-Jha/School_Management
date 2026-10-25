# Azure Kubernetes Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.project_name}-dns"
  kubernetes_version  = var.kubernetes_version

  # Modern Identity Management
  identity {
    type = "SystemAssigned"
  }

  # Default System & User Node Pool
  default_node_pool {
    name                = "systempool"
    vm_size             = var.node_vm_size
    vnet_subnet_id      = azurerm_subnet.aks_subnet.id
    enable_auto_scaling = true
    node_count          = var.node_count
    min_count           = var.node_count_min
    max_count           = var.node_count_max
    os_disk_size_gb     = 50
    os_disk_type        = "Managed"
    type                = "VirtualMachineScaleSets"

    tags = var.tags
  }

  # Networking Configuration: Azure CNI Overlay (High-performance, saves IP addresses)
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"
    load_balancer_sku   = "standard"
  }

  # Modern Cloud-Native Identity Features
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # Azure Monitor / Container Insights Monitoring
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
  }

  # Azure Key Vault Secrets Store CSI Driver Add-on
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  tags = var.tags

  depends_on = [
    azurerm_subnet_network_security_group_association.aks_nsg_assoc
  ]
}

# Attach ACR to AKS with AcrPull role (Passwordless image pull)
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# Allow AKS Managed Identity to manage the Public IP in the Resource Group
resource "azurerm_role_assignment" "aks_network_contributor" {
  principal_id                     = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name             = "Network Contributor"
  scope                            = azurerm_resource_group.rg.id
  skip_service_principal_aad_check = true
}
