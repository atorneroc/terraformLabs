###############################################################################
# 🏗️ main.tf
# Despliegue completo con conexión ACR → App Service (contenedor Linux)
###############################################################################

# 1️⃣ Resource Group
resource "azurerm_resource_group" "rg_main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}

# 2️⃣ Storage Account
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

# 3️⃣ Blob Container
resource "azurerm_storage_container" "sc_demo" {
  name                  = var.blob_container_name
  storage_account_id    = azurerm_storage_account.st_demo.id
  container_access_type = "private"
}

###############################################################################
# 🧩 Módulo 2 — Recursos principales de Azure
###############################################################################

# 4️⃣ Azure Container Registry
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

# 5️⃣ App Service Plan (Linux)
resource "azurerm_service_plan" "asp_main" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_resource_group.rg_main.location
  os_type             = "Linux"
  sku_name            = "B1"

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}

# 6️⃣ Web App (App Service Linux con contenedor del ACR)
resource "azurerm_linux_web_app" "app_main" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_resource_group.rg_main.location
  service_plan_id     = azurerm_service_plan.asp_main.id
  https_only          = true

  site_config {
    always_on                         = true
    ftps_state                        = "Disabled"
    health_check_path                 = "/"
    health_check_eviction_time_in_min = 10

    # 🚀 Contenedor Docker desde ACR
    application_stack {
      docker_image_name   = "nginx:latest"
      docker_registry_url = "https://${azurerm_container_registry.acr_main.login_server}"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "ENVIRONMENT"                         = var.environment
  }

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}

# 🕒 Espera a que la identidad esté propagada
resource "time_sleep" "wait_for_identity" {
  depends_on      = [azurerm_linux_web_app.app_main]
  create_duration = "30s"
}

# 7️⃣ Permitir que el App Service extraiga imágenes del ACR
resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_linux_web_app.app_main.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr_main.id

  depends_on = [
    time_sleep.wait_for_identity,
    azurerm_container_registry.acr_main
  ]
}

# 8️⃣Fuerza  la habilitación de acrUseManagedIdentityCreds
resource "azapi_update_resource" "enable_acr_identity" {
  type        = "Microsoft.Web/sites@2022-09-01"
  resource_id = azurerm_linux_web_app.app_main.id

  body = jsonencode({
    properties = {
      siteConfig = {
        acrUseManagedIdentityCreds = true
      }
    }
  })

  depends_on = [
    azurerm_role_assignment.acr_pull,
    time_sleep.wait_for_identity
  ]
}

# 8️⃣ Key Vault (opcional)
resource "azurerm_key_vault" "kv_main" {
  name                       = var.key_vault_name
  resource_group_name        = azurerm_resource_group.rg_main.name
  location                   = azurerm_resource_group.rg_main.location
  tenant_id                  = "d3acff10-5531-465c-b3fd-9186f2fab5cf"
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  access_policy {
    tenant_id          = "d3acff10-5531-465c-b3fd-9186f2fab5cf"
    object_id          = "dd01c782-54ef-4671-8e02-6a0ec8cec8f8"
    secret_permissions = ["Get", "List", "Set", "Delete"]
  }

  tags = {
    environment = var.environment
    owner       = var.owner
    project     = "terraform-lab"
  }
}
