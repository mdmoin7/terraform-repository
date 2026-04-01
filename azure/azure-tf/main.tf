
resource "azurerm_resource_group" "main" {
  name     = "${var.project}-${var.env}-rg"
  location = var.location
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  project             = var.project
  env                 = var.env
}

module "storage" {
  source              = "./modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  project             = var.project
  env                 = var.env
}

module "database" {
  source              = "./modules/database"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  project             = var.project
  env                 = var.env
  db_subnet_id        = module.networking.database_subnet_id
  private_dns_zone_id = module.networking.sql_dns_zone_id
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  project             = var.project
  env                 = var.env
  frontend_subnet_id  = module.networking.frontend_subnet_id
  lb_backend_pool_id  = module.networking.lb_backend_pool_id
  lb_probe_id         = module.networking.lb_probe_id
  app_insights_key    = module.monitoring.app_insights_key
  sql_connection_str  = module.database.connection_string
}

module "monitoring" {
  source              = "./modules/monitoring"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  project             = var.project
  env                 = var.env
  vmss_id             = module.compute.vmss_id
  alert_email         = var.alert_email
}
