terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}

variable "file_count" {
  type    = number
  default = 3
}
variable "environment" {
  type    = string
  default = "dev"
}

resource "local_file" "copies" {
  count    = var.file_count
  content  = "This is copy number ${count.index + 1}" # 0,1,2
  filename = "copy_${count.index + 1}.txt"
}

resource "local_file" "prod_only" {
  count    = var.environment == "prod" ? 1 : 0
  content  = "This file only exists in production"
  filename = "prod_only.txt"
}

output "all_files" {
  value = local_file.copies[*].filename
}
