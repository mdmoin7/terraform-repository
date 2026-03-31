terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}

# locking a resource to prevent accidental modification or deletion
resource "local_file" "managed" {
  filename = "managed.txt"
  content  = "This file is managed by Terraform."
  lifecycle {
    ignore_changes = all #[content]
  }
}
