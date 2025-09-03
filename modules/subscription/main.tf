# Each subscription is isolated per business domain - platform, Shared Services, Client environment

resource "azapi_resource" "subscription" {
  type      = "Microsoft.Subscription/aliases@2020-09-01"
  name      = "example-subscription"
  parent_id = var.billing_scope_id

  body = jsonencode({
    properties = {
      displayName = var.subscription_name
      workload    = "Production"
    }
  })
}