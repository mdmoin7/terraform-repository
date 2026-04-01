resource "azurerm_resource_group" "main" {
  name     = "${var.project}-${var.env}-rg"
  location = var.location
}

module "networking" {
  source = "./modules/networking"
}
module "database" {
  source = "./modules/database"
}
module "storage" {
  source = "./modules/storage"
}
module "compute" {
  source = "./modules/compute"
}
module "monitoring" {
  source = "./modules/monitoring"
}
