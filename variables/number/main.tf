terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}

resource "local_file" "example" {
  content  = "Line count is ${var.line_count}"
  filename = "demo.txt"
}

