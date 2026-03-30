terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}

resource "local_file" "hello" {
  content  = "Hello, Terraform!"
  filename = var.filename
}
# terraform init
# terraform plan
# terraform apply
# yes
