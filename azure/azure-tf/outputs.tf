output "load_balancer_ip" { value = module.networking.lb_public_ip }
output "storage_url" { value = module.storage.static_url }
output "sql_fqdn" {
  value     = module.database.sql_fqdn
  sensitive = true
}
output "app_insights_key" {
  value     = module.monitoring.app_insights_key
  sensitive = true
}
