# for : transformations
# for_each : iterations

# [for item in list : transform] : list transformation
# [for item in list : transform if condition] : list transformation with filter
# [for key, value in map : transform] : map transformation

variable "names" {
  type    = list(string)
  default = ["alice", "bob", "charlie"]
}
variable "scores" {
  type = map(number)
  default = {
    alice   = 85
    bob     = 90
    charlie = 58
  }
}
locals {
  # list : list transformation
  uppercase = [for n in var.names : upper(n)]
  # ["ALICE", "BOB", "CHARLIE"]
  # list : list transformation with filter
  long_names = [for n in var.names : n if length(n) > 3]
  # ["alice", "charlie"]
  # map : map transformation
  grades = {
    for name, score in var.scores :
    name => (score >= 60 ? "pass" : "fail")
  }
  # map : map transformation with filter
  passing_students = {
    for name, score in var.scores :
    name => score if score >= 60
  }
}
output "uppercase_names" {
  value = local.uppercase
}
output "long_names" {
  value = local.long_names
}
