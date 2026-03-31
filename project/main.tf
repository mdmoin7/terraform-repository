terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}

module "dev_files" {
  source = "./modules/file-set"

  base_dir = "${path.root}/config/dev"
  files    = var.dev_files
  label    = "dev-environment"
}

module "prod_files" {
  source          = "./modules/file-set"
  base_dir        = "${path.root}/config/prod"
  files           = var.prod_files
  label           = "prod-environment"
  create_manifest = false
}

resource "local_file" "summary" {
  filename = "${path.root}/config/summary.txt"
  content  = "Dev files: ${module.dev_files.file_count}\nProd files: ${module.prod_files.file_count}"
}
