output "frontend_subnet_id" {
  value = azurerm_subnet.frontend.id
}
output "database_subnet_id" {
  value = azurerm_subnet.database.id
}
output "lb_public_ip" {
  value = azurerm_public_ip.lb.ip_address
}
output "lb_backend_pool_id" {
  value = azurerm_lb_backend_address_pool.main.id
}
output "lb_probe_id" {
  value = azurerm_lb_probe.http.id
}
output "sql_dns_zone_id" {
  value = azurerm_private_dns_zone.sql.id
}
