resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Storage account
resource "azurerm_storage_account" "main" {
  name                     = "${var.project}${var.env}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  # restrict access to the frontend subnet and Azure services CDN
  network_rules {
    default_action             = ["Deny"]
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [azurerm_subnet.frontend.id]
  }
}
resource "azurerm_storage_container" "static" {
  name                  = "static"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "blob" # public read access for static assets (served via CDN)
}
resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
# CDN Endpoint for static assets
resource "azurerm_cdn_profile" "main" {
  name                = "${var.project}-${var.env}-cdn"
  resource_group_name = azurerm_resource_group.main.name
  location            = "global"
  sku                 = "Standard_Microsoft"
}
resource "azurerm_cdn_endpoint" "static" {
  name                = "${var.project}-${var.env}-cdn-endpoint"
  profile_name        = azurerm_cdn_profile.main.name
  resource_group_name = azurerm_resource_group.main.name
  location            = "global"
  origin {
    name       = "storage"
    host_name  = azurerm_storage_account.main.primary_blob_host
    http_port  = 80
    https_port = 443
  }
}
