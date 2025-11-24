variable "resource_group_name" {
  type        = string
  description = "Nombre del Resource Group"
}

variable "location" {
  type        = string
  description = "Región de Azure"
}

variable "tags" {
  type        = map(string)
  description = "Tags comunes"
}
