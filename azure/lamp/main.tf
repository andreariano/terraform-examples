# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.21.0"
}

# Create a resource group
resource "azurerm_resource_group" "myresourcegroup" {
  name     = "terraformrg"
  location = "${var.location}"
}

# Create a random string of 6 chars to be used as fqdn
resource "random_string" "fqdn" {
  length  = 6
  special = false
  upper   = false
  number  = false
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "myvirtualnetwork" {
  name                = "terraformvnet"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  location            = "${azurerm_resource_group.myresourcegroup.location}"
  address_space       = ["10.0.0.0/16"]
}

# Create a subnet within the vnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "terraformsubnet"
  resource_group_name  = "${azurerm_resource_group.myresourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.myvirtualnetwork.name}"
  address_prefix       = "10.0.2.0/24"
}

# Create a public ip
resource "azurerm_public_ip" "myip" {
  name                = "terraformip"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  allocation_method   = "Dynamic"
  domain_name_label   = "${random_string.fqdn.result}"
}

# Create Security group
resource "azurerm_network_security_group" "mysg" {
  name = "terraformsg"
  location            = "${azurerm_resource_group.myresourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"

  security_rule {
    name                       = "terraformssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "terraformhttp"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# Create the network interface
resource "azurerm_network_interface" "mynic" {
  name                = "terraformnic"
  location            = "${azurerm_resource_group.myresourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"

  ip_configuration {
    name                          = "terraformnicip"
    subnet_id                     = "${azurerm_subnet.mysubnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.myip.id}"
  }
}

# Create the virtual machine
resource "azurerm_virtual_machine" "myvm" {
  name                  = "terraformvm"
  location              = "${azurerm_resource_group.myresourcegroup.location}"
  resource_group_name   = "${azurerm_resource_group.myresourcegroup.name}"
  network_interface_ids = ["${azurerm_network_interface.mynic.id}"]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "bitnami"
    offer     = "lampstack"
    sku       = "5-6"
    version   = "7.1.1901172006"
  }

  plan {
    name = "5-6"
    product = "lampstack"
    publisher = "bitnami"
  }

  storage_os_disk {
    name              = "terraformdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "terraformserver"
    admin_username = "${var.machineusername}"
    admin_password = "${var.machinepassword}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
 
}
