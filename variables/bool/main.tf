terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}
# local variables
locals {
  header = var.include_header ? "Header included" : "Header not included"
}

resource "local_file" "example" {
  content  = local.header
  filename = "demo.txt"
  lifecycle {
    # create_before_destroy = false
    # prevent_destroy = false
    # ignore_changes = [ attribute1, attribute2 ]
  }
}

