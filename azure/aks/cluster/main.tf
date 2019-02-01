# Create the azure resource group
resource "azurerm_resource_group" "k8srg" {
  name     = "terraformrg"
  location = "${var.location}"
}

# Create a random prefix for FQDN
resource "random_string" "fqdn" {
  length  = 6
  special = false
  upper   = false
  number  = false
}

# Create the Kubernetes cluster
resource "azurerm_kubernetes_cluster" "k8scluster" {
  name                = "terraformk8scluster"
  location            = "${azurerm_resource_group.k8srg.location}"
  resource_group_name = "${azurerm_resource_group.k8srg.name}"
  dns_prefix          = "${random_string.fqdn.result}"

  agent_pool_profile {
    name            = "default"
    count           = 1
    vm_size         = "Standard_B2s"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.clientId}"
    client_secret = "${var.clientSecret}"
  }
}

# Outputs the client certificate
resource "local_file" "client_certificate" {
  content = "${azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_certificate}"
  filename = "./client_certificate.pem"
}

resource "local_file" "client_key" {
  content = "${azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_key}"
  filename = "./client_key.pem"
}

resource "local_file" "cluster_ca_certificate" {
  content = "${azurerm_kubernetes_cluster.k8scluster.kube_config.0.cluster_ca_certificate}"
  filename = "./cluster_ca_certificate.pem"
}

resource "local_file" "kubeconfig" {
  content  = "${azurerm_kubernetes_cluster.k8scluster.kube_config_raw}"
  filename = "./kubeconfig"
}
