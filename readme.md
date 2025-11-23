# Overview
This terraform project allows you to quickly provision virtual networks, subnets, and VMs on Azure. By default, the project configures two virtual networks, which each have one subnet and one VM. You can very easily provision more networks, subnets, or VMs by adding only a few lines of code to either vm.tf or network.tf, as the provisioning of each resource is done with for_each, allowing for easy scalability.

**NOTE:** Only the first two virtual networks have peering configured by default. For any additional virtual networks, peerings will need to be manually provisioned.


The project was based off of [this](https://www.youtube.com/watch?v=NFi4XIFSJqc) tutorial YouTube video.

## Steps
1. Install [Terraform](https://developer.hashicorp.com/terraform/install) and [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
2. Run backend.sh, note the name given to the storage account in Azure portal and change the value on line 5 of backend.tf and line 2 of storage_acc.tf to match
3. Import the vnet_rg and storage_account resources to bring them under the control of Terraform
4. `terraform init` to initialize the terraform project
5. `terraform plan` to verify the configuration and ensure the correct resources are going to be provisioned
6. `terraform apply` to execute the project and actually provision the resources
