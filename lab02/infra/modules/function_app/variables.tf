variable "resource_group_name" {
  type        = string
  description = "RG donde se crea la Function"
}

variable "location" {
  type        = string
  description = "Región"
}

variable "func_name" {
  type        = string
  description = "Nombre de la Function App"
}

variable "storage_account_name" {
  type        = string
  description = "Nombre de la Storage Account (único global, minúsculas)"
}

variable "plan_sku_name" {
  type        = string
  description = "SKU del App Service Plan (ej: Y1)"
  default     = "Y1"
}

variable "app_settings" {
  type        = map(string)
  description = "App Settings adicionales"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}
