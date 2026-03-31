terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}

resource "local_file" "critical" {
  filename = "critical.txt"
  content  = "This a critical file that should not be destroyed."
  lifecycle {
    prevent_destroy = true
  }
}
