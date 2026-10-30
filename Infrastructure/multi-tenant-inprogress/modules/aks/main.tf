resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name            = "default"
    node_count      = var.node_count
    vm_size         = var.vm_size
    os_disk_size_gb = var.os_disk_size_gb
    max_pods        = 110
  }

  dynamic "identity" {
    for_each = var.client_id == "" ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  dynamic "service_principal" {
    for_each = var.client_id != "" ? [1] : []
    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }

  network_profile {
    network_plugin = "azure"
  }
}
