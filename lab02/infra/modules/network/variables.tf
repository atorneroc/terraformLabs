variable "resource_group_name" {
  type        = string
  description = "RG donde va la VNet"
}

variable "location" {
  type        = string
  description = "Región"
}

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
  description = "Nombre de la subnet para AKS"
}

variable "aks_subnet_cidr" {
  type        = string
  description = "CIDR de la subnet para AKS"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}
