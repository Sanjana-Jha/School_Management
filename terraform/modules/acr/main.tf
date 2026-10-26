# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = "acrschool${var.random_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = true
  tags                = var.tags
}
