# Outputs the FQDN
output "cluster_fqdn" {
  value = "${azurerm_kubernetes_cluster.k8scluster.fqdn}"
}

# Outputs the client certificate
output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_certificate}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.k8scluster.kube_config.0.cluster_ca_certificate}"
}

# Outputs the kube config
output "kube_config" {
  value = "${azurerm_kubernetes_cluster.k8scluster.kube_config_raw}"
}

# Outputs the blob uri
# output "jenkins_blob_url" {
#   value = "${azurerm_storage_blob.k8sjenkinsblob.url}"
# }
