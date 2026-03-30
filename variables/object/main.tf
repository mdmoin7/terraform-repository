terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}
locals {
  body = var.file_config.append_header ? "Header: This is a header\n${var.file_config.content}" : var.file_config.content
}
resource "local_file" "example" {
  content  = local.body
  filename = var.file_config.name
}

output "body_content" {
  value     = local.body
  sensitive = true
}
