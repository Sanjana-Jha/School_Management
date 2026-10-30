output "mysql_server_id" {
  value = azurerm_mysql_flexible_server.mysql.id
}

output "mysql_server_fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "database_name" {
  value = azurerm_mysql_flexible_database.mysql_db.name
}

