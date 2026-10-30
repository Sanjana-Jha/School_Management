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

# Local Variables
locals {
  prefix = "${var.name}${var.env}"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.name}-${var.env}-rg"
  location = var.location

  tags = {
    Project     = "School-Management-System"
    Environment = var.env
    ManagedBy   = "Terraform"
  }
}

data "azurerm_client_config" "current" {}

# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = "${local.prefix}acr01"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    Project     = "School-Management-System"
    Environment = var.env
    ManagedBy   = "Terraform"
  }
}
