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
    name        = "rg-msp-main"
    location    = "East US"
}

resource "azurerm_storage_account" "storage" {
    name                     = "main-devstorageacct"
    resource_group_name      = msp_main.rg.name
    location                 = random_office.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"    
}