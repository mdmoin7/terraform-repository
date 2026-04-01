variable "resource_group_name" {
  type    = string
  default = "rg-vm-demo"
}
variable "location" {
  type    = string
  default = "westeurope"
}
variable "tags" {
  type = map(string)
  default = {
    "environment" = "dev"
    "managed_by"  = "terraform"
  }
}
variable "vnet_name" {
  type    = string
  default = "vmdemo"
}
variable "vnet_address_space" {
  type    = string
  default = "10.0.0.0/16"
}
variable "subnet_name" {
  type    = string
  default = "vmdemo"
}
variable "subnet_public_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
variable "subnet_private_cidr" {
  type    = string
  default = "10.0.2.0/24"
}
variable "nsg_name" {
  type    = string
  default = "vmdemo"
}
variable "allowed_ssh_cidr" {
  type    = string
  default = "*"
}
variable "vm_name" {
  type    = string
  default = "vmdemo"
}
variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}
variable "admin_username" {
  type    = string
  default = "azureuser"
}
variable "ssh_public_key" {
  type    = string
  default = ""
}
