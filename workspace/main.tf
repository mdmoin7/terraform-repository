terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}

resource "local_file" "config" {
  filename = "${terraform.workspace}-config.txt"
  content  = "environment: ${terraform.workspace}"
}

resource "local_file" "replica" {
  count    = terraform.workspace == "prod" ? 3 : 1
  filename = "${terraform.workspace}-replica-${count.index + 1}.txt"
  content  = "replica number: ${count.index + 1} for environment: ${terraform.workspace}"
}
