resource "random_password" "sql" {
  length  = 20
  special = true
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# ── SQL Server ────────────────────────────────────────────────────────────────
resource "azurerm_mssql_server" "main" {
  name                          = "${var.project}-${var.env}-sql-${random_string.suffix.result}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = "sqladmin"
  administrator_login_password  = random_password.sql.result
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false # private endpoint only
}

# ── Basic tier database — free 5 DTUs, 2 GB ───────────────────────────────────
resource "azurerm_mssql_database" "main" {
  name        = "${var.project}-${var.env}-db"
  server_id   = azurerm_mssql_server.main.id
  sku_name    = "Basic" # free tier: 5 DTUs, 2 GB max
  max_size_gb = 2

  short_term_retention_policy {
    retention_days           = 7
    backup_interval_in_hours = 12
  }
}

# ── Private Endpoint — SQL never exposed to public internet ───────────────────
resource "azurerm_private_endpoint" "sql" {
  name                = "${var.project}-${var.env}-sql-pe"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.db_subnet_id

  private_service_connection {
    name                           = "sql-conn"
    private_connection_resource_id = azurerm_mssql_server.main.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "sql-dns"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}
