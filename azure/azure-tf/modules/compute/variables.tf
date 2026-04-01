variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "project" { type = string }
variable "env" { type = string }
variable "frontend_subnet_id" { type = string }
variable "lb_backend_pool_id" { type = string }
variable "lb_probe_id" { type = string }
variable "app_insights_key" {
  type      = string
  sensitive = true
}
variable "sql_connection_str" {
  type      = string
  sensitive = true
}
