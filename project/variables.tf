variable "dev_files" {
  type = map(string)
  default = {
    "app.conf" = "debug=true\nport=8080",
    "db.conf"  = "host=localhost\nport=5432"
  }
}

variable "prod_files" {
  type = map(string)
  default = {
    "app.conf"   = "debug=false\nport=8080",
    "db.conf"    = "host=db.host\nport=5432"
    "readme.txt" = "This is the production configuration set."
  }
}
