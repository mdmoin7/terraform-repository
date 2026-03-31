variable "base_dir" {
  type        = string
  description = "Directory to write files into"
}
variable "files" {
  type        = map(string)
  description = "Map of file names => contents"
}
variable "file_permission" {
  type        = string
  description = "File permission to set on created files (e.g., '0644')"
  default     = "0644"
}
# optional manifest file
variable "create_manifest" {
  type        = bool
  description = "Whether to create a manifest file listing all created files"
  default     = true
}
variable "label" {
  type        = string
  description = "label to be used in manifest header"
  default     = "file-set"
  validation {
    condition     = length(var.label) > 5
    error_message = "label must be at least 5 characters"
  }
}
