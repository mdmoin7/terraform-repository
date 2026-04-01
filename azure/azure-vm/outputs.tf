output "resource_group_name" {
  value = azurerm_resource_group.main.name
}
output "vnet_id" {
  value = azurerm_virtual_network.main.id
}
output "subnet_public_id" {
  value = azurerm_subnet.public.id
}
output "subnet_private_id" {
  value = azurerm_subnet.private.id
}
output "nsg_public_id" {
  value = azurerm_network_security_group.public.id
}
output "vm_id" {
  value = azurerm_linux_virtual_machine.main.id
}
output "nic_id" {
  value = azurerm_network_interface.vm.id
}
output "public_ip_address" {
  value = azurerm_public_ip.vm.ip_address
}
output "admin_user_name" {
  value = var.admin_username
}
