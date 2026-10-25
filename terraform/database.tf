# Subnet for MySQL Flexible Server (delegated)
resource "azurerm_subnet" "mysql_subnet" {
  count                = var.enable_azure_mysql ? 1 : 0
  name                 = "snet-mysql"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.240.4.0/24"]

  delegation {
    name = "mysql-delegation"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Private DNS Zone for MySQL
resource "azurerm_private_dns_zone" "mysql_dns" {
  count               = var.enable_azure_mysql ? 1 : 0
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql_dns_link" {
  count                 = var.enable_azure_mysql ? 1 : 0
  name                  = "mysql-dns-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.mysql_dns[0].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.rg.name
}

# Azure Database for MySQL Flexible Server (Optional)
resource "azurerm_mysql_flexible_server" "mysql" {
  count                  = var.enable_azure_mysql ? 1 : 0
  name                   = "${var.project_name}-mysql-${random_string.suffix.result}"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password

  sku_name = var.mysql_sku_name
  version  = "8.0.21"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  delegated_subnet_id = azurerm_subnet.mysql_subnet[0].id
  private_dns_zone_id = azurerm_private_dns_zone.mysql_dns[0].id

  tags = var.tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.mysql_dns_link
  ]
}

# Default Database creation
resource "azurerm_mysql_flexible_database" "school_sms_db" {
  count               = var.enable_azure_mysql ? 1 : 0
  name                = "school_sms"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql[0].name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}
