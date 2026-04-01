output "sql_server_id" { value = azurerm_mssql_server.main.id }
output "sql_fqdn" {
  value     = azurerm_mssql_server.main.fully_qualified_domain_name
  sensitive = true
}
output "connection_string" {
  sensitive = true
  value     = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Database=${azurerm_mssql_database.main.name};User ID=sqladmin;Password=${random_password.sql.result};Encrypt=True;"
}
