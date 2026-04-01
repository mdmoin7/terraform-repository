resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# ── Storage Account (LRS = cheapest, 5 GB free) ───────────────────────────────
resource "azurerm_storage_account" "main" {
  name                     = "${replace(var.project, "-", "")}${var.env}${random_string.suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # cheapest — use GRS in prod
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy { days = 7 }
  }
}

# ── Public container for static assets ───────────────────────────────────────
resource "azurerm_storage_container" "static" {
  name                  = "static"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "blob" # anonymous read — serves HTML, CSS, JS
}

# ── Private container for uploads ─────────────────────────────────────────────
resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
