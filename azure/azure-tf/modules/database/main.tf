resource "random_password" "sql" {
  length  = 16
  special = true
}
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}
# SQL Server
resource "azurerm_mssql_server" "main" {
  name                          = "${var.project}-${var.env}-sql-${random_string.suffix.result}"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  version                       = "12.0"
  administrator_login           = "sqladmin"
  administrator_login_password  = random_password.sql.result
  public_network_access_enabled = false # private endpoint only
}
# database
resource "azurerm_mssql_database" "main" {
  name           = "${var.project}-${var.env}-db"
  server_id      = azurerm_mssql_server.main.id
  sku_name       = "S0"
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 10
  zone_redundant = var.env == "prod" ? true : false # set true in prod
}
# Private Endpoint : SQL never touches the public network
resource "azurerm_private_endpoint" "sql" {
  name                = "${var.project}-${var.env}-sql-pe"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = azurerm_subnet.database.id
  private_service_connection {
    name                           = "sql-conn"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
  }
  private_dns_zone_group {
    name                 = "sql-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }
}
