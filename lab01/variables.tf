###############################################################################
# ⚙️ variables.tf
# Variables globales reutilizables en los distintos entornos (dev / qa / prod).
# No incluye valores por defecto para forzar el uso de archivos .tfvars.
###############################################################################

# 🌍 Región del despliegue
variable "location" {
  type        = string
  description = "Región de Azure donde se crearán los recursos (eastus, eastus2, etc.)"
}

# 🏢 Nombre del Resource Group
variable "resource_group_name" {
  type        = string
  description = "Nombre del grupo de recursos principal donde se crearán los componentes"
}

# 💾 Nombre del Storage Account
variable "storage_account_name" {
  type        = string
  description = "Nombre del Storage Account (debe ser único globalmente)"
}

# 📦 Nombre del contenedor de blobs
variable "blob_container_name" {
  type        = string
  description = "Nombre del contenedor dentro del Storage Account"
}

# 🧑‍💻 Etiqueta de propietario
variable "owner" {
  type        = string
  description = "Nombre o correo del responsable de la infraestructura"
}

# 🧩 Ambiente (dev, qa, prod)
variable "environment" {
  type        = string
  description = "Nombre del entorno de despliegue"
}
