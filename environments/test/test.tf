# environments/test.tf

resource "azurerm_resource_group" "test_rg" {
  name     = "test-rg"
  location = var.location
}

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

resource "azurerm_network_interface" "test_nic" {
  name                = "test-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.test_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "test_vm_nginx" {
  name                = "test-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.test_nic.id
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

  resource "azurerm_linux_virtual_machine" "test_vm_mservice01_sql" {
  name                = "test-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.test_nic.id
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

    resource "azurerm_linux_virtual_machine" "test_vm_mservice01_memcache" {
  name                = "test-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.test_nic.id
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

  resource "azurerm_windows_virtual_machine" "test_vm_win2022_file_server" {
  name                = "test-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = "P@ssw0rd1234!"   # ⚠️ Replace with a secure secret

  network_interface_ids = [
    azurerm_network_interface.test_nic.id
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