terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}# main.tf

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "rg" {
    name        = "rg-dev-main"
    location    = "East US"
}

resource "azurerm_storage_account" "storage" {
    name                     = "main-devstorageacct"
    resource_group_name      = dev_main.rg.name
    location                 = ny_office.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"    
}