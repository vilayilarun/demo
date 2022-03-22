# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
# Create a resource group
resource "azurerm_resource_group" "hercules" {
  name     = "hercules"
  location = "South India"
}
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "mac1" {
    name = var.vnet-name
    location = azurerm_resource_group.hercules.location
    resource_group_name = azurerm_resource_group.hercules.name
    address_space = var.vent-addres
}
# Create a subnet inside the vnet
resource "azurerm_subnet" "mac-subnet" {
  name = var.subnet-name
  resource_group_name = azurerm_resource_group.hercules.name
  address_prefix = var.subnet-pre
  virtual_network_name = azurerm_virtual_network.mac1.name
 }
 # create a network interface
 resource "azurerm_network_interface" "node-net-if" {
   name = var.inetrface-name
   location = azurerm_resource_group.hercules.location
   resource_group_name = azurerm_resource_group.hercules.name
   ip_configuration {
     name = "internal"
     subnet_id = azurerm_subnet.mac-subnet.id
     private_ip_address_allocation = "Dynamic"
   }
 }
 # create a Linux virtual machine 
 resource "azurerm_linux_virtual_machine" "node1" {
   name = var.vm-name
   resource_group_name = azurerm_resource_group.hercules.name
   location = azurerm_resource_group.hercules.location
   size = var.instance-type
   admin_username = "customer"
   network_interface_ids = [azurerm_network_interface.node-net-if.id]
   admin_ssh_key {
     username = "customer"
     public_key = file("~/.ssh/id_rsa.pub")
   }
   os_disk {
     caching = "ReadWrite"
     sstorage_account_type = "Standard_LRS"
   }
   source_image_reference {
   publisher = "Canonical"
   offer = "UbuntuServer"
   sku = "20.04-LTS"
   version = "latest"  
   }
 }