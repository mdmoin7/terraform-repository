output "file_count" {
  description = "Number of content files created"
  value       = length(local_file.files)
}
output "manifest_path" {
  description = "path to manifest.txt or null if disabled"
  value       = one(local_file.manifest[*].filename)
}
output "base_dir" {
  description = "The base directory where the files are created"
  value       = var.base_dir
}
