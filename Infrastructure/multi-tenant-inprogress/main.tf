terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "aks" {
  source              = "./modules/aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name
  dns_prefix          = var.dns_prefix
  node_count          = var.node_count
  vm_size             = var.vm_size
  client_id           = var.client_id
  client_secret       = var.client_secret
  os_disk_size_gb     = var.os_disk_size_gb
}

module "acr" {
  source              = "./modules/acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  acr_name            = var.acr_name
}

module "mysql" {
  source              = "./modules/mysql"
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = var.mysql_server_name
  database_name       = var.mysql_database_name
  admin_username      = var.mysql_admin_username
  admin_password      = var.mysql_admin_password
}

module "storage_blob" {
  source               = "./modules/storageblob"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_name = var.storage_account_name
  container_name       = var.container_name
}
