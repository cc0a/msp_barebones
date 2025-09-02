# Example client environment that uses the shared platform network

module "network" {
  source        = "../../modules/network"
  resource_group = "client01-rg"
  location       = "East US"
  spoke_vnet_id  = module.platform_network.hub_vnet_id
}