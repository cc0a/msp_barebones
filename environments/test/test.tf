# environments/test.tf

# ============================
# Resource Group
# ============================
resource "azurerm_resource_group" "test_rg" {
  name     = "test-rg"
  location = var.location
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
# NICs for VMs
# ============================
resource "azurerm_network_interface" "nic_nginx" {
  name                = "nic-nginx"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.test_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

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
# Linux VMs
# ============================
resource "azurerm_linux_virtual_machine" "test_vm_nginx" {
  name                = "test-vm-nginx"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_nginx.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "test_vm_sql" {
  name                = "test-vm-sql"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_sql.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "test_vm_memcache" {
  name                = "test-vm-memcache"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_memcache.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# ============================
# Windows VM
# ============================
resource "azurerm_windows_virtual_machine" "test_vm_win2022_file_server" {
  name                = "test-vm-win2022"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = "P@ssw0rd1234!"   # ⚠️ Replace with a secure secret

  network_interface_ids = [
    azurerm_network_interface.nic_win2022.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

# ============================
# Azure Virtual Desktop Host Pools
# ============================
resource "azurerm_virtual_desktop_host_pool_01" "avd_hostpool" {
  name                = "avd-hostpool-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name

  type                      = "Pooled"
  load_balancer_type        = "BreadthFirst"
  preferred_app_group_type  = "Desktop"

  maximum_sessions_allowed = 10
  friendly_name            = "Test AVD Host Pool"

  resource "azurerm_virtual_desktop_host_pool_02" "avd_hostpool" {
  name                = "avd-hostpool-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name

  type                      = "Pooled"
  load_balancer_type        = "BreadthFirst"
  preferred_app_group_type  = "Desktop"

  maximum_sessions_allowed = 10
  friendly_name            = "Test AVD Host Pool"

  resource "azurerm_virtual_desktop_host_pool_03" "avd_hostpool" {
  name                = "avd-hostpool-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name

  type                      = "Pooled"
  load_balancer_type        = "BreadthFirst"
  preferred_app_group_type  = "Desktop"

  maximum_sessions_allowed = 10
  friendly_name            = "Test AVD Host Pool"
}