# Static Public IP for NGINX Ingress Controller
resource "azurerm_public_ip" "ingress_ip" {
  name                = "${var.project_name}-ingress-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "school-sms-${var.random_suffix}"
  tags                = var.tags
}

# Azure Kubernetes Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
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
    vnet_subnet_id      = var.aks_subnet_id
    enable_auto_scaling = true
    node_count          = var.node_count
    min_count           = var.node_count_min
    max_count           = var.node_count_max
    os_disk_size_gb     = 50
    os_disk_type        = "Managed"
    type                = "VirtualMachineScaleSets"

    tags = var.tags
  }

  # Networking Configuration: Azure CNI Overlay
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"
    load_balancer_sku   = "standard"
  }

  # Cloud-Native Identity Features
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # Azure Monitor / Container Insights Monitoring (Log Analytics) - Commented out for now
  # oms_agent {
  #   log_analytics_workspace_id = var.log_analytics_workspace_id
  # }

  # Azure Key Vault Secrets Store CSI Driver Add-on
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  tags = var.tags
}

# Attach ACR to AKS with AcrPull role (Passwordless image pull)
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}

# Allow AKS Managed Identity to manage the Public IP in the Resource Group
resource "azurerm_role_assignment" "aks_network_contributor" {
  principal_id                     = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name             = "Network Contributor"
  scope                            = var.resource_group_id
  skip_service_principal_aad_check = true
}

# Optional Diagnostic Setting: Stream AKS Control Plane logs to Log Analytics Workspace - Commented out for now
# resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics" {
#   name                       = "${var.project_name}-aks-diag"
#   target_resource_id         = azurerm_kubernetes_cluster.aks.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id
# 
#   enabled_log {
#     category = "kube-apiserver"
#   }
# 
#   enabled_log {
#     category = "kube-controller-manager"
#   }
# 
#   enabled_log {
#     category = "cluster-autoscaler"
#   }
# 
#   metric {
#     category = "AllMetrics"
#     enabled  = true
#   }
# }
