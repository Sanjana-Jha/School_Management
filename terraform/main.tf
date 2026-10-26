# 1. Random suffix for globally unique resource names (ACR, Ingress DNS, MySQL)
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# 2. Primary Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# 3. Network Module (VNet, Subnets, NSG)
module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  project_name        = var.project_name
  vnet_cidr           = var.vnet_cidr
  aks_subnet_cidr     = var.aks_subnet_cidr
  tags                = var.tags
}

# 4. Monitoring Module (Log Analytics Workspace) - Commented out for now
# module "monitoring" {
#   source              = "./modules/monitoring"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   project_name        = var.project_name
#   log_analytics_sku   = "PerGB2018"
#   retention_in_days   = 30
#   tags                = var.tags
# }

# 5. ACR Module (Azure Container Registry)
module "acr" {
  source              = "./modules/acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  random_suffix       = random_string.suffix.result
  acr_sku             = var.acr_sku
  tags                = var.tags
}

# 6. AKS Module (Cluster, Managed Identities, Ingress Public IP, ACR Role Assignment, Container Insights)
module "aks" {
  source              = "./modules/aks"
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_id   = azurerm_resource_group.rg.id
  location            = azurerm_resource_group.rg.location
  project_name        = var.project_name
  random_suffix       = random_string.suffix.result
  aks_subnet_id       = module.network.aks_subnet_id
  # log_analytics_workspace_id = module.monitoring.workspace_id
  acr_id             = module.acr.acr_id
  kubernetes_version = var.kubernetes_version
  node_vm_size       = var.node_vm_size
  node_count         = var.node_count
  node_count_min     = var.node_count_min
  node_count_max     = var.node_count_max
  tags               = var.tags
}

# 7. Database Module (Optional: Azure Database for MySQL Flexible Server)
module "database" {
  count                = var.enable_azure_mysql ? 1 : 0
  source               = "./modules/database"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  project_name         = var.project_name
  random_suffix        = random_string.suffix.result
  vnet_id              = module.network.vnet_id
  vnet_name            = module.network.vnet_name
  mysql_admin_username = var.mysql_admin_username
  mysql_admin_password = var.mysql_admin_password
  mysql_sku_name       = var.mysql_sku_name
  tags                 = var.tags
}
