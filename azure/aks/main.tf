provider "kubernetes" {
  host = "${module.cluster.cluster_fqdn}"

  client_certificate     = "${base64decode(module.cluster.client_certificate)}"
  client_key             = "${base64decode(module.cluster.client_key)}"
  cluster_ca_certificate = "${base64decode(module.cluster.cluster_ca_certificate)}"
}

module "cluster" {
  source = "./cluster"

  location = "${var.location}"
  clientId = "${var.clientId}"
  clientSecret = "${var.clientSecret}"
  tenant = "${var.tenant}"
}

module "kubernetes" {
  source = "./kubernetes"

  jenkins_namespace = "${var.jenkins_namespace}"
}
