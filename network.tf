resource "azurerm_resource_group" "vnet_rg" {
  name     = "vnet_rg"
  location = "eastus"
}

locals {
  ## To add a new vnet, add a new entry into this map ##
  vnets = {
    vnet1 = {
      address_space       = ["10.0.0.0/16"]
    }
    vnet2 = {
      address_space       = ["192.168.1.0/24"]
    }
  }

  ## To add a subnet, add a new entry into this map ##
  subnets = {
    vnet1_sn1 = {
      address_prefixes     = ["10.0.0.0/18"]
      vnet = "vnet1"
    }
    vnet2_sn1 = {
      address_prefixes     = ["192.168.1.0/27"]
      vnet = "vnet2"
    }
  }
}

## Create vnet resource for each entry in the vnet map as defined in locals ##
resource "azurerm_virtual_network" "vnet" {
  for_each = local.vnets

  name = each.key
  address_space = each.value.address_space
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
}

## Create subnet resource for each entry in the subnet map as defined in locals ##
resource "azurerm_subnet" "subnet" {
  for_each = local.subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet].name
  address_prefixes     = each.value.address_prefixes
}

## VNET Peering - Manages a virtual network peering which allows resources to access other resources in the linked virtual network. ##
# VNET 1 to VNET 2 #
resource "azurerm_virtual_network_peering" "peer1to2" {
    name = "peer1to2"
    resource_group_name = azurerm_resource_group.vnet_rg.name
    virtual_network_name = azurerm_virtual_network.vnet["vnet1"].name
    remote_virtual_network_id = azurerm_virtual_network.vnet["vnet2"].id
}

# VNET 2 to VNET 1 #
resource "azurerm_virtual_network_peering" "peer2to1" {
    name = "peer2to1"
    resource_group_name = azurerm_resource_group.vnet_rg.name
    virtual_network_name = azurerm_virtual_network.vnet["vnet2"].name
    remote_virtual_network_id = azurerm_virtual_network.vnet["vnet1"].id
}