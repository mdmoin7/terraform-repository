output "storage_account_name" { value = azurerm_storage_account.main.name }
output "storage_account_key" {
  value     = azurerm_storage_account.main.primary_access_key
  sensitive = true
}
output "static_url" { value = "https://${azurerm_storage_account.main.name}.blob.core.windows.net/static" }
