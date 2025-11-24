resource "azurerm_postgresql_flexible_server" "this" {
  name                = var.pg_name
  resource_group_name = var.resource_group_name
  location            = var.location
  zone                = var.zone

  administrator_login    = var.admin_login
  administrator_password = var.admin_password

  sku_name   = var.sku_name
  storage_mb = var.storage_mb
  version    = var.pg_version

  # Solo crear high_availability si ha_enabled = true
  dynamic "high_availability" {
    for_each = var.ha_enabled ? [1] : []
    content {
      mode = "ZoneRedundant"
    }
  }

  tags = var.tags
}
