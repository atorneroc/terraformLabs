###############################################################################
# 🏗️ main.tf
# Archivo principal de recursos — aquí se definen los recursos reales en Azure.
# Este ejemplo crea:
#   1. Un Resource Group (RG)
#   2. Un Storage Account
#   3. Un contenedor dentro del Storage (blob container) Test
###############################################################################

# 1️⃣ Resource Group: contenedor lógico de recursos Azure
resource "azurerm_resource_group" "rg_main" {
  name     = var.resource_group_name # Nombre desde variables.tf
  location = var.location            # Región (eastus, westus, etc.)

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}

# 2️⃣ Storage Account: almacenamiento general (para logs, tfstate, etc.)
resource "azurerm_storage_account" "st_demo" {
  name                     = var.storage_account_name # Debe ser único global
  resource_group_name      = azurerm_resource_group.rg_main.name
  location                 = azurerm_resource_group.rg_main.location
  account_tier             = "Standard" # Nivel de rendimiento
  account_replication_type = "LRS"      # Replicación local
  min_tls_version          = "TLS1_2"   # Cumplimiento seguridad

  # 🔐 Configuraciones adicionales de seguridad recomendadas
  allow_nested_items_to_be_public = false # Evitar blobs públicos
  public_network_access_enabled   = true  # Podría limitarse por red

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}

# 3️⃣ Contenedor de blobs (para almacenar archivos dentro del Storage)
resource "azurerm_storage_container" "sc_demo" {
  name                  = var.blob_container_name
  storage_account_id    = azurerm_storage_account.st_demo.id
  container_access_type = "private" # Opciones: private, blob, container
}
