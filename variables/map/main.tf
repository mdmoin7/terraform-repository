terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}
locals {
  filename = "notes.txt"
}
resource "local_file" "example" {
  for_each = var.file_contents
  content  = each.value
  filename = each.key
}
