variable "file_contents" {
  type = map(string)
  default = {
    "notes.txt" = "some readme content"
    "todo.txt"  = "some todo content"
  }
}
