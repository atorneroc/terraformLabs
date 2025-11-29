variable "acr_name" {
  type        = string
  description = "Nombre del Azure Container Registry"
}

variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
}

variable "acr_sku" {
  type        = string
  default     = "Basic"
}

variable "tags" {
  type        = map(string)
}
