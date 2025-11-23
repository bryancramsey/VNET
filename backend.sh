#!/bin/bash
# FROM https://github.com/piyushsachdeva/Terraform-Full-Course-Azure/blob/main/lessons/day04/backend.sh

RESOURCE_GROUP_NAME=vnet_rg
STORAGE_ACCOUNT_NAME=vnetproj$RANDOM
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME