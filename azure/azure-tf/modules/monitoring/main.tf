# ── Log Analytics — free 500 MB/day ──────────────────────────────────────────
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project}-${var.env}-law"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018" # free 500 MB/day ingestion
  retention_in_days   = 30
}

# ── Application Insights (backed by Log Analytics) ────────────────────────────
resource "azurerm_application_insights" "main" {
  name                = "${var.project}-${var.env}-ai"
  resource_group_name = var.resource_group_name
  location            = var.location
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
  retention_in_days   = 30
}

# ── Action Group: who gets paged ──────────────────────────────────────────────
resource "azurerm_monitor_action_group" "ops" {
  name                = "${var.project}-${var.env}-ag"
  resource_group_name = var.resource_group_name
  short_name          = "OpsAlert"

  email_receiver {
    name                    = "ops-email"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }
}

# ── Alert: CPU > 90% (Critical) ───────────────────────────────────────────────
resource "azurerm_monitor_metric_alert" "cpu" {
  name                = "${var.project}-${var.env}-cpu-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.vmss_id]
  description         = "CPU over 90% for 5 minutes"
  severity            = 0 # Critical

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action { action_group_id = azurerm_monitor_action_group.ops.id }
}
