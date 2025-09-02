variable "rg_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-msp-main"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "subscription_name" {
  description = "Name of Client Assigned to subscription"
  type        = string
  default     = "Client-#"
}

resource "azurerm_virtual_network" "hub" {
  name                = "hub-vnet"
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "hub_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.255.0/27"]
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke"
  resource_group_name        = var.resource_group
  virtual_network_name       = azurerm_virtual_network.hub.name
  remote_virtual_network_id  = var.spoke_vnet_id
  allow_virtual_network_access = true
}