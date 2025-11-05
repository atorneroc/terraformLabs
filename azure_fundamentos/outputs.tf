###############################################################################
# 📤 outputs.tf
# Expone los valores relevantes después de la ejecución.
# Estos outputs pueden usarse en pipelines (por ejemplo, GitHub Actions)
# o como entradas para otros módulos.
###############################################################################

# 🔹 ID completo del Resource Group creado
output "resource_group_id" {
  description = "Identificador único del Resource Group creado"
  value       = azurerm_resource_group.rg_main.id
}

# 🔹 Nombre del Storage Account
output "storage_account_name" {
  description = "Nombre del Storage Account creado"
  value       = azurerm_storage_account.st_demo.name
}

# 🔹 URL primaria del Blob Service (útil para integraciones)
output "primary_blob_endpoint" {
  description = "Endpoint principal del Blob Storage"
  value       = azurerm_storage_account.st_demo.primary_blob_endpoint
}

# 🔹 Nombre del contenedor creado
output "container_name" {
  description = "Nombre del contenedor dentro del Storage"
  value       = azurerm_storage_container.sc_demo.name
}
