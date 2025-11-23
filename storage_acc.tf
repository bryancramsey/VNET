resource "azurerm_storage_account" "storage_account" {
  name                     = "STORAGE_ACCOUNT_NAME"
  resource_group_name      = azurerm_resource_group.vnet_rg.name
  location                 = azurerm_resource_group.vnet_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}