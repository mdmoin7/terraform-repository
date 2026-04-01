output "app_insights_key" {
  value = azurerm_monitor_application_insights.maon.instrumentation_key
}
output "log_analystics_workspace_id" {
  value = azurem_monitor_log_analytics_workspace.main.id
}
