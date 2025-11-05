###############################################################################
# ⚙️ variables.tf
# Define las variables reutilizables de la infraestructura.
# Las variables permiten parametrizar sin modificar el código fuente.
###############################################################################

# 🌍 Región del despliegue
variable "location" {
  type        = string
  description = "Región de Azure donde se crearán los recursos"
  default     = "eastus"
}

# 🏢 Nombre del Resource Group
variable "resource_group_name" {
  type        = string
  description = "Nombre del grupo de recursos principal"
  default     = "rg-terraform-lab"
}

# 💾 Nombre del Storage Account (debe ser único globalmente)
variable "storage_account_name" {
  type        = string
  description = "Nombre del Storage Account"
  default     = "stterraformdemo01"
}

# 📦 Nombre del contenedor de blobs
variable "blob_container_name" {
  type        = string
  description = "Nombre del contenedor dentro del Storage Account"
  default     = "container-demo"
}

# 🧑‍💻 Etiqueta de propietario (para auditoría)
variable "owner" {
  type        = string
  description = "Nombre o correo del responsable de la infraestructura"
  default     = "alfredo.tornero@scharff.com.pe"
}

# 🧩 Ambiente (dev, qa, prod)
variable "environment" {
  type        = string
  description = "Ambiente de despliegue"
  default     = "dev"
}
