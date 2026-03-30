terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}

resource "local_file" "example" {
  content  = var.greeting
  filename = var.filename
}

resource "local_file" "interpolation" {
  content  = "The file name is ${var.filename}"
  filename = "interpolation.txt"

}
