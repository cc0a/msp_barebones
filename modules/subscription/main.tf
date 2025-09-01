# Each subscription is isolated per business domain - platform, Shared Services, Client environment

resource "azurerm_subscription" "client_sub" {
  subscription_name = var.subscription_name
  billing_scope_id  = var.billing_scope_id
  management_group_id = var.management_group_id
}