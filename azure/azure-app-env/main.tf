
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}
# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${random_string.suffix.result}1-devtest"
  location = var.location
}
# App Service Plan
resource "azurerm_service_plan" "main" {
  location            = azurerm_resource_group.main.location
  sku_name            = "F1"
  os_type             = "Linux"
  name                = "asp-${random_string.suffix.result}-devtest"
  resource_group_name = azurerm_resource_group.main.name
}
# Web App (linux)
resource "azurerm_linux_web_app" "main" {
  # count = env == "linux" ? 1 : 0
  site_config {
    always_on = false # must be false on B1 free tier
    application_stack {
      node_version = "20-lts"
    }
  }
  location            = azurerm_resource_group.main.location
  name                = "app-${var.project}-devtest"
  service_plan_id     = azurerm_service_plan.main.id
  resource_group_name = azurerm_resource_group.main.name
}
# storage
resource "azurerm_storage_account" "main" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  resource_group_name      = azurerm_resource_group.main.name
  name                     = "st${random_string.suffix.result}devtest"
  location                 = azurerm_resource_group.main.location
}
# a blob container for app uploads/assets
resource "azurerm_storage_container" "main" {
  name                  = "assets"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
# tfstate storage container (for remote state) - can be in a different storage account, but for simplicity we are using the same one here
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
# database server
resource "azurerm_mssql_server" "sql" {
  version                      = "12.0"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  name                         = "sql-${random_string.suffix.result}-devtest"
  administrator_login          = var.sql_admin_user
  administrator_login_password = var.sql_admin_password
}
# database
resource "azurerm_mssql_database" "db" {
  name      = "db-${var.project}-devtest"
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "Basic"
}
