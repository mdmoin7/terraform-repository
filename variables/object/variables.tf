variable "file_config" {
  type = object({
    name          = string
    content       = string
    append_header = bool
  })
  default = {
    append_header = false
    content       = "some content here"
    name          = "example.txt"
  }
}
