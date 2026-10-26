# Log Analytics Workspace for Container Insights and Monitoring
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.project_name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}
