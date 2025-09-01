# RBAC, Keyvault, NSGs. etc...

resource "azurerm_policy_assignment" "deny_public_ip" {
  name                 = "deny-public-ip"
  scope                = var.subscription_id
  policy_definition_id = data.azurerm_policy_definition.deny_public_ip.id
}

resource "azurerm_role_assignment" "platform_admin" {
  scope                = var.management_group_id
  role_definition_name = "Owner"
  principal_id         = var.platform_admin_object_id
}