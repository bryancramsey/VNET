## Configures remote state storage in Azure, rather than storing Terraform state locally. ##
terraform {
  backend "azurerm" {
    resource_group_name = "vnet_rg"
    storage_account_name = "STORAGE_ACCOUNT_NAME"
    container_name = "tfstate"
    key = "dev.terraform.tfstate"
  }
}