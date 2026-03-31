# default : first it'll destroy & than create the resource
# create_before_destroy : first it'll create the resource & than destroy the old resource
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}
variable "config_name" {
  type    = string
  default = "v1"
}

resource "local_file" "config" {
  filename = "config-${var.config_name}.txt"
  content  = "version: ${var.config_name}"
  lifecycle {
    create_before_destroy = true
  }
}
# terraform apply
# terraform apply -var="config_name=v2"
