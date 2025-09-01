# Management Groups for organizing subscriptions + Policies at Scale

resource "azurerm_management_group" "root" {
  name        = "msp"
  display_name = "MSP Root"
}

resource "azurerm_management_group" "platform" {
  name        = "platform"
  display_name = "Platform Management"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "client" {
  name        = "clients"
  display_name = "Client Subscriptions"
  parent_management_group_id = azurerm_management_group.root.id
}