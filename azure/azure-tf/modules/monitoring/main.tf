# Analytics workspace for monitoring
resource "azurem_monitor_log_analytics_workspace" "main" {
  name                = "${var.project}-${var.env}-law"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
# Application Insights
resource "azurerm_monitor_application_insights" "main" {
  name                = "${var.project}-${var.env}-appinsights"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  application_type    = "web"
  workspace_id        = azurerm_monitor_log_analytics_workspace.main.id
}
