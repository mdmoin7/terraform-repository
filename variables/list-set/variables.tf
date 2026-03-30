# list
variable "fruits" {
  type    = list(string)
  default = ["apple", "banana", "orange", "banana"]
}
# set
variable "environment" {
  type = set(string)
  # set does not allow duplicates, so "dev" is only listed once
  default = ["dev", "stage", "prod", "dev"]
}
