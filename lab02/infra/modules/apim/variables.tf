variable "apim_name" {
  type        = string
  description = "Nombre del servicio API Management"
}

variable "resource_group_name" {
  type        = string
  description = "RG donde va APIM"
}

variable "location" {
  type        = string
  description = "Región"
}

variable "publisher_name" {
  type        = string
  description = "Nombre del publicador"
}

variable "publisher_email" {
  type        = string
  description = "Correo del publicador"
}

variable "sku_name" {
  type        = string
  description = "SKU de APIM (Developer_1, Basic_1, etc.)"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}
