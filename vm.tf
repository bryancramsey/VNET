locals {
  ## To add a new NIC, add a new entry into this map ##
  nics = {
    server1_nic = {
      name = "server1_nic"
      configuration_name = "nic_configuration"
      subnet_id = "vnet1_sn1"
      private_ip_address_allocation = "Dynamic"
    }
    server2_nic = {
      name = "server2_nic"
      configuration_name = "nic_configuration"
      subnet_id = "vnet2_sn1"
      private_ip_address_allocation = "Dynamic"
    }
  }

  ## To add a new server, add a new entry into this map ##
  servers = {
    server1 = {
      name = "server1"
      network_interface = "server1_nic"
      storage_disk_name = "myosdisk1"
      computer_name = "server1"
    }
    server2 = {
      name = "server2"
      network_interface = "server2_nic"
      storage_disk_name = "myosdisk2"
      computer_name = "server2"
    }
  }
}

## Create server NIC resource for each entry in the NIC map as defined in locals ##
resource "azurerm_network_interface" "server_nic" {
  for_each = local.nics

  name                = each.value.name
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name

  ip_configuration {
    name                          = each.value.configuration_name
    subnet_id                     = azurerm_subnet.subnet[each.value.subnet_id].id
    private_ip_address_allocation = each.value.private_ip_address_allocation
  }
}

## Create Server resource for each entry in the Server map as defined in locals ##
resource "azurerm_virtual_machine" "server" {
  for_each = local.servers

  name                  = each.value.name
  location              = azurerm_resource_group.vnet_rg.location
  resource_group_name   = azurerm_resource_group.vnet_rg.name
  network_interface_ids = [azurerm_network_interface.server_nic[each.value.network_interface].id]
  vm_size               = "Standard_A1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = each.value.storage_disk_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = each.value.computer_name
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}