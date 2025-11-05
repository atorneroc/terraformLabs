###############################################################################
# 📘 provider.tf
# Define el proveedor principal (AzureRM) y la configuración del backend remoto.
# El backend remoto permite guardar el estado de Terraform en Azure Storage,
# garantizando control de versiones, bloqueo concurrente y consistencia del estado.
###############################################################################

terraform {
  # 🚀 Versión mínima requerida de Terraform CLI
  required_version = ">= 1.6.0"

  # 📦 Definición de los proveedores necesarios
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Proveedor oficial de Azure
      version = "~> 4.0"            # Usa la versión 4.x (estable para AzureRM)
    }
  }

  # ☁️ Configuración del backend remoto en Azure Storage
  # Este bloque NO crea los recursos, solo indica dónde guardar el state.
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"            # Grupo donde está el storage
    storage_account_name = "scharfftstate"         # Nombre único global del storage
    container_name       = "tfstate"               # Contenedor para los .tfstate
    key                  = "dev.terraform.tfstate" # Nombre del archivo remoto
  }
}

# 🔑 Configuración del proveedor de Azure
# El bloque 'features' es obligatorio aunque no tenga parámetros.
provider "azurerm" {
  features {}

  # 💡 Puedes definir el tenant o subscription manualmente si lo requieres:
  subscription_id = "86462eaa-68cf-4d00-bac6-cd07b1968a49"
  tenant_id       = "d3acff10-5531-465c-b3fd-9186f2fab5cf"
}
