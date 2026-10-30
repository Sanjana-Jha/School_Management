terraform {
  backend "azurerm" {
    storage_account_name = "__storageaccountname__"
    container_name       = "__containername__"
    key                  = "terraform.tfstate"
    resource_group_name  = "__resourcegroupname__"
    access_key           = "__accesskey__"
  }
}