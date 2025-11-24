variable "aks_name" {
  type        = string
  description = "Nombre del cluster AKS"
}

variable "resource_group_name" {
  type        = string
  description = "RG donde se crea AKS"
}

variable "location" {
  type        = string
  description = "Región"
}

variable "aks_dns_prefix" {
  type        = string
  description = "Prefijo DNS para el cluster"
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

variable "subnet_id" {
  type        = string
  description = "ID de la subnet para AKS"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}
