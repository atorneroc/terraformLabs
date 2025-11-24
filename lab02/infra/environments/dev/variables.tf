# Global / comunes
variable "location" {
  type        = string
  description = "Región"
}

variable "tags" {
  type        = map(string)
  description = "Tags globales"
}

# Resource Group
variable "resource_group_name" {
  type        = string
  description = "Nombre del Resource Group"
}

# Network
variable "vnet_name" {
  type        = string
  description = "Nombre de la VNet"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR de la VNet"
}

variable "aks_subnet_name" {
  type        = string
  description = "Nombre de la subnet de AKS"
}

variable "aks_subnet_cidr" {
  type        = string
  description = "CIDR de la subnet de AKS"
}

# AKS
variable "aks_name" {
  type        = string
  description = "Nombre del cluster AKS"
}

variable "aks_dns_prefix" {
  type        = string
  description = "Prefijo DNS del cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "Versión de Kubernetes"
}

variable "node_vm_size" {
  type        = string
  description = "Tamaño de VM para los nodos"
}

variable "node_count" {
  type        = number
  description = "Número de nodos"
}

# APIM
variable "apim_name" {
  type        = string
  description = "Nombre del API Management"
}

variable "apim_publisher_name" {
  type        = string
  description = "Nombre del publicador de APIM"
}

variable "apim_publisher_email" {
  type        = string
  description = "Correo del publicador de APIM"
}

variable "apim_sku_name" {
  type        = string
  description = "SKU de APIM"
}

# PostgreSQL
variable "pg_name" {
  type        = string
  description = "Nombre del servidor PostgreSQL Flexible"
}

variable "pg_admin_login" {
  type        = string
  description = "Usuario administrador de PostgreSQL"
}

variable "pg_admin_password" {
  type        = string
  description = "Password administrador de PostgreSQL"
}

variable "pg_sku_name" {
  type        = string
  description = "SKU de PostgreSQL"
}

variable "pg_storage_mb" {
  type        = number
  description = "Almacenamiento en MB"
}

variable "pg_version" {
  type        = string
  description = "Versión de PostgreSQL"
}

variable "pg_ha_enabled" {
  type        = bool
  description = "Alta disponibilidad habilitada"
}

variable "pg_zone" {
  type        = string
  description = "Availability zone for PostgreSQL Flexible Server"
}

# Functions (2 apps)
variable "func_billing_name" {
  type        = string
  description = "Nombre de la Function App de Billing"
}

variable "func_billing_storage_name" {
  type        = string
  description = "Storage account para la Function de Billing"
}

variable "func_util_name" {
  type        = string
  description = "Nombre de la Function App Util"
}

variable "func_util_storage_name" {
  type        = string
  description = "Storage account para la Function Util"
}

variable "func_reports_name" {
  type        = string
  description = "Nombre de la Function App Reports"
}

variable "func_reports_storage_name" {
  type        = string
  description = "Storage account para la Function Reports"
}
