terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Local Variables
locals {
  mysql_prefix    = "${var.name}-${var.env}"
  keyvault_prefix = "${var.name}-${var.env}"
  storage_prefix  = "${var.name}${var.env}"
  aks_prefix      = "${var.name}-${var.env}"
  common_tags = {
    Project     = "School-Management-System"
    Environment = var.env
    ManagedBy   = "Terraform"
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.name}-${var.env}-rg"
  location = var.location
  tags     = local.common_tags
}

data "azurerm_client_config" "current" {}

# Random Password Generation for Database Admin
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!@&()_+"
}

# Random Suffix for Globally Unique Names (Key Vault, Storage Account, MySQL Server)
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Azure Database for MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "${local.mysql_prefix}-mysql-${random_string.suffix.result}"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  version                = var.mysql_version
  administrator_login    = var.mysql_admin
  administrator_password = random_password.password.result
  sku_name               = var.mysql_sku
  backup_retention_days  = 7
  tags                   = local.common_tags

  lifecycle {
    ignore_changes = [
      zone,
      high_availability,
    ]
  }
}

resource "azurerm_mysql_flexible_server_firewall_rule" "allow_azure" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mysql_flexible_database" "school_db" {
  name                = var.mysql_database_name
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = "${local.storage_prefix}store${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.common_tags
}

# AKS (Azure Kubernetes Service) Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                      = "${local.aks_prefix}-aks"
  location                  = azurerm_resource_group.main.location
  resource_group_name       = azurerm_resource_group.main.name
  dns_prefix                = "${local.aks_prefix}-aks-dns"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  tags                      = local.common_tags

  default_node_pool {
    name            = "default"
    node_count      = var.aks_node_count
    vm_size         = var.aks_vm_size
    os_disk_size_gb = var.aks_os_disk_size_gb
    max_pods        = 110
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}

# Azure Key Vault
resource "azurerm_key_vault" "key_vault" {
  name                          = "${local.keyvault_prefix}-${random_string.suffix.result}-kv"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  enabled_for_disk_encryption   = true
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  public_network_access_enabled = true
  tags                          = local.common_tags

  depends_on = [
    azurerm_resource_group.main,
  ]
}

resource "azurerm_key_vault_access_policy" "key_vault" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Delete",
    "Get",
    "Set",
    "List",
    "Backup",
    "Recover",
    "Purge",
  ]
}

# Azure Key Vault Secrets
resource "azurerm_key_vault_secret" "mysql_password" {
  name         = "mysql-password"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.key_vault.id
  depends_on   = [azurerm_key_vault_access_policy.key_vault]
}

resource "azurerm_key_vault_secret" "mysql_host" {
  name         = "mysql-host"
  value        = azurerm_mysql_flexible_server.mysql.fqdn
  key_vault_id = azurerm_key_vault.key_vault.id
  depends_on   = [azurerm_key_vault_access_policy.key_vault]
}

resource "azurerm_key_vault_secret" "mysql_user" {
  name         = "mysql-user"
  value        = var.mysql_admin
  key_vault_id = azurerm_key_vault.key_vault.id
  depends_on   = [azurerm_key_vault_access_policy.key_vault]
}
