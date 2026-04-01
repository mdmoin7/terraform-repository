resource "azurerm_policy_definition" "allowed_locations" {
  name         = "allowed-location-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Locations"
  description  = "This policy restricts the allowed locations for resource deployment."
  policy_rule = jsonencode({
    "if" : {
      "not" : {
        "field" : "location",
        "in" : "[parameters('allowedLocations')]"
      }
    },
    "then" : {
      "effect" : "deny"
    }
  })
  parameters = jsonencode({
    "allowedLocations" : {
      "type" : "Array",
      "metadata" : {
        "description" : "The list of allowed locations for resource deployment.",
        "displayName" : "Allowed Locations"
      }
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "allow_locations_assign" {
  name                 = "restrict-locations-assignment"
  resource_group_id    = azurerm_resource_group.main.id
  policy_definition_id = azurerm_policy_definition.allowed_locations.id
  parameters = jsonencode({
    "allowedLocations" : {
      "value" : var.allowed_locations
    }
  })
}
