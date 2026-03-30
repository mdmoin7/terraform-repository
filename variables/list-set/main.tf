terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.7.0"
    }
  }
}

resource "local_file" "example" {
  content = join(", ", var.fruits)
  # var.fruits[1]
  filename = "demo.txt"
}

resource "local_file" "demo" {
  content = join(", ", tolist(var.environment))
  # tolist(var.environment)[1]
  filename = "env.txt"
}
