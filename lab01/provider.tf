###############################################################################
# 📘 provider.tf
# Define el proveedor principal (AzureRM) y la configuración del backend remoto.
# Este archivo usa backend "azurerm" pero los parámetros específicos
# (key, storage account, container, etc.) se pasan dinámicamente
# mediante archivos backend.<env>.tfvars.
###############################################################################

terraform {
  # 🚀 Versión mínima requerida de Terraform CLI
  required_version = ">= 1.6.0"

  # 📦 Definición del proveedor de Azure
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Proveedor oficial de Azure
      version = "~> 4.51.0"         # Usa la versión estable 4.x
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.13"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.13"
    }
  }

  # ☁️ Backend remoto en Azure Storage
  # ⚠️ No se especifican valores aquí, se proporcionan al ejecutar:
  # terraform init -reconfigure -backend-config="backend/backend.dev.tfvars"
  backend "azurerm" {}
}

# 🔑 Configuración del proveedor AzureRM
# El bloque "features" es obligatorio aunque esté vacío.
provider "azurerm" {
  features {}

  # 💡 Autenticación en local con Azure CLI (az login)
  # y definición explícita de IDs para evitar ambigüedad
  subscription_id = "86462eaa-68cf-4d00-bac6-cd07b1968a49"
  tenant_id       = "d3acff10-5531-465c-b3fd-9186f2fab5cf"
}
