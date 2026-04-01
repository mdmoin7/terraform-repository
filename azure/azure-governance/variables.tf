variable "allowed_locations" {
  type        = list(string)
  description = "Regions where resources can be deployed"
  default     = ["westus", "centralindia", "West Europe"]
}

variable "app_service_user_id" {
  type        = string
  description = "Enter the user object id"
}
