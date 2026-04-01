data "azurerum_subscription" "current" {}

locals {
  subscription_scope = data.azurerum_subscription.current.subscription_id
}
