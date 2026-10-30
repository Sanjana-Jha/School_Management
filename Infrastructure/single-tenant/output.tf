# Outputs for School Management System - Single Tenant Infrastructure

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "mysql_server_id" {
  value = azurerm_mysql_flexible_server.mysql.id
}

output "mysql_server_name" {
  value = azurerm_mysql_flexible_server.mysql.name
}

output "mysql_server_fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "mysql_database_name" {
  value = azurerm_mysql_flexible_database.school_db.name
}

output "key_vault_id" {
  value = azurerm_key_vault.key_vault.id
}

output "key_vault_name" {
  value = azurerm_key_vault.key_vault.name
}

output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "aks_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
