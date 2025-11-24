###############################################################################
# 🏗️ main.tf
# Despliegue completo con integración ACR ↔ App Service ↔ Key Vault
# Entorno: DEV / QA / PROD (según tu .tfvars)
###############################################################################

###############################################################################
# 1️⃣ Resource Group
###############################################################################
resource "azurerm_resource_group" "rg_main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}

###############################################################################
# 2️⃣ Storage Account (para datos o blobs)
###############################################################################
resource "azurerm_storage_account" "st_demo" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg_main.name
  location                 = azurerm_resource_group.rg_main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}

###############################################################################
# 3️⃣ Blob Container
###############################################################################
resource "azurerm_storage_container" "sc_demo" {
  name                  = var.blob_container_name
  storage_account_id    = azurerm_storage_account.st_demo.id
  container_access_type = "private"
}

###############################################################################
# 4️⃣ Azure Container Registry (ACR)
###############################################################################
resource "azurerm_container_registry" "acr_main" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_resource_group.rg_main.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}

###############################################################################
# 5️⃣ Key Vault
# Se crea antes del App Service para poder referenciar secretos.
###############################################################################
resource "azurerm_key_vault" "kv_main" {
  name                       = var.key_vault_name
  resource_group_name        = azurerm_resource_group.rg_main.name
  location                   = azurerm_resource_group.rg_main.location
  tenant_id                  = "d3acff10-5531-465c-b3fd-9186f2fab5cf"
  sku_name                   = "standard"
  purge_protection_enabled   = false # ⚠️ Solo en entornos de prueba
  soft_delete_retention_days = 7

  # Access policy para tu usuario (solo laboratorio)
  access_policy {
    tenant_id          = "d3acff10-5531-465c-b3fd-9186f2fab5cf"
    object_id          = "dd01c782-54ef-4671-8e02-6a0ec8cec8f8" # ← tu Object ID real
    secret_permissions = ["Get", "List", "Set", "Delete"]
  }

  # ⚙️ Control de ciclo de vida
  lifecycle {
    prevent_destroy = false # Permite destruirlo sin restricciones
    ignore_changes  = []    # Puedes añadir campos que Terraform debe ignorar
  }

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}

###############################################################################
# 6️⃣ Key Vault Secret (ejemplo de API key o conexión)
###############################################################################
resource "azurerm_key_vault_secret" "api_key_secret" {
  name         = "API-SECRET"
  value        = var.api_secret_value
  key_vault_id = azurerm_key_vault.kv_main.id

  tags = {
    environment = var.environment
    owner       = var.owner
  }
}

###############################################################################
# 7️⃣ App Service Plan (Linux)
###############################################################################
resource "azurerm_service_plan" "asp_main" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_resource_group.rg_main.location
  os_type             = "Linux"
  sku_name            = "B1" # Básico (1 CPU / 1.75GB)

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}

###############################################################################
# 8️⃣ Web App (App Service Linux con contenedor ACR + Key Vault)
###############################################################################
resource "azurerm_linux_web_app" "app_main" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_resource_group.rg_main.location
  service_plan_id     = azurerm_service_plan.asp_main.id
  https_only          = true

  # Configuración del sitio
  site_config {
    always_on                         = true
    ftps_state                        = "Disabled"
    health_check_path                 = "/"
    health_check_eviction_time_in_min = 10

    # 🚀 Imagen Docker desde ACR
    application_stack {
      docker_image_name   = "nginx:latest" # Solo nombre + tag
      docker_registry_url = "https://${azurerm_container_registry.acr_main.login_server}"
    }
  }

  # Identidad gestionada (para ACR y Key Vault)
  identity {
    type = "SystemAssigned"
  }

  # Variables de entorno (App Settings)
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "ENVIRONMENT"                         = var.environment

    # 🔐 Referencia segura a Key Vault
    "API_KEY" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.api_key_secret.id})"

    # 📊 Integración con Application Insights
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.app_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.app_insights.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  }

  # Dependencias explícitas
  depends_on = [
    azurerm_key_vault_secret.api_key_secret
  ]

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}

###############################################################################
# 9️⃣ Espera a que la identidad del App Service esté propagada
###############################################################################
resource "time_sleep" "wait_for_identity" {
  depends_on      = [azurerm_linux_web_app.app_main]
  create_duration = "30s"
}

###############################################################################
# 🔟 Permitir que el App Service descargue imágenes del ACR (AcrPull)
###############################################################################
resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_linux_web_app.app_main.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr_main.id

  depends_on = [
    time_sleep.wait_for_identity,
    azurerm_container_registry.acr_main
  ]
}

###############################################################################
# 1️⃣1️⃣ Habilita el uso de Managed Identity para extraer imágenes del ACR
###############################################################################

resource "azapi_update_resource" "enable_acr_identity" {
  type                      = "Microsoft.Web/sites@2022-09-01"
  resource_id               = azurerm_linux_web_app.app_main.id

  body = jsonencode({
    properties = {
      siteConfig = {
        acrUseManagedIdentityCreds = true
      }
    }
  })

  depends_on = [
    azurerm_linux_web_app.app_main,
    azurerm_role_assignment.acr_pull,
    time_sleep.wait_for_identity
  ]
}

###############################################################################
# 1️⃣2️⃣ Permiso RBAC: App Service puede leer secretos del Key Vault
###############################################################################
resource "azurerm_role_assignment" "kv_reader" {
  principal_id         = azurerm_linux_web_app.app_main.identity[0].principal_id
  role_definition_name = "Key Vault Secrets User"
  scope                = azurerm_key_vault.kv_main.id

  depends_on = [
    azurerm_key_vault.kv_main,
    time_sleep.wait_for_identity
  ]
}
