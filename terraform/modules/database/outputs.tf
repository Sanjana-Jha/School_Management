output "server_name" {
  description = "The name of the MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.mysql.name
}

output "server_fqdn" {
  description = "The FQDN of the MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.mysql.fqdn
}

output "database_name" {
  description = "The database name."
  value       = azurerm_mysql_flexible_database.school_sms_db.name
}
