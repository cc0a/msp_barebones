# ============================
# User Interaction
# ============================

variable "inputname" {
    type = string
    description = "Set the name of the Resource Group"
}

# ============================
# Resource Group
# ============================
resource "azurerm_resource_group" "test_rg" {
  name     = "test-rg"
  location = var.location

  tags = {
    Name = inputname
  }
}

# ============================
# Networking
# ============================
resource "azurerm_virtual_network" "test_vnet" {
  name                = "test-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "test_subnet" {
  name                 = "test-subnet"
  resource_group_name  = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ============================
# NICs (no NIC for nginx anymore)
# ============================
resource "azurerm_network_interface" "nic_sql" {
  name                = "nic-sql"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.test_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic_memcache" {
  name                = "nic-memcache"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.test_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic_win2022" {
  name                = "nic-win2022"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.test_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# ============================
# AKS Cluster (nginx lives here)
# ============================
resource "azurerm_kubernetes_cluster" "aks_nginx" {
  name                = "aks-nginx-cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name
  dns_prefix          = "aksnginx"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_B2s"
    vnet_subnet_id  = azurerm_subnet.test_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

# ============================
# Kubernetes Provider (to deploy nginx)
# ============================
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks_nginx.kube_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_nginx.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks_nginx.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_nginx.kube_config[0].cluster_ca_certificate)
}

# ============================
# nginx Deployment + Service
# ============================
resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = "default"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 4

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
