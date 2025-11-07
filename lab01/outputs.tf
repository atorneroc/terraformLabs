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

###############################################################################
# 📤 Módulo 2 — Outputs
###############################################################################

output "acr_login_server" {
  description = "URL del Azure Container Registry"
  value       = azurerm_container_registry.acr_main.login_server
}

output "app_service_default_hostname" {
  description = "Dominio por defecto de la Web App"
  value       = azurerm_linux_web_app.app_main.default_hostname
}

output "key_vault_uri" {
  description = "URI público del Key Vault"
  value       = azurerm_key_vault.kv_main.vault_uri
}

output "webapp_url" {
  description = "URL de la Web App desplegada"
  value       = azurerm_linux_web_app.app_main.default_hostname
}

output "acr_name" {
  description = "Nombre del Azure Container Registry"
  value       = azurerm_container_registry.acr_main.name
}
