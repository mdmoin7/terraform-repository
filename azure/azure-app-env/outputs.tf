output "resource_group" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}
output "web_app_url" {
  description = "Public url of the web app"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}
output "web_app_name" {
  description = "Web app name (used with az webapp deploy)"
  value       = azurerm_linux_web_app.main.name
}
output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.main.name
}
output "sql_server_hostname" {
  description = "SQL server hostname"
  value       = azurerm_mssql_server.sql.fully_qualified_domain_name
}
output "sql_database_name" {
  description = "SQL database name"
  value       = azurerm_mssql_database.db.name
}
output "sql_user_name" {
  description = "SQL admin username"
  value       = var.sql_admin_user
}
output "sql_user_password" {
  description = "SQL admin password"
  value       = var.sql_admin_password
  sensitive   = true
}
