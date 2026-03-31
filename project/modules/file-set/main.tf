terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}

resource "local_file" "files" {
  for_each        = var.files
  content         = each.value
  file_permission = var.file_permission
  filename        = "${var.base_dir}/${each.key}"
}

#optional manifest file
resource "local_file" "manifest" {
  count           = var.create_manifest ? 1 : 0
  filename        = "${var.base_dir}/manifest.txt"
  content         = join("\n", [for f in keys(var.files) : "${var.label}: ${f}"])
  file_permission = var.file_permission
}
