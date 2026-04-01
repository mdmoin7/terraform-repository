output "sql_server_id" {
  value = azurerm_mssql_server.main.id
}
output "sql_fqdn" {
  value = azurerm_mssql_server.main.fully_qualified_domain_name
}
output "connection_string" {
  sensitive = true
  value     = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.main.name};Persist Security Info=False;User ID=sqladmin;Password=${random_password.sql.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}
