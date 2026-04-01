resource "azurerm_role_definition" "app_service_operator" {
  name        = "AppServiceOperator"
  scope       = local.subscription_scope
  description = "Manage app service only"
  permissions {
    actions = [
      "Microsoft.Web/sites/*",
      "Microsoft.Web/serverfarms/*"
    ]
    not_actions = []
  }
  assignable_scopes = [local.subscription_scope]
}

resource "azurerm_role_assignment" "app_service_assignment" {
  role_definition_id = azurerm_role_definition.app_service_operator.id
  principal_id       = var.app_service_user_id # which user to assign the role to
  scope              = azurerm_resource_group.main.id
}
