module "cluster" {
  source = "./cluster"
}

module "kubernetes" {
  source = "./kubernetes"

  cluster_fqdn           = "${module.cluster.cluster_fqdn}"
  client_certificate     = "${module.cluster.client_certificate}"
  client_key             = "${module.cluster.client_key}"
  cluster_ca_certificate = "${module.cluster.cluster_ca_certificate}"
  # jenkins_blob_url       = "${module.cluster.jenkins_blob_url}"
}
