variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default     = "Terraform"
}

variable "region" {
  description = "The Azure Region in which all resources in this example should be created"
  #default     = "Central India"
}


variable "subscriptionId" {}
variable "clientId" {}
variable "clientSecret" {}
variable "rgName" {
  default = "Terraform"
}
variable "tenantId" {}
variable "vmSize" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_B1s"
}
variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}
variable "admin_username" {
  description = "administrator user name"
  default     = "vmadmin"
}
variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
  default     = "18.04-LTS"
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}
variable "hostname" {
  description = "VM name referenced also in storage-related names."
  default="tf"
}
variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}
variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.1.0/24"
}
