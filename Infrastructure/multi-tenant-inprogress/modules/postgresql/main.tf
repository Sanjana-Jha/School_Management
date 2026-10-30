resource "azurerm_postgresql_server" "postgresql" {
  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.postgresql_version
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  sku_name                     = var.sku_name
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "postgresql_db" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
