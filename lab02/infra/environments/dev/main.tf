# 1) Resource Group
module "resource_group" {
  source = "../../modules/resource_group"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# 2) Network (solo para AKS)
module "network" {
  source = "../../modules/network"

  resource_group_name = module.resource_group.name
  location            = var.location

  vnet_name       = var.vnet_name
  vnet_cidr       = var.vnet_cidr
  aks_subnet_name = var.aks_subnet_name
  aks_subnet_cidr = var.aks_subnet_cidr

  tags = var.tags
}

# 3) AKS
module "aks" {
  source = "../../modules/aks"

  aks_name            = var.aks_name
  resource_group_name = module.resource_group.name
  location            = var.location
  aks_dns_prefix      = var.aks_dns_prefix

  kubernetes_version = var.kubernetes_version
  node_vm_size       = var.node_vm_size
  node_count         = var.node_count
  subnet_id          = module.network.aks_subnet_id

  tags = var.tags
}

# 4) API Management (público)
module "apim" {
  source = "../../modules/apim"

  apim_name            = var.apim_name
  resource_group_name  = module.resource_group.name
  location             = var.location
  publisher_name       = var.apim_publisher_name
  publisher_email      = var.apim_publisher_email
  sku_name             = var.apim_sku_name

  tags = var.tags
}

# 5) PostgreSQL Flexible (público)
module "postgres" {
  source = "../../modules/postgres"

  pg_name                = var.pg_name
  resource_group_name    = module.resource_group.name
  location               = var.location
  admin_login            = var.pg_admin_login
  admin_password         = var.pg_admin_password
  sku_name               = var.pg_sku_name
  storage_mb             = var.pg_storage_mb
  pg_version             = var.pg_version
  ha_enabled             = var.pg_ha_enabled
  zone                   = var.pg_zone
  tags = var.tags
}

# 6) Function App Billing
module "func_billing" {
  source = "../../modules/function_app"

  resource_group_name   = module.resource_group.name
  location              = var.location
  func_name             = var.func_billing_name
  storage_account_name  = var.func_billing_storage_name
  plan_sku_name         = "Y1"

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = "dev"
    "FUNCTION_ROLE"          = "billing"
  }

  tags = var.tags
}

# 7) Function App Util
module "func_util" {
  source = "../../modules/function_app"

  resource_group_name   = module.resource_group.name
  location              = var.location
  func_name             = var.func_util_name
  storage_account_name  = var.func_util_storage_name
  plan_sku_name         = "Y1"

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = "dev"
    "FUNCTION_ROLE"          = "util"
  }

  tags = var.tags
}

# 8) Function App Reports
module "func_reports" {
  source = "../../modules/function_app"

  resource_group_name   = module.resource_group.name
  location              = var.location
  func_name             = var.func_reports_name
  storage_account_name  = var.func_reports_storage_name
  plan_sku_name         = "Y1"

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = "dev"
    "FUNCTION_ROLE"          = "reports"
  }

  tags = var.tags
}
