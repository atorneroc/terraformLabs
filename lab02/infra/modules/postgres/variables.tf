variable "pg_name" {
  type        = string
  description = "Nombre del servidor PostgreSQL Flexible"
}

variable "resource_group_name" {
  type        = string
  description = "RG donde se crea"
}

variable "location" {
  type        = string
  description = "Región"
}

variable "admin_login" {
  type        = string
  description = "Usuario administrador"
}

variable "admin_password" {
  type        = string
  description = "Password administrador"
}

variable "sku_name" {
  type        = string
  description = "SKU (p.ej. GP_Standard_D2ds_v5)"
}

variable "storage_mb" {
  type        = number
  description = "Tamaño de almacenamiento en MB"
}

variable "pg_version" {
  type        = string
  description = "Versión de PostgreSQL (ej: 16)"
}

variable "ha_enabled" {
  type        = bool
  description = "Alta disponibilidad habilitada"
}

variable "zone" {
  type        = string
  description = "Availability zone for PostgreSQL Flexible Server"
  default     = "1"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}
