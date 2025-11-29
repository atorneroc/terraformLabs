output "name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "kubelet_identity_id" {
  value = azurerm_kubernetes_cluster.this.identity[0].principal_id
}
