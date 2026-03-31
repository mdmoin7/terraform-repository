variable "location" {
  type        = string
  description = "Azure Region"
  default     = "West Europe" # East US, West Europe, centralindia
}
variable "project" {
  type        = string
  description = "Project name to be used in resource naming"
  default     = "myapp"
}
variable "sql_admin_user" {
  type        = string
  description = "Admin username for the SQL server"
  default     = "sqladminuser"
}
variable "sql_admin_password" {
  type        = string
  description = "Admin password for the SQL server"
  sensitive   = true
}
